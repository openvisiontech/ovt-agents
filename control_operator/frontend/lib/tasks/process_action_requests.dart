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
import '../providers/data_providers.dart';
import '../comms/web_rtc_client.dart';

void processActionRequests(dynamic message) async {
  if (message is! ProviderContainer) return;
  final container = message;
  int count = 0;

  // Loop interval of 10ms
  while (true) {
    await Future.delayed(const Duration(milliseconds: 10));
    count += 10;

    final actionRequests = container.read(actionRequestsProvider.notifier);
    final assetData = container.read(assetDataProvider.notifier);
    final webrtcClient = WebRTCClient();

    // Every 50ms
    if (count % 50 == 0) {
      if (actionRequests.assetListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_all_abstractions", "payload": {}}),
        );
        actionRequests.assetListUpdate = false;
      }
      if (actionRequests.agentListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_agent_list", "payload": {}}),
        );
        actionRequests.agentListUpdate = false;
      }
      if (actionRequests.dataTopicListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_data_topic_list", "payload": {}}),
        );
        actionRequests.dataTopicListUpdate = false;
      }
      if (actionRequests.schemaListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_schema_list", "payload": {}}),
        );
        actionRequests.schemaListUpdate = false;
      }
      if (actionRequests.dataTopicClientListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_data_topic_clients", "payload": {}}),
        );
        actionRequests.dataTopicClientListUpdate = false;
      }
      if (actionRequests.transformReporterListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_transform_reporters", "payload": {}}),
        );
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_transform_clients", "payload": {}}),
        );
        actionRequests.transformReporterListUpdate = false;
      }
      if (actionRequests.statusDetailsUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_status_details", "payload": {}}),
        );
        actionRequests.statusDetailsUpdate = false;
      }
      if (actionRequests.agentStatusUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_agent_status", "payload": {}}),
        );
        actionRequests.agentStatusUpdate = false;
      }
      if (actionRequests.agentDetailsUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_agent_details", "payload": {}}),
        );
        actionRequests.agentDetailsUpdate = false;
      }
    }

    // Every 100ms
    if (count % 100 == 0) {
      webrtcClient.chatRequestQueue.add(
        jsonEncode({"action": "set_gui_rec", "payload": assetData.guiRec}),
      );
      webrtcClient.chatRequestQueue.add(
        jsonEncode({
          "action": "set_task_exec_rec",
          "payload": assetData.taskExecRec,
        }),
      );
      webrtcClient.chatRequestQueue.add(
        jsonEncode({
          "action": "set_task_control_rec",
          "payload": assetData.taskControlRec,
        }),
      );
    }

    // Every 250ms
    if (count % 250 == 0) {
      if (actionRequests.assetListAutoUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_all_abstractions", "payload": {}}),
        );
      }
      webrtcClient.chatRequestQueue.add(
        jsonEncode({"action": "get_access_info", "payload": {}}),
      );
      webrtcClient.chatRequestQueue.add(
        jsonEncode({"action": "get_control_info", "payload": {}}),
      );
      webrtcClient.chatRequestQueue.add(
        jsonEncode({"action": "get_state_info", "payload": {}}),
      );
      webrtcClient.chatRequestQueue.add(
        jsonEncode({"action": "get_operating_mode_info", "payload": {}}),
      );
    }

    // Reset loop counter
    if (count >= 1000) count = 0;
  }
}
