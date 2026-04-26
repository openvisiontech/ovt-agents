import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../comms/web_rtc_client.dart';

void processChat(dynamic message) async {
  if (message is! ProviderContainer) return;
  final container = message;
  int count = 0;

  // Loop interval of 10ms
  while (true) {
    await Future.delayed(const Duration(milliseconds: 10));
    count += 10;

    final webrtcClient = WebRTCClient();

    final domainData = container.read(domainDataProvider.notifier);
    final assetData = container.read(assetDataProvider.notifier);
    final guiData = container.read(guiDataProvider.notifier);

    while (webrtcClient.chatQueue.isNotEmpty) {
      final msgStr = webrtcClient.chatQueue.removeAt(0);
      try {
        final decoded = jsonDecode(msgStr) as Map<String, dynamic>;
        final action = decoded['action'] as String?;
        final payload = decoded['payload'] as Map<String, dynamic>? ?? {};

        switch (action) {
          case 'all_subsystem_abstractions':
            domainData.subsystemAbstractions = List<Map<String, dynamic>>.from(
              payload['subsystemabstractions'] ?? [],
            );
            break;
          case 'asset_access_info':
            assetData.assetAccessInfo = payload['accessclient'] ?? {};
            break;
          case 'asset_control_info':
            assetData.assetControlInfo = payload['controlclient'] ?? {};
            break;
          case 'state_info':
            assetData.stateInfo = payload['stateclient'] ?? {};
            break;
          case 'operating_mode_info':
            assetData.operatingModeInfo = payload['operatingmodeclient'] ?? {};
            break;
          case 'status_details':
            assetData.statusDetails = List<Map<String, dynamic>>.from(
              payload['statusdetails'] ?? [],
            );
            break;
          case 'available_agents':
            guiData.showAssetLeftSidebar();
            assetData.agentList = List<Map<String, dynamic>>.from(
              payload['agentlist'] ?? [],
            );
            break;
          case 'agent_status':
            assetData.agentStatus = List<Map<String, dynamic>>.from(
              payload['agentstatuslist'] ?? [],
            );
            break;
          case 'agent_details':
            assetData.agentDetails = payload['agentdetails'] ?? {};
            break;
          case 'data_topic_list':
            assetData.dataTopicList = List<Map<String, dynamic>>.from(
              payload['datatopiclist'] ?? [],
            );
            break;
          case 'data_topic_clients':
            assetData.dataTopicClientList = List<Map<String, dynamic>>.from(
              payload['datatopicclientlist'] ?? [],
            );
            break;
          case 'transform_reporters':
            assetData.transformReporterList = List<Map<String, dynamic>>.from(
              payload['transformreporterlist'] ?? [],
            );
            break;
          case 'transform_reporters_clients':
            assetData.transformClientList = List<Map<String, dynamic>>.from(
              payload['transformclientlist'] ?? [],
            );
            break;
        }
      } catch (e) {
        // Ignore decoding errors or unrecognized patterns silently in loop
      }
    }

    // Reset loop counter
    if (count >= 1000) count = 0;
  }
}
