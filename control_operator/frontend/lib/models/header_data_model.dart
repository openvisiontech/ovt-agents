import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderDataModel extends Notifier<HeaderDataModel> {
  @override
  HeaderDataModel build() => this;
  @override
  bool updateShouldNotify(HeaderDataModel previous, HeaderDataModel next) =>
      true;

  bool _userPresent = false;
  bool _assetSelected = false;
  String _estop = "CLEAR";

  bool get userPresent => _userPresent;
  bool get assetSelected => _assetSelected;
  String get estop => _estop;

  set userPresent(bool val) {
    _userPresent = val;
    state = this;
  }

  set estop(String val) {
    _estop = val;
    state = this;
  }

  set assetSelected(bool val) {
    _assetSelected = val;
    state = this;
  }
}
