import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderDataModel extends Notifier<HeaderDataModel> {
  @override
  HeaderDataModel build() => this;
  @override
  bool updateShouldNotify(HeaderDataModel previous, HeaderDataModel next) =>
      true;

  String _estop = "CLEAR";

  String get estop => _estop;

  set estop(String val) {
    _estop = val;
    state = this;
  }
}
