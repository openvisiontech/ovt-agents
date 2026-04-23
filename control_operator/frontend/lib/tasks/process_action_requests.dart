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
    final webrtcClient = WebRTCClient();

    // Every 50ms
    if (count % 50 == 0) {
      if (actionRequests.assetListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_all_control_abstractions", "payload": {}}),
        );
        actionRequests.assetListUpdate = false;
      }
      if (actionRequests.agentListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_available_agents", "payload": {}}),
        );
        actionRequests.agentListUpdate = false;
      }
      if (actionRequests.dataTopicListUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_data_topic_list", "payload": {}}),
        );
        actionRequests.dataTopicListUpdate = false;
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

    // Every 250ms
    if (count % 250 == 0) {
      if (actionRequests.assetListAutoUpdate) {
        webrtcClient.chatRequestQueue.add(
          jsonEncode({"action": "get_all_control_abstractions", "payload": {}}),
        );
      }
      webrtcClient.chatRequestQueue.add(
        jsonEncode({"action": "get_asset_access_info", "payload": {}}),
      );
      webrtcClient.chatRequestQueue.add(
        jsonEncode({"action": "get_asset_control_info", "payload": {}}),
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
