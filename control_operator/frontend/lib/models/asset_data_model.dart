import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetDataModel extends Notifier<AssetDataModel> {
  @override
  AssetDataModel build() => this;
  @override
  bool updateShouldNotify(AssetDataModel previous, AssetDataModel next) => true;

  Map<String, dynamic> _assetAccessInfo = {};
  Map<String, dynamic> _assetControlInfo = {};
  Map<String, dynamic> _stateInfo = {};
  Map<String, dynamic> _operatingModeInfo = {};
  List<Map<String, dynamic>> _statusDetails = [];
  List<Map<String, dynamic>> _agentList = [];
  List<Map<String, dynamic>> _agentStatus = [];
  Map<String, dynamic> _agentDetails = {};
  List<Map<String, dynamic>> _dataTopicList = [];
  List<Map<String, dynamic>> _dataTopicClientList = [];
  List<Map<String, dynamic>> _transformReporterList = [];
  List<Map<String, dynamic>> _transformClientList = [];

  Map<String, dynamic> get _guiRec => {
    "UserPresent": "PRESENT",
    "SubsystemManager": {
      "SubsystemId": _subsystemId,
      "NodeId": _nodeId,
      "CompId": _compId,
    },
    "InteractionMode": _interactionMode,
    "EstopButton": _estopButton,
    "SubsystemStateCmd": _subsystemStateCmd,
    "OperatingCategory": _operatingCategory,
    "OperatingMode": _operatingMode,
    "AgentUri": _selectedAgentUri,
    "AgentConfiguration": json.encode(_agentConfiguration),
    "AgentRunningCmd": _agentRunningCmd,
    "AgentControlCmd": _agentControlCmd,
    "UserParams": json.encode(_userParams),
    "AgentCompletionTimeout": _agentCompletionTimeout,
  };
  Map<String, dynamic> _joystick1Rec = {"XAxisPosition": 0, "YAxisPosition": 0};
  Map<String, dynamic> _joystick2Rec = {"XAxisPosition": 0, "YAxisPosition": 0};

  int _currentAgentIndex = 0;
  String _currentAgentName = "UNKNOWN";
  String _currentAgentUri = "";
  String _userPresent = "UNKNOWN";

  String _assetName = "";
  int _subsystemId = 0;
  int _nodeId = 0;
  int _compId = 0;
  String _controlStatus = "UNKNOWN";
  bool _controlAvail = false;

  String _haveAccess = "UNKNOWN";
  String _appAccessRight = "UNKNOWN";
  String _dataAccessRight = "UNKNOWN";
  String _haveControl = "UNKNOWN";
  String _interactionMode = "UNKNOWN";
  String _estopButton = "UNKNOWN";
  String _subsystemStateCmd = "UNKNOWN";
  String _operatingCategory = "UNKNOWN";
  String _operatingMode = "UNKNOWN";
  String _selectedAgentName = "";
  String _selectedAgentUri = "";
  Map<String, dynamic> _agentConfiguration = {};
  String _agentRunningCmd = "UNKNOWN";
  String _agentControlCmd = "UNKNOWN";
  Map<String, dynamic> _userParams = {};
  int _agentCompletionTimeout = 0;

  List<String> agentItems = [];

  void moveAgentUp() {
    if (_currentAgentIndex > 0) {
      _currentAgentIndex--;
      _updateCurrentAgentInfo();
      state = this;
    }
  }

  void moveAgentDown() {
    if (_currentAgentIndex < agentItems.length - 1) {
      _currentAgentIndex++;
      _updateCurrentAgentInfo();
      state = this;
    }
  }

  void setCurrentAgentIndex(int index) {
    if (index >= 0 && index < agentItems.length) {
      _currentAgentIndex = index;
      _updateCurrentAgentInfo();
      state = this;
    }
  }

  void _updateCurrentAgentInfo() {
    if (_agentList.isNotEmpty && _currentAgentIndex < _agentList.length) {
      final agent = _agentList[_currentAgentIndex];
      if (agent is Map) {
        _currentAgentName = agent['Name']?.toString() ?? "UNKNOWN";
        _currentAgentUri = agent['Uri']?.toString() ?? "";
      }
    }
  }

  void selectAgent() {
    if (_currentAgentIndex >= 0 && _currentAgentIndex < agentItems.length) {
      _selectedAgentName = _currentAgentName;
      _selectedAgentUri = _currentAgentUri;
      _agentConfiguration = {};
      _agentRunningCmd = "IDLE";
      _agentControlCmd = "UNKNOWN";
      _userParams = {};
      _agentCompletionTimeout = 0;
      state = this;
    }
  }

  // Getters
  Map<String, dynamic> get assetAccessInfo => _assetAccessInfo;
  Map<String, dynamic> get assetControlInfo => _assetControlInfo;
  Map<String, dynamic> get stateInfo => _stateInfo;
  Map<String, dynamic> get operatingModeInfo => _operatingModeInfo;
  List<Map<String, dynamic>> get statusDetails => _statusDetails;
  List<Map<String, dynamic>> get agentList => _agentList;
  List<Map<String, dynamic>> get agentStatus => _agentStatus;
  Map<String, dynamic> get agentDetails => _agentDetails;
  List<Map<String, dynamic>> get dataTopicList => _dataTopicList;
  List<Map<String, dynamic>> get dataTopicClientList => _dataTopicClientList;
  List<Map<String, dynamic>> get transformReporterList =>
      _transformReporterList;
  List<Map<String, dynamic>> get transformClientList => _transformClientList;

  Map<String, dynamic> get guiRec => _guiRec;
  Map<String, dynamic> get joystick1Rec => _joystick1Rec;
  Map<String, dynamic> get joystick2Rec => _joystick2Rec;

  int get currentAgentIndex => _currentAgentIndex;
  String get currentAgentName => _currentAgentName;
  String get currentAgentUri => _currentAgentUri;
  String get userPresent => _userPresent;

  String get assetName => _assetName;
  int get subsystemId => _subsystemId;
  int get nodeId => _nodeId;
  int get compId => _compId;
  String get controlStatus => _controlStatus;
  bool get controlAvail => _controlAvail;

  String get haveAccess => _haveAccess;
  String get appAccessRight => _appAccessRight;
  String get dataAccessRight => _dataAccessRight;
  String get haveControl => _haveControl;
  String get interactionMode => _interactionMode;
  String get estopButton => _estopButton;
  String get subsystemStateCmd => _subsystemStateCmd;
  String get operatingCategory => _operatingCategory;
  String get operatingMode => _operatingMode;
  String get selectedAgentName => _selectedAgentName;
  String get selectedAgentUri => _selectedAgentUri;
  String get agentRunningCmd => _agentRunningCmd;
  String get agentControlCmd => _agentControlCmd;
  Map<String, dynamic> get userParams => _userParams;
  int get agentCompletionTimeout => _agentCompletionTimeout;

  // Setters
  set assetAccessInfo(Map<String, dynamic> val) {
    _assetAccessInfo = val;

    _haveAccess = val['HaveAccess']?.toString() ?? "UNKNOWN";
    _appAccessRight = val['AppAccessRight']?.toString() ?? "UNKNOWN";
    _dataAccessRight = val['DataAccessRight']?.toString() ?? "UNKNOWN";

    state = this;
  }

  set assetControlInfo(Map<String, dynamic> val) {
    _assetControlInfo = val;

    _haveControl = val['HaveControl']?.toString() ?? "UNKNOWN";

    state = this;
  }

  set stateInfo(Map<String, dynamic> val) {
    _stateInfo = val;
    state = this;
  }

  set statusDetails(List<Map<String, dynamic>> val) {
    _statusDetails = val;
    state = this;
  }

  set agentList(List<Map<String, dynamic>> val) {
    _agentList = val;
    agentItems = val.map((e) {
      return "${e['Name']} (${e['Uri']})";
    }).toList();
    if (agentItems.isEmpty) {
      agentItems = List.generate(20, (index) => "Agent Item ${index + 1}");
    }
    state = this;
  }

  set agentStatus(List<Map<String, dynamic>> val) {
    _agentStatus = val;
    state = this;
  }

  set agentDetails(Map<String, dynamic> val) {
    _agentDetails = val;
    state = this;
  }

  set dataTopicList(List<Map<String, dynamic>> val) {
    _dataTopicList = val;
    state = this;
  }

  set dataTopicClientList(List<Map<String, dynamic>> val) {
    _dataTopicClientList = val;
    state = this;
  }

  set transformReporterList(List<Map<String, dynamic>> val) {
    _transformReporterList = val;
    state = this;
  }

  set transformClientList(List<Map<String, dynamic>> val) {
    _transformClientList = val;
    state = this;
  }

  set operatingModeInfo(Map<String, dynamic> val) {
    _operatingModeInfo = val;
    state = this;
  }

  set currentAgentIndex(int val) {
    _currentAgentIndex = val;
    state = this;
  }

  set currentAgentName(String val) {
    _currentAgentName = val;
    state = this;
  }

  set currentAgentUri(String val) {
    _currentAgentUri = val;
    state = this;
  }

  set userPresent(String val) {
    _userPresent = val;
    state = this;
  }

  set assetName(String val) {
    _assetName = val;
    state = this;
  }

  set subsystemId(int val) {
    _subsystemId = val;
    state = this;
  }

  set nodeId(int val) {
    _nodeId = val;
    state = this;
  }

  set compId(int val) {
    _compId = val;
    state = this;
  }

  set controlStatus(String val) {
    _controlStatus = val;
    state = this;
  }

  set controlAvail(bool val) {
    _controlAvail = val;
    state = this;
  }

  set haveAccess(String val) {
    _haveAccess = val;
    state = this;
  }

  set appAccessRight(String val) {
    _appAccessRight = val;
    state = this;
  }

  set dataAccessRight(String val) {
    _dataAccessRight = val;
    state = this;
  }

  set haveControl(String val) {
    _haveControl = val;
    state = this;
  }

  set interactionMode(String val) {
    _interactionMode = val;
    state = this;
  }

  set estopButton(String val) {
    _estopButton = val;
    state = this;
  }

  set subsystemStateCmd(String val) {
    _subsystemStateCmd = val;
    state = this;
  }

  set operatingCategory(String val) {
    _operatingCategory = val;
    state = this;
  }

  set operatingMode(String val) {
    _operatingMode = val;
    state = this;
  }

  set selectedAgentName(String val) {
    _selectedAgentName = val;
    state = this;
  }

  set selectedAgentUri(String val) {
    _selectedAgentUri = val;
    state = this;
  }

  set agentRunningCmd(String val) {
    _agentRunningCmd = val;
    state = this;
  }

  set agentControlCmd(String val) {
    _agentControlCmd = val;
    state = this;
  }

  set userParams(Map<String, dynamic> val) {
    _userParams = val;
    state = this;
  }

  set agentCompletionTimeout(int val) {
    _agentCompletionTimeout = val;
    state = this;
  }
}
