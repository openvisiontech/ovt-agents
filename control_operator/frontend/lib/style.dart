import 'package:flutter/material.dart';

class Style {
  // Window
  static const double windowWidth = 1280;
  static const double windowHeight = 1024;
  static const double margin = 3;
  static const double radius = 5;
  static const double smallDeviceBreakpoint = 800;

  // Colors
  static const Color backgroundColor = Colors.white;
  static const Color foregroundColor = Colors.black;
  static const Color borderColor = Color(0xFF696969); // dimgray
  static const double borderWidth = 3;

  // Buttons
  static const Color btnGreyoutColor = Color(0xFFD3D3D3); // lightgrey
  static const Color btnHighlightColor = Color(0xFFDAA520); // goldenrod
  static const Color btnHoverColor = Color.fromARGB(255, 32, 54, 218);
  static const Color btnBackgroundColor = Color(0xFF696969); // dimgray
  static const Color stopColor = Colors.red;

  // Header
  static const double headerHeight = 68;
  static const Color headerBackgroundColor = Color(0xFF5F9EA0); // cadetblue
  static const Color headerBtnHoverColor = Color.fromARGB(255, 32, 54, 218);
  static const double headerBtnWidth = 64;
  static const double headerBtnHeight = 64;
  static const double headerBtnIconPixelSize = 60;
  static const double headerIconPixelSize = 32;

  // Navigator
  static const Color navigatorBackgroundColor = Color(0xFF696969); // dimgray
  static const Color navigatorBorderColor = Colors.white;
  static const Color navigatorBtnHighlightColor = Color(
    0xFFDAA520,
  ); // goldenrod
  static const Color navigatorBtnHoverColor = Color.fromARGB(255, 32, 54, 218);
  static const double navigatorWidth = 80;
  static const double navigatorBtnWidth = 80;
  static const double navigatorBtnHeight = 68;
  static const double navigatorBtnSpacing = 10;
  static const double navigatorBtnIconPixelSize = 40;

  // Commander
  static const Color commanderBackgroundColor = Color(0xFF5F9EA0); // cadetblue
  static const Color commanderBorderColor = Colors.white;
  static const Color commanderBtnBackgroundColor = Color(0xFF696969); // dimgray
  static const Color commanderBtnHighlightColor = Color(
    0xFFDAA520,
  ); // goldenrod
  static const Color commanderBtnHoverColor = Color.fromARGB(255, 32, 54, 218);
  static const double commanderHeight = 72;
  static const double commanderBtnWidth = 80;
  static const double commanderBtnHeight = 80; // Inferred or default
  static const double commanderBtnIconPixelSize = 32; // Inferred
  static const double commanderBtnSpacing = 4; // Inferred

  // Fonts
  // Mapping QML hex codes to Material Icons is tricky.
  // We'll use a map or just standard Icons for now.
  // e.g. \ue88a -> home
}
