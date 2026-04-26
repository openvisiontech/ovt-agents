import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainDataModel extends Notifier<DomainDataModel> {
  @override
  DomainDataModel build() => this;
  @override
  bool updateShouldNotify(DomainDataModel previous, DomainDataModel next) =>
      true;

  List<dynamic> _subsystemAbstractions = [];
  int _currentAssetIndex = -1;
  Map<String, dynamic> _currentAssetInfo = {};

  List<String> assetItems = [];

  List<dynamic> get subsystemAbstractions => _subsystemAbstractions;
  int get currentAssetIndex => _currentAssetIndex;
  Map<String, dynamic> get currentAssetInfo => _currentAssetInfo;

  void _updateCurrentAssetInfo() {
    if (_subsystemAbstractions.isNotEmpty &&
        _currentAssetIndex < _subsystemAbstractions.length) {
      _currentAssetInfo = _subsystemAbstractions[_currentAssetIndex];
    }
  }

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

  void clear() {
    // Retain the current asset index and info
    //_subsystemAbstractions = [];
    //_currentAssetIndex = -1;
    //_currentAssetInfo = {};
    //assetItems = [];
    //state = this;
  }

  // Setters
  set subsystemAbstractions(List<dynamic> val) {
    _subsystemAbstractions = val;
    assetItems = val.map((e) {
      if (e is Map) {
        return "${e['Address']['SubsystemId'] ?? 0} ${e['Name'] ?? ''} (${e['SubsystemType'] ?? ''})";
      }
      return "Unknown Asset";
    }).toList();
    // keep current asset index if possible
    if (_currentAssetIndex >= assetItems.length) {
      _currentAssetIndex = assetItems.length - 1;
    }
    //list is updated, so update current asset info
    _updateCurrentAssetInfo();

    state = this;
  }
}
