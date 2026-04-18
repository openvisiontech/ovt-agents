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

  List<dynamic> get subsystemControlAbstractions =>
      _subsystemControlAbstractions;
  int get currentAssetIndex => _currentAssetIndex;
  dynamic get currentAssetSubsystemId => _currentAssetSubsystemId;
  dynamic get currentAssetNodeId => _currentAssetNodeId;
  dynamic get currentAssetCompId => _currentAssetCompId;
  String get currentAssetName => _currentAssetName;
  String get currentAssetControlStatus => _currentAssetControlStatus;
  String get currentAssetControlAvail => _currentAssetControlAvail;

  set subsystemControlAbstractions(List<dynamic> val) {
    _subsystemControlAbstractions = val;
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
