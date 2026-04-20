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
  Map<String, dynamic> _statusDetails = {};
  List<dynamic> _agentList = [];

  int _currentAgentIndex = 0;
  String _currentAgentName = "UNKNOWN";
  String _currentAgentUri = "";
  String _userPresent = "UNKNOWN";
  dynamic _subsystemId;
  dynamic _nodeId;
  dynamic _compId;
  String _interactionMode = "UNKNOWN";
  String _estopButton = "UNKNOWN";
  String _subsystemStateCmd = "UNKNOWN";
  String _operatingCategory = "UNKNOWN";
  String _operatingMode = "UNKNOWN";
  String _selectedAgentName = "";
  String _selectedAgentUri = "";
  String _agentRunningCmd = "UNKNOWN";
  String _agentControlCmd = "UNKNOWN";
  String _userParams = "";
  int _agentCompletionTimeout = 0;

  List<String> agentItems = List.generate(
    20,
    (index) => "Agent Item ${index + 1}",
  );

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
      _agentRunningCmd = "UNKNOWN";
      _agentControlCmd = "UNKNOWN";
      _userParams = "";
      _agentCompletionTimeout = 0;
      state = this;
    }
  }

  // Getters
  Map<String, dynamic> get assetAccessInfo => _assetAccessInfo;
  Map<String, dynamic> get assetControlInfo => _assetControlInfo;
  Map<String, dynamic> get stateInfo => _stateInfo;
  Map<String, dynamic> get operatingModeInfo => _operatingModeInfo;
  Map<String, dynamic> get statusDetails => _statusDetails;
  List<dynamic> get agentList => _agentList;
  int get currentAgentIndex => _currentAgentIndex;
  String get currentAgentName => _currentAgentName;
  String get currentAgentUri => _currentAgentUri;
  String get userPresent => _userPresent;
  dynamic get subsystemId => _subsystemId;
  dynamic get nodeId => _nodeId;
  dynamic get compId => _compId;
  String get interactionMode => _interactionMode;
  String get estopButton => _estopButton;
  String get subsystemStateCmd => _subsystemStateCmd;
  String get operatingCategory => _operatingCategory;
  String get operatingMode => _operatingMode;
  String get selectedAgentName => _selectedAgentName;
  String get selectedAgentUri => _selectedAgentUri;
  String get agentRunningCmd => _agentRunningCmd;
  String get agentControlCmd => _agentControlCmd;
  String get userParams => _userParams;
  int get agentCompletionTimeout => _agentCompletionTimeout;

  // Setters
  set assetAccessInfo(Map<String, dynamic> val) {
    _assetAccessInfo = val;
    state = this;
  }

  set assetControlInfo(Map<String, dynamic> val) {
    _assetControlInfo = val;
    state = this;
  }

  set stateInfo(Map<String, dynamic> val) {
    _stateInfo = val;
    state = this;
  }

  set operatingModeInfo(Map<String, dynamic> val) {
    _operatingModeInfo = val;
    state = this;
  }

  set statusDetails(Map<String, dynamic> val) {
    _statusDetails = val;
    state = this;
  }

  set agentList(List<dynamic> val) {
    _agentList = val;
    agentItems = val.map((e) {
      if (e is Map) {
        return "${e['Name']} (${e['Uri']})";
      }
      return "Unknown Agent";
    }).toList();
    if (agentItems.isEmpty) {
      agentItems = List.generate(20, (index) => "Agent Item ${index + 1}");
    }
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

  set subsystemId(val) {
    _subsystemId = val;
    state = this;
  }

  set nodeId(val) {
    _nodeId = val;
    state = this;
  }

  set compId(val) {
    _compId = val;
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

  set userParams(String val) {
    _userParams = val;
    state = this;
  }

  set agentCompletionTimeout(int val) {
    _agentCompletionTimeout = val;
    state = this;
  }
}
