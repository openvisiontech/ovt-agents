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

class ProcessActionRequestsTask {
  static final _log = Logger('ProcessActionRequestsTask');

  static void start(ProviderContainer container) {
    _runLoop(container);
  }

  static Future<void> _runLoop(ProviderContainer container) async {
    final actionRequests = container.read(actionRequestsProvider.notifier);
    final headerData = container.read(headerDataProvider.notifier);
    final assetData = container.read(assetDataProvider.notifier);
    final client = WebRTCClient();    
    
    int count = 0;

    // Loop interval of 10ms
    while (true) {

      // Every 50ms
      if (count % 50 == 0) {
        if (actionRequests.assetListUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_asset_abstractions", "payload": {}}),
          );
          actionRequests.assetListUpdate = false;
        }
        if (actionRequests.agentListUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_agent_abstractions", "payload": {}}),
          );
          actionRequests.agentListUpdate = false;
        }
        if (actionRequests.dataTopicListUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_data_topic_list", "payload": {}}),
          );
          actionRequests.dataTopicListUpdate = false;
        }
        if (actionRequests.schemaListUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_schema_list", "payload": {}}),
          );
          actionRequests.schemaListUpdate = false;
        }
        if (actionRequests.dataTopicClientListUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_data_topic_clients", "payload": {}}),
          );
          actionRequests.dataTopicClientListUpdate = false;
        }
        if (actionRequests.transformReporterListUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_transform_reporters", "payload": {}}),
          );
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_transform_clients", "payload": {}}),
          );
          actionRequests.transformReporterListUpdate = false;
        }
        if (actionRequests.statusDetailsUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_status_details", "payload": {}}),
          );
          actionRequests.statusDetailsUpdate = false;
        }
        if (actionRequests.agentStatusUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_agent_status", "payload": {}}),
          );
          actionRequests.agentStatusUpdate = false;
        }
        if (actionRequests.agentDetailsUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_agent_details", "payload": {}}),
          );
          actionRequests.agentDetailsUpdate = false;
        }
      }

      // Every 100ms
      if (count % 100 == 0) {
        Map<String, dynamic> guiRec = assetData.guiRec;
        guiRec['EstopButton'] = headerData.estop;
        client.chatRequestQueue.add(
          jsonEncode({"action": "set_gui_rec", "payload": guiRec}),
        );
        client.chatRequestQueue.add(
          jsonEncode({
            "action": "set_task_exec_rec",
            "payload": assetData.taskExecRec,
          }),
        );
        client.chatRequestQueue.add(
          jsonEncode({
            "action": "set_task_control_rec",
            "payload": assetData.taskControlRec,
          }),
        );
      }

      // Every 250ms
      if (count % 250 == 0) {
        if (actionRequests.assetListAutoUpdate) {
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_asset_abstractions", "payload": {}}),
          );
        }
        if(actionRequests.agentStatusAutoUpdate){
          client.chatRequestQueue.add(
            jsonEncode({"action": "get_agent_status", "payload": {}}),
          );
        }
        client.chatRequestQueue.add(
          jsonEncode({"action": "get_access_info", "payload": {}}),
        );
        client.chatRequestQueue.add(
          jsonEncode({"action": "get_control_info", "payload": {}}),
        );
        client.chatRequestQueue.add(
          jsonEncode({"action": "get_state_info", "payload": {}}),
        );
        client.chatRequestQueue.add(
          jsonEncode({"action": "get_operating_mode_info", "payload": {}}),
        );
      }
      
      await Future.delayed(const Duration(milliseconds: 10));
      count += 10;

      // Reset loop counter
      if (count >= 1000) count = 0;
    }
  }
}
