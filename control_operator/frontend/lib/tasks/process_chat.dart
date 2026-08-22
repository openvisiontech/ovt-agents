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

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../providers/data_providers.dart';
import '../comms/web_rtc_client.dart';

class ProcessChatTask{
  static final _log = Logger('ProcessChatTask');

  static void start(ProviderContainer container) {
    _runLoop(container);
  }

  static Future<void> _runLoop(ProviderContainer container) async {
    final client = WebRTCClient();
    final assetData = container.read(assetDataProvider.notifier);

    // Loop interval of 1ms
    while (true) {

      while (client.chatQueue.isNotEmpty) {
        final msgStr = client.chatQueue.removeAt(0);
        try {
          final decoded = jsonDecode(msgStr) as Map<String, dynamic>;
          final action = decoded['action'] as String?;
          final payload = decoded['payload'] as Map<String, dynamic>? ?? {};

          switch (action) {
            case 'asset_abstractions':
              assetData.assetAbstractions = List<Map<String, dynamic>>.from(
                payload['subsystemabstractions'] ?? [],
              );
              break;
            case 'access_info':
              assetData.accessInfo = payload['accessclient'] ?? {};
              break;
            case 'control_info':
              assetData.controlInfo = payload['controlclient'] ?? {};
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
            case 'agent_abstractions':
              assetData.agentAbstractions = List<Map<String, dynamic>>.from(
                payload['agentabstractions'] ?? [],
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
                payload['compdatatopiclist'] ?? [],
              );
              break;
            case 'schema_list':
              assetData.schemaList = List<Map<String, dynamic>>.from(
                payload['compdatatopicschemalist'] ?? [],
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
            case 'transform_clients':
              assetData.transformClientList = List<Map<String, dynamic>>.from(
                payload['transformclientlist'] ?? [],
              );
              break;
          }
        } catch (e) {
          _log.severe('Error processing chat message: $e');
        }
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
}
