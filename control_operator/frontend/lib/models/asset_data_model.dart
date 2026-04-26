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

class AssetDataModel extends Notifier<AssetDataModel> {
  @override
  AssetDataModel build() => this;
  @override
  bool updateShouldNotify(AssetDataModel previous, AssetDataModel next) => true;

  Map<String, dynamic> _assetInfo = {};
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
    "UserPresent": "UNKNOWN", //will be filled later
    "SubsystemManager": {
      "SubsystemId": _subsystemId,
      "NodeId": _nodeId,
      "CompId": _compId,
    },
    "InteractionMode": _interactionMode,
    "EstopButton": "UNKNOWN", //will be filled later
    "SubsystemStateCmd": _subsystemStateCmd,
    "OperatingCategory": _operatingCategory,
    "OperatingMode": _operatingMode,
  };
  Map<String, dynamic> get _taskExecRec => {
    "AgentUri": _selectedAgentUri,
    "AgentConfiguration": json.encode(_agentConfiguration),
    "AgentRunningCmd": _agentRunningCmd,
    "AgentControlCmd": _agentControlCmd,
    "ControlParameters": json.encode(_controlParameters),
    "UserParams": json.encode(_userParams),
    "AgentCompletionTimeout": _agentCompletionTimeout,
  };
  Map<String, dynamic> _joystick1Rec = {"XAxisPosition": 0, "YAxisPosition": 0};
  Map<String, dynamic> _joystick2Rec = {"XAxisPosition": 0, "YAxisPosition": 0};

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
  String _subsystemState = "UNKNOWN";

  String _interactionMode = "UNKNOWN";
  String _subsystemStateCmd = "UNKNOWN";
  String _operatingCategory = "UNKNOWN";
  String _operatingMode = "UNKNOWN";

  int _currentAgentIndex = 0;
  String _currentAgentName = "UNKNOWN";
  String _currentAgentUri = "";
  String _selectedAgentName = "";
  String _selectedAgentUri = "";
  Map<String, dynamic> _agentConfiguration = {};
  String _agentRunningCmd = "UNKNOWN";
  String _agentControlCmd = "UNKNOWN";
  Map<String, dynamic> _controlParameters = {};
  Map<String, dynamic> _userParams = {};
  int _agentCompletionTimeout = 0;

  List<String> agentItems = [];

  void _updateCurrentAgentInfo() {
    if (_agentList.isNotEmpty && _currentAgentIndex < _agentList.length) {
      final agent = _agentList[_currentAgentIndex];
      _currentAgentName = agent['Name']?.toString() ?? "UNKNOWN";
      _currentAgentUri = agent['Uri']?.toString() ?? "";
    }
  }

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

  void selectAgent() {
    if (_currentAgentIndex >= 0 && _currentAgentIndex < agentItems.length) {
      _selectedAgentName = _currentAgentName;
      _selectedAgentUri = _currentAgentUri;
      _agentConfiguration = {};
      _agentRunningCmd = "IDLE";
      _agentControlCmd = "UNKNOWN";
      _controlParameters = {};
      _userParams = {};
      _agentCompletionTimeout = 0;
      state = this;
    }
  }

  void clear() {
    _assetInfo = {};
    _assetAccessInfo = {};
    _assetControlInfo = {};
    _stateInfo = {};
    _operatingModeInfo = {};
    _statusDetails = [];
    _agentList = [];
    _agentStatus = [];
    _agentDetails = {};
    _dataTopicList = [];
    _dataTopicClientList = [];
    _transformReporterList = [];
    _transformClientList = [];

    _assetName = "";
    _subsystemId = 0;
    _nodeId = 0;
    _compId = 0;
    _controlStatus = "UNKNOWN";
    _controlAvail = false;

    _haveAccess = "UNKNOWN";
    _appAccessRight = "UNKNOWN";
    _dataAccessRight = "UNKNOWN";
    _haveControl = "UNKNOWN";
    _subsystemState = "UNKNOWN";

    _interactionMode = "UNKNOWN";
    _subsystemStateCmd = "UNKNOWN";
    _operatingCategory = "UNKNOWN";
    _operatingMode = "UNKNOWN";

    _currentAgentIndex = 0;
    _currentAgentName = "UNKNOWN";
    _currentAgentUri = "";
    _selectedAgentName = "UNKNOWN";
    _selectedAgentUri = "";
    _agentConfiguration = {};
    _agentRunningCmd = "UNKNOWN";
    _agentControlCmd = "UNKNOWN";
    _controlParameters = {};
    _userParams = {};
    _agentCompletionTimeout = 0;
    agentItems = [];

    state = this;
  }

  // Getters
  Map<String, dynamic> get assetInfo => _assetInfo;
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
  Map<String, dynamic> get taskExecRec => _taskExecRec;
  Map<String, dynamic> get joystick1Rec => _joystick1Rec;
  Map<String, dynamic> get joystick2Rec => _joystick2Rec;

  int get currentAgentIndex => _currentAgentIndex;
  String get currentAgentName => _currentAgentName;
  String get currentAgentUri => _currentAgentUri;

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
  String get subsystemState => _subsystemState;

  String get interactionMode => _interactionMode;
  String get subsystemStateCmd => _subsystemStateCmd;
  String get operatingCategory => _operatingCategory;
  String get operatingMode => _operatingMode;

  String get selectedAgentName => _selectedAgentName;
  String get selectedAgentUri => _selectedAgentUri;
  Map<String, dynamic> get agentConfiguration => _agentConfiguration;
  String get agentRunningCmd => _agentRunningCmd;
  String get agentControlCmd => _agentControlCmd;
  Map<String, dynamic> get controlParameters => _controlParameters;
  Map<String, dynamic> get userParams => _userParams;
  int get agentCompletionTimeout => _agentCompletionTimeout;

  // Setters
  set assetInfo(Map<String, dynamic> val) {
    _assetInfo = val;

    _assetName = val['Name']?.toString() ?? "UNKNOWN";
    _subsystemId = val['Address']['SubsystemId'] ?? 0;
    _nodeId = val['Address']['NodeId'] ?? 0;
    _compId = val['Address']['CompId'] ?? 0;
    _controlStatus = val['ControlStatus']?.toString() ?? "UNKNOWN";
    _controlAvail =
        !(_controlStatus == "UNKNOWN" || _controlStatus == "NOT_AVAILABLE");
    _interactionMode = 'WATCH';

    state = this;
  }

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
    _subsystemState = val['State']?.toString() ?? "UNKNOWN";

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

  set interactionMode(String val) {
    _interactionMode = val;
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

  set agentConfiguration(Map<String, dynamic> val) {
    _agentConfiguration = val;
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

  set controlParameters(Map<String, dynamic> val) {
    _controlParameters = val;
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
