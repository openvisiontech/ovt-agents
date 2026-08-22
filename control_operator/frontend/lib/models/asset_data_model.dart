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

  List<Map<String, dynamic>> _assetAbstractions = [];
  int _currentAssetIndex = -1;

  Map<String, dynamic> _assetInfo = {};
  Map<String, dynamic> _accessInfo = {};
  Map<String, dynamic> _controlInfo = {};
  Map<String, dynamic> _stateInfo = {};
  Map<String, dynamic> _operatingModeInfo = {};
  List<Map<String, dynamic>> _statusDetails = [];

  List<Map<String, dynamic>> _agentAbstractions = [];
  int _currentAgentIndex = -1;

  Map<String, dynamic> _agentInfo = {};
  List<Map<String, dynamic>> _agentStatus = [];
  Map<String, dynamic> _agentDetails = {};

  List<Map<String, dynamic>> _dataTopicList = [];
  List<Map<String, dynamic>> _schemaList = [];
  List<Map<String, dynamic>> _dataTopicClientList = [];
  final Set<String> _selectedTopicUris = {};

  List<Map<String, dynamic>> _transformReporterList = [];
  List<Map<String, dynamic>> _transformClientList = [];

  List<String> _insightMenuItems = [
    "Comp Status",
    "Agent Status",
    "Data Topic Clients",
    "Transform Reporters",
  ];
  int _currentInsightMenuItemIndex = -1;
  String _selectedInsightMenuItem = "";

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

  Map<String, dynamic> _agentConfiguration = {};
  String _agentRunningCmd = "UNKNOWN";
  String _agentControlCmd = "UNKNOWN";
  Map<String, dynamic> _agentControlParams = {};
  Map<String, dynamic> _agentUserParams = {};
  int _agentCompletionTimeout = 0;

  void moveAssetUp() {
    if (_currentAssetIndex > 0) {
      _currentAssetIndex--;
      state = this;
    }
  }

  void moveAssetDown() {
    if (_currentAssetIndex < _assetAbstractions.length - 1) {
      _currentAssetIndex++;
      state = this;
    }
  }

  void setCurrentAssetIndex(int index) {
    if (index >= 0 && index < _assetAbstractions.length) {
      _currentAssetIndex = index;
      state = this;
    }
  }

  void selectAsset() {
    if (_currentAssetIndex < 0 ||
        _currentAssetIndex >= _assetAbstractions.length) {
      return;
    }

    _assetInfo = _assetAbstractions[_currentAssetIndex];
    _assetName = _assetInfo['Name']?.toString() ?? "UNKNOWN";
    _subsystemId = _assetInfo['Address']['SubsystemId'] ?? 0;
    _nodeId = _assetInfo['Address']['NodeId'] ?? 0;
    _compId = _assetInfo['Address']['CompId'] ?? 0;
    _controlStatus = _assetInfo['ControlStatus']?.toString() ?? "UNKNOWN";
    _controlAvail =
        !(_controlStatus == "UNKNOWN" || _controlStatus == "NOT_AVAILABLE");
    _interactionMode = "WATCH";
    _subsystemStateCmd = "UNKNOWN";
    _operatingCategory = "UNKNOWN";
    _operatingMode = "UNKNOWN";

    _accessInfo = {};
    _controlInfo = {};
    _stateInfo = {};
    _operatingModeInfo = {};
    _statusDetails = [];

    _agentAbstractions = [];
    _agentStatus = [];
    _agentDetails = {};

    _dataTopicList = [];
    _schemaList = [];
    _dataTopicClientList = [];
    _selectedTopicUris.clear();

    _transformReporterList = [];
    _transformClientList = [];

    _haveAccess = "UNKNOWN";
    _appAccessRight = "UNKNOWN";
    _dataAccessRight = "UNKNOWN";
    _haveControl = "UNKNOWN";
    _subsystemState = "UNKNOWN";

    _currentAgentIndex = -1;
    _agentInfo = {};

    _agentConfiguration = {};
    _agentRunningCmd = "UNKNOWN";
    _agentControlCmd = "UNKNOWN";
    _agentControlParams = {};
    _agentUserParams = {};
    _agentCompletionTimeout = 0;

    state = this;
  }

  void moveAgentUp() {
    if (_currentAgentIndex > 0) {
      _currentAgentIndex--;
      state = this;
    }
  }

  void moveAgentDown() {
    if (_currentAgentIndex < _agentAbstractions.length - 1) {
      _currentAgentIndex++;
      state = this;
    }
  }

  void setCurrentAgentIndex(int index) {
    if (index >= 0 && index < _agentAbstractions.length) {
      _currentAgentIndex = index;
      state = this;
    }
  }

  void selectAgent() {
    if (_currentAgentIndex >= 0 && _currentAgentIndex < _agentAbstractions.length) {
      _agentInfo = _agentAbstractions[_currentAgentIndex];
      _agentConfiguration = {};
      _agentRunningCmd = "IDLE";
      _agentControlCmd = "UNKNOWN";
      _agentControlParams = {};
      _agentUserParams = {};
      _agentCompletionTimeout = 0;
      state = this;
    }
  }

  void toggleTopicSelected(String uri) {
    if (_selectedTopicUris.contains(uri)) {
      _selectedTopicUris.remove(uri);
    } else {
      _selectedTopicUris.add(uri);
    }
    state = this;
  }

  void moveInsightMenuItemUp() {
    if (_currentInsightMenuItemIndex > 0) {
      _currentInsightMenuItemIndex--;
      state = this;
    }
  }

  void moveInsightMenuItemDown() {
    if (_currentInsightMenuItemIndex < _insightMenuItems.length - 1) {
      _currentInsightMenuItemIndex++;
      state = this;
    }
  }

  void setCurrentInsightMenuItemIndex(int index) {
    if (index >= 0 && index < _insightMenuItems.length) {
      _currentInsightMenuItemIndex = index;
      state = this;
    }
  }

  void selectInsightMenuItem() {
    if (_currentInsightMenuItemIndex >= 0 &&
        _currentInsightMenuItemIndex < _insightMenuItems.length) {
      _selectedInsightMenuItem =
          _insightMenuItems[_currentInsightMenuItemIndex];
      state = this;
    }
  }

  void clear() {
    _assetAbstractions = [];
    _currentAssetIndex = -1;

    _assetInfo = {};
    _accessInfo = {};
    _controlInfo = {};
    _stateInfo = {};
    _operatingModeInfo = {};
    _statusDetails = [];

    _agentAbstractions = [];
    _currentAgentIndex = -1;
    _agentInfo = {};
    _agentStatus = [];
    _agentDetails = {};

    _dataTopicList = [];
    _schemaList = [];
    _dataTopicClientList = [];
    _selectedTopicUris.clear();
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

    _agentConfiguration = {};
    _agentRunningCmd = "UNKNOWN";
    _agentControlCmd = "UNKNOWN";
    _agentControlParams = {};
    _agentUserParams = {};
    _agentCompletionTimeout = 0;

    state = this;
  }

  void clearDataTopics() {
    _dataTopicList = [];
    _schemaList = [];
    _dataTopicClientList = [];
    _selectedTopicUris.clear();

    state = this;
  }

  // Getters
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
    "AgentUri": _agentInfo['Uri'] ?? "",
    "Configuration": json.encode(_agentConfiguration),
    "RunningCmd": _agentRunningCmd,
    "CompletionTimeout": _agentCompletionTimeout,
  };
  Map<String, dynamic> get _taskControlRec => {
    "AgentUri": _agentInfo['Uri'] ?? "",
    "ControlCmd": _agentControlCmd,
    "ControlParams": json.encode(_agentControlParams),
    "UserParams": json.encode(_agentUserParams),
  };

  List<Map<String, dynamic>> get assetAbstractions => _assetAbstractions;
  int get currentAssetIndex => _currentAssetIndex;

  Map<String, dynamic> get assetInfo => _assetInfo;
  Map<String, dynamic> get accessInfo => _accessInfo;
  Map<String, dynamic> get controlInfo => _controlInfo;
  Map<String, dynamic> get stateInfo => _stateInfo;
  Map<String, dynamic> get operatingModeInfo => _operatingModeInfo;
  List<Map<String, dynamic>> get statusDetails => _statusDetails;

  List<Map<String, dynamic>> get agentAbstractions => _agentAbstractions;
  int get currentAgentIndex => _currentAgentIndex;

  Map<String, dynamic> get agentInfo => _agentInfo;
  bool get isAgentSelected => _agentInfo.isNotEmpty;
  List<Map<String, dynamic>> get agentStatus => _agentStatus;
  Map<String, dynamic> get agentDetails => _agentDetails;

  List<Map<String, dynamic>> get dataTopicList => _dataTopicList;
  List<Map<String, dynamic>> get dataTopicClientList => _dataTopicClientList;
  Set<String> get selectedTopicUris => _selectedTopicUris;

  int get currentInsightMenuItemIndex => _currentInsightMenuItemIndex;
  List<String> get insightMenuItems => _insightMenuItems;
  String get selectedInsightMenuItem => _selectedInsightMenuItem;

  List<Map<String, dynamic>> get transformReporterList =>
      _transformReporterList;
  List<Map<String, dynamic>> get transformClientList => _transformClientList;

  Map<String, dynamic> get guiRec => _guiRec;
  Map<String, dynamic> get taskExecRec => _taskExecRec;
  Map<String, dynamic> get taskControlRec => _taskControlRec;

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

  Map<String, dynamic> get agentConfiguration => _agentConfiguration;
  String get agentRunningCmd => _agentRunningCmd;
  String get agentControlCmd => _agentControlCmd;
  Map<String, dynamic> get agentControlParams => _agentControlParams;
  Map<String, dynamic> get agentUserParams => _agentUserParams;
  int get agentCompletionTimeout => _agentCompletionTimeout;

  // Setters
  set assetAbstractions(List<Map<String, dynamic>> val) {
    _assetAbstractions = val;
    if (_currentAssetIndex >= _assetAbstractions.length) {
      _currentAssetIndex = _assetAbstractions.length - 1;
    }

    state = this;
  }

  set accessInfo(Map<String, dynamic> val) {
    _accessInfo = val;

    _haveAccess = val['HaveAccess']?.toString() ?? "UNKNOWN";
    _appAccessRight = val['AppAccessRight']?.toString() ?? "UNKNOWN";
    _dataAccessRight = val['DataAccessRight']?.toString() ?? "UNKNOWN";

    state = this;
  }

  set controlInfo(Map<String, dynamic> val) {
    _controlInfo = val;

    state = this;
  }

  set stateInfo(Map<String, dynamic> val) {
    _stateInfo = val;
    _subsystemState = val['State']?.toString() ?? "UNKNOWN";
    _haveControl = val['HaveControl']?.toString() ?? "UNKNOWN";
    
    state = this;
  }

  set statusDetails(List<Map<String, dynamic>> val) {
    _statusDetails = val;
    state = this;
  }

  set agentAbstractions(List<Map<String, dynamic>> val) {
    _agentAbstractions = val;

    if (_currentAgentIndex >= _agentAbstractions.length) {
      _currentAgentIndex = _agentAbstractions.length - 1;
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

  set schemaList(List<Map<String, dynamic>> val) {
    _schemaList = val;
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

  set interactionMode(String val) {
    _interactionMode = val;
    state = this;
  }

  set operatingMode(String val) {
    _operatingMode = val;

    if (_operatingMode == "STANDARD_OPERATING" ||
        _operatingMode == "REDUCED" ||
        _operatingMode == "RIGOROUS" ||
        _operatingMode == "SILENT" ||
        _operatingMode == "HIBERNATED") {
      _operatingCategory = "STANDARD";
    } else if (_operatingMode == "TRAINING" ||
        _operatingMode == "MAINTENANCE") {
      _operatingCategory = "ADMINISTRATIVE";
    } else {
      _operatingCategory = "UNKNOWN";
    }

    state = this;
  }

  set subsystemStateCmd(String val) {
    _subsystemStateCmd = val;
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

  set agentControlParams(Map<String, dynamic> val) {
    _agentControlParams = val;
    state = this;
  }

  set agentUserParams(Map<String, dynamic> val) {
    _agentUserParams = val;
    state = this;
  }

  set agentCompletionTimeout(int val) {
    _agentCompletionTimeout = val;
    state = this;
  }

  String? getSchemaContext(String schemaName) {
    for (var compSchema in _schemaList) {
      final schemaRecList =
          compSchema['DataTopicSchemaRecList'] as List<dynamic>? ?? [];
      for (var rec in schemaRecList) {
        if (rec['Schema']?.toString() == schemaName) {
          return rec['Context']?.toString();
        }
      }
    }
    return null;
  }
}
