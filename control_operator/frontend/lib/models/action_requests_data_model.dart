import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionRequestsDataModel extends Notifier<ActionRequestsDataModel> {
  @override
  ActionRequestsDataModel build() => this;
  @override
  bool updateShouldNotify(
    ActionRequestsDataModel previous,
    ActionRequestsDataModel next,
  ) => true;

  bool assetListUpdate = false;
  bool assetListAutoUpdate = false;
  bool serviceListUpdate = false;
  bool agentListUpdate = false;
  bool resourceListUpdate = false;
  bool dataTopicListUpdate = false;
  bool dataTopicClientListUpdate = false;
  bool transformReporterListUpdate = false;
  bool statusDetailsUpdate = false;
  bool resourceDetailsUpdate = false;
  bool agentStatusListUpdate = false;
  bool agentDetailsUpdate = false;
  bool serviceListAutoUpdate = false;
}
