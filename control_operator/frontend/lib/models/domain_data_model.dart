import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainDataModel extends Notifier<DomainDataModel> {
  @override
  DomainDataModel build() => this;
  @override
  bool updateShouldNotify(DomainDataModel previous, DomainDataModel next) =>
      true;

  List<dynamic> _subsystemControlAbstractions = [];
  int _currentAssetIndex = -1;
  dynamic _currentAssetSubsystemId;
  dynamic _currentAssetNodeId;
  dynamic _currentAssetCompId;
  String _currentAssetName = "";
  String _currentAssetControlStatus = "";
  bool _currentAssetControlAvail = false;

  List<String> assetItems = [];

  List<dynamic> get subsystemControlAbstractions =>
      _subsystemControlAbstractions;
  int get currentAssetIndex => _currentAssetIndex;
  dynamic get currentAssetSubsystemId => _currentAssetSubsystemId;
  dynamic get currentAssetNodeId => _currentAssetNodeId;
  dynamic get currentAssetCompId => _currentAssetCompId;
  String get currentAssetName => _currentAssetName;
  String get currentAssetControlStatus => _currentAssetControlStatus;
  bool get currentAssetControlAvail => _currentAssetControlAvail;

  void moveAssetUp() {
    if (_currentAssetIndex > 0) {
      _currentAssetIndex--;
      _updateCurrentAssetInfo();
      state = this;
    }
  }

  void moveAssetDown() {
    if (_currentAssetIndex < assetItems.length - 1) {
      _currentAssetIndex++;
      _updateCurrentAssetInfo();
      state = this;
    }
  }

  void setCurrentAssetIndex(int index) {
    if (index >= 0 && index < assetItems.length) {
      _currentAssetIndex = index;
      _updateCurrentAssetInfo();
      state = this;
    }
  }

  void _updateCurrentAssetInfo() {
    if (_subsystemControlAbstractions.isNotEmpty &&
        _currentAssetIndex < _subsystemControlAbstractions.length) {
      final asset = _subsystemControlAbstractions[_currentAssetIndex];
      if (asset is Map) {
        _currentAssetSubsystemId = asset['Address']['SubsystemId'] ?? 0;
        _currentAssetNodeId = asset['Address']['NodeId'] ?? 0;
        _currentAssetCompId = asset['Address']['CompId'] ?? 0;
        _currentAssetName = asset['Name']?.toString() ?? "UNKNOWN";
        _currentAssetControlStatus =
            asset['ControlStatus']?.toString() ?? "UNKNOWN";
        _currentAssetControlAvail =
            !(_currentAssetControlStatus == "UNKNOWN" ||
                _currentAssetControlStatus == "NOT_AVAILABLE");
      }
    }
  }

  set subsystemControlAbstractions(List<dynamic> val) {
    _subsystemControlAbstractions = val;
    assetItems = val.map((e) {
      if (e is Map) {
        return "${e['Address']['SubsystemId'] ?? 0} ${e['Name'] ?? ''} (${e['SubsystemType'] ?? ''}) - ${e['ControlStatus'] ?? ''}";
      }
      return "Unknown Asset";
    }).toList();

    state = this;
  }
}
