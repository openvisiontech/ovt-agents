/**********************************************************************************
 * Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
 * All rights reserved. This material contains unpublished,
 * copyrighted work, which includes confidential and proprietary
 * information of Open Vision Technology, LLC..

 * Open Vision Technology, LLC. and its licensors retain all intellectual property
 * and proprietary rights in and to this software, related documentation
 * and any modifications thereto. Any use, reproduction, disclosure or
 * distribution of this software and related documentation without an express
 * license agreement from Open Vision Technology, LLC. is strictly prohibited.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **********************************************************************************
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:uli_ffi/uli.dart';
import '../providers/data_providers.dart';
import '../comms/web_rtc_client.dart';

class ProcessStreamTask {
  static final _log = Logger('ProcessStreamTask');
  static final _topicReader = StreamTopicReader();

  static void start(ProviderContainer container) {
    _runLoop(container);
  }

  static Future<void> _runLoop(ProviderContainer container) async {
    final streamData = container.read(streamDataProvider.notifier);
    final client = WebRTCClient();

    while (true) {
      try {
        if (client.streamQueue.isNotEmpty) {
          final binaryData = client.streamQueue.removeAt(0);
          final JsonTopic? topic = _topicReader.read(binaryData);
          if (topic != null) {
            _log.fine('Parsed JsonTopic: ${topic.uri}');
            streamData.addTopic(topic);
          }
        }
      } catch (e) {
        _log.severe('Error processing stream message: $e');
      }
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}
