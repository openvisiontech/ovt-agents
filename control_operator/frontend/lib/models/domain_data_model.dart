import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainDataModel extends Notifier<DomainDataModel> {
  @override
  DomainDataModel build() => this;
  @override
  bool updateShouldNotify(DomainDataModel previous, DomainDataModel next) =>
      true;

  List<dynamic> _subsystemControlAbstractions = [];
  int _currentAssetIndex = 0;
  dynamic _currentAssetSubsystemId;
  dynamic _currentAssetNodeId;
  dynamic _currentAssetCompId;
  String _currentAssetName = "";
  String _currentAssetControlStatus = "";
  String _currentAssetControlAvail = "";

  List<String> assetItems = List.generate(20, (index) => "Asset ${index + 1}");

  List<dynamic> get subsystemControlAbstractions =>
      _subsystemControlAbstractions;
  int get currentAssetIndex => _currentAssetIndex;
  dynamic get currentAssetSubsystemId => _currentAssetSubsystemId;
  dynamic get currentAssetNodeId => _currentAssetNodeId;
  dynamic get currentAssetCompId => _currentAssetCompId;
  String get currentAssetName => _currentAssetName;
  String get currentAssetControlStatus => _currentAssetControlStatus;
  String get currentAssetControlAvail => _currentAssetControlAvail;

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
        _currentAssetSubsystemId = asset['subsystemId'] ?? 0;
        _currentAssetNodeId = asset['nodeId'] ?? 0;
        _currentAssetCompId = asset['compId'] ?? 0;
        _currentAssetName = asset['name']?.toString() ?? "UNKNOWN";
        _currentAssetControlStatus =
            asset['controlStatus']?.toString() ?? "UNKNOWN";
        _currentAssetControlAvail =
            asset['controlAvail']?.toString() ?? "UNKNOWN";
      }
    }
  }

  set subsystemControlAbstractions(List<dynamic> val) {
    _subsystemControlAbstractions = val;
    assetItems = val.map((e) {
      if (e is Map) {
        return "${e['Name'] ?? 'Unknown'} (${e['SubsystemType'] ?? ''}) - ${e['ControlStatus'] ?? ''}";
      }
      return "Unknown Asset";
    }).toList();
    if (assetItems.isEmpty) {
      assetItems = List.generate(20, (index) => "Asset ${index + 1}");
    }
    state = this;
  }

  set currentAssetIndex(int val) {
    _currentAssetIndex = val;
    state = this;
  }

  set currentAssetSubsystemId(val) {
    _currentAssetSubsystemId = val;
    state = this;
  }

  set currentAssetNodeId(val) {
    _currentAssetNodeId = val;
    state = this;
  }

  set currentAssetCompId(val) {
    _currentAssetCompId = val;
    state = this;
  }

  set currentAssetName(String val) {
    _currentAssetName = val;
    state = this;
  }

  set currentAssetControlStatus(String val) {
    _currentAssetControlStatus = val;
    state = this;
  }

  set currentAssetControlAvail(String val) {
    _currentAssetControlAvail = val;
    state = this;
  }
}
