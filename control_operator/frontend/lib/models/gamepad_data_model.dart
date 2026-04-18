import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamepadDataModel extends Notifier<GamepadDataModel> {
  @override
  GamepadDataModel build() => this;
  @override
  bool updateShouldNotify(GamepadDataModel previous, GamepadDataModel next) =>
      true;

  bool gamepadDataReceived = false;
  double leftJoystickX = 0;
  double leftJoystickY = 0;
  double rightJoystickX = 0;
  double rightJoystickY = 0;
  double leftTrigger = 0;
  double rightTrigger = 0;
  double leftGrip = 0;
  double rightGrip = 0;
  String buttonA = "UNKNOWN";
  String buttonB = "UNKNOWN";
  String buttonX = "UNKNOWN";
  String buttonY = "UNKNOWN";
  String buttonL1 = "UNKNOWN";
  String buttonR1 = "UNKNOWN";
  String buttonL2 = "UNKNOWN";
  String buttonR2 = "UNKNOWN";
  String buttonL3 = "UNKNOWN";
  String buttonR3 = "UNKNOWN";
  String buttonStart = "UNKNOWN";
  String buttonSelect = "UNKNOWN";
  String buttonHome = "UNKNOWN";
}
