import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

class WebRTCClient {
  static final WebRTCClient _instance = WebRTCClient._internal();
  factory WebRTCClient() => _instance;
  WebRTCClient._internal();

  final _log = Logger('WebRTCClient');

  RTCDataChannel? _chatChannel;
  RTCDataChannel? _streamChannel;
  RTCPeerConnection? _peerConnection;
  WebSocketChannel? _signalingChannel;

  // The 4 async queues
  List<String> chatRequestQueue = [];
  List<dynamic> streamRequestQueue = [];
  List<String> chatQueue = [];
  List<dynamic> streamQueue = [];

  bool _isProcessing = false;

  Future<void> connect(String signalingUrl, int retryIntervalMs) async {
    _startAsyncTasks();
    _connectWithRetry(signalingUrl, retryIntervalMs);
  }

  Future<void> _connectWithRetry(
    String signalingUrl,
    int retryIntervalMs,
  ) async {
    while (_isProcessing) {
      try {
        _log.info('Attempting WebRTC signaling connection to $signalingUrl');
        _signalingChannel = WebSocketChannel.connect(Uri.parse(signalingUrl));

        await _signalingChannel!.ready;

        final completer = Completer<void>();

        _signalingChannel!.stream.listen(
          _handleSignalingMessage,
          onError: (e) {
            _log.warning("Signaling error: $e");
            if (!completer.isCompleted) completer.complete();
          },
          onDone: () {
            _log.info("Signaling connection closed");
            if (!completer.isCompleted) completer.complete();
          },
          cancelOnError: true,
        );

        await _createPeerConnection(signalingUrl);
        await completer.future;
      } catch (e) {
        _log.warning("Error connecting to WebRTC signaling: $e");
      }

      if (!_isProcessing) break;

      _log.info('Retrying WebRTC connection in $retryIntervalMs ms...');
      _cleanupConnection();
      await Future.delayed(Duration(milliseconds: retryIntervalMs));
    }
  }

  void _cleanupConnection() {
    _chatChannel?.close();
    _streamChannel?.close();
    _peerConnection?.close();
    _signalingChannel?.sink.close();
    _chatChannel = null;
    _streamChannel = null;
    _peerConnection = null;
    _signalingChannel = null;
  }

  void _startAsyncTasks() {
    _isProcessing = true;
    _processChatRequestQueue();
    _processStreamRequestQueue();
  }

  Future<void> _processChatRequestQueue() async {
    while (_isProcessing) {
      if (chatRequestQueue.isNotEmpty && _chatChannel != null) {
        final msg = chatRequestQueue.removeAt(0);
        _chatChannel!.send(RTCDataChannelMessage(msg));
      }
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  Future<void> _processStreamRequestQueue() async {
    while (_isProcessing) {
      if (streamRequestQueue.isNotEmpty && _streamChannel != null) {
        final msg = streamRequestQueue.removeAt(0);
        // Assuming stream requests serialize to string for now, could be binary
        _streamChannel!.send(
          RTCDataChannelMessage.fromBinary(
            Uint8List.fromList(json.encode(msg).codeUnits),
          ),
        );
      }
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  Future<void> _createPeerConnection(String signalingUrl) async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan',
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        _log.info(
          'WebRTC connection successfully established to $signalingUrl',
        );
      }
    };

    _peerConnection!.onIceCandidate = (candidate) {
      if (_signalingChannel != null) {
        _signalingChannel!.sink.add(
          json.encode({
            'type': 'candidate',
            'candidate': {
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMLineIndex': candidate.sdpMLineIndex,
            },
          }),
        );
      }
    };

    _peerConnection!.onDataChannel = (RTCDataChannel channel) {
      _setupDataChannel(channel);
    };

    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()..ordered = true;
    _chatChannel = await _peerConnection!.createDataChannel(
      "chat_channel",
      dataChannelDict,
    );
    _setupDataChannel(_chatChannel!);

    RTCDataChannelInit binaryDataChannelDict = RTCDataChannelInit()
      ..ordered = true;
    _streamChannel = await _peerConnection!.createDataChannel(
      "stream_channel",
      binaryDataChannelDict,
    );
    _setupDataChannel(_streamChannel!);

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    if (_signalingChannel != null) {
      _signalingChannel!.sink.add(
        json.encode({'type': 'offer', 'sdp': offer.sdp}),
      );
    }
  }

  void _setupDataChannel(RTCDataChannel channel) {
    if (channel.label == 'chat_channel') {
      _chatChannel = channel;
      channel.onMessage = (RTCDataChannelMessage message) {
        if (!message.isBinary) {
          _log.fine('Chat message received');
          chatQueue.add(message.text);
        }
      };
    } else if (channel.label == 'stream_channel') {
      _streamChannel = channel;
      channel.onMessage = (RTCDataChannelMessage message) {
        if (message.isBinary) {
          _log.fine('Stream message received');
          // Queue the raw data
          streamQueue.add(message.binary);
        }
      };
    }
  }

  Future<void> _handleSignalingMessage(dynamic message) async {
    final Map<String, dynamic> msg = json.decode(message);
    final String type = msg['type'];

    switch (type) {
      case 'offer':
        await _peerConnection!.setRemoteDescription(
          RTCSessionDescription(msg['sdp'], type),
        );
        final answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        _signalingChannel!.sink.add(
          json.encode({'type': 'answer', 'sdp': answer.sdp}),
        );
        break;
      case 'answer':
        await _peerConnection!.setRemoteDescription(
          RTCSessionDescription(msg['sdp'], type),
        );
        break;
      case 'candidate':
        final candidateMap = msg['candidate'];
        RTCIceCandidate candidate = RTCIceCandidate(
          candidateMap['candidate'],
          candidateMap['sdpMid'],
          candidateMap['sdpMLineIndex'],
        );
        await _peerConnection!.addCandidate(candidate);
        break;
    }
  }

  void dispose() {
    _isProcessing = false;
    _cleanupConnection();
  }
}
