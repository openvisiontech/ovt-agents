import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuiDataModel extends Notifier<GuiDataModel> {
  @override
  GuiDataModel build() => this;
  @override
  bool updateShouldNotify(GuiDataModel previous, GuiDataModel next) => true;

  String _userPresent = "UNKNOWN";
  bool _navigatorBoxOnoff = true;
  bool _estop = false;
  String _previousScreen = "None";
  String _currentScreen = "AssetScreen";

  String get userPresent => _userPresent;
  bool get navigatorBoxOnoff => _navigatorBoxOnoff;

  bool menuVisible = true;

  int _smallScreenBoxIndex = 1;
  int get smallScreenBoxIndex => _smallScreenBoxIndex;

  void _sanitizeSmallScreenBoxIndex() {
    bool hasLeft = false;
    bool hasRight = false;

    if (currentScreen == 'DomainScreen') {
      hasLeft = domainLeftSidebarVisible;
      hasRight = domainRightSidebarVisible;
    } else if (currentScreen == 'AssetScreen') {
      hasLeft = assetLeftSidebarVisible;
      hasRight = assetRightSidebarVisible;
    }

    if (_smallScreenBoxIndex == 0 && !hasLeft) _smallScreenBoxIndex = 1;
    if (_smallScreenBoxIndex == 2 && !hasRight) _smallScreenBoxIndex = 1;
  }

  void cycleSmallScreenBox() {
    bool hasLeft = false;
    bool hasRight = false;

    if (currentScreen == 'DomainScreen') {
      hasLeft = domainLeftSidebarVisible;
      hasRight = domainRightSidebarVisible;
    } else if (currentScreen == 'AssetScreen') {
      hasLeft = assetLeftSidebarVisible;
      hasRight = assetRightSidebarVisible;
    }

    int nextIndex = _smallScreenBoxIndex;
    for (int i = 0; i < 3; i++) {
      nextIndex = (nextIndex + 1) % 3;
      if (nextIndex == 0 && hasLeft) break;
      if (nextIndex == 1) break;
      if (nextIndex == 2 && hasRight) break;
    }
    _smallScreenBoxIndex = nextIndex;
    state = this;
  }

  bool domainLeftSidebarVisible = false;
  bool domainRightSidebarVisible = false;
  bool domainCommanderVisible = true;

  bool assetLeftSidebarVisible = false;
  bool assetRightSidebarVisible = false;
  bool assetCommanderVisible = true;

  // Selected Asset Info
  dynamic subsystemId;
  dynamic nodeId;
  dynamic compId;
  String name = "";
  String controlStatus = "UNKNOWN";
  String controlAvail = "UNKNOWN";
  String haveAccess = "UNKNOWN";
  String appAccessRight = "UNKNOWN";
  String dataAccessRight = "UNKNOWN";
  String haveControl = "UNKNOWN";
  String subsystemState = "UNKNOWN";
  String operatingCategory = "UNKNOWN";
  String operatingMode = "UNKNOWN";

  void toggleAssetCommander() {
    assetCommanderVisible = !assetCommanderVisible;
    state = this;
  }

  void toggleAssetLeftSidebar() {
    assetLeftSidebarVisible = !assetLeftSidebarVisible;
    if (assetLeftSidebarVisible)
      _smallScreenBoxIndex = 0;
    else
      _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void hideAssetLeftSidebar() {
    assetLeftSidebarVisible = false;
    _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void toggleDomainLeftSidebar() {
    domainLeftSidebarVisible = !domainLeftSidebarVisible;
    if (domainLeftSidebarVisible)
      _smallScreenBoxIndex = 0;
    else
      _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void hideDomainLeftSidebar() {
    domainLeftSidebarVisible = false;
    _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void toggleDomainRightSidebar() {
    domainRightSidebarVisible = !domainRightSidebarVisible;
    if (domainRightSidebarVisible)
      _smallScreenBoxIndex = 2;
    else
      _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void toggleAssetRightSidebar() {
    assetRightSidebarVisible = !assetRightSidebarVisible;
    if (assetRightSidebarVisible)
      _smallScreenBoxIndex = 2;
    else
      _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void toggleDomainCommander() {
    domainCommanderVisible = !domainCommanderVisible;
    state = this;
  }

  bool get estop => _estop;
  String get previousScreen => _previousScreen;
  String get currentScreen => _currentScreen;

  set userPresent(String val) {
    _userPresent = val;
    state = this;
  }

  set navigatorBoxOnoff(bool val) {
    _navigatorBoxOnoff = val;
    state = this;
  }

  set estop(bool val) {
    _estop = val;
    state = this;
  }

  set previousScreen(String val) {
    _previousScreen = val;
    state = this;
  }

  set currentScreen(String val) {
    _currentScreen = val;
    state = this;
  }

  void goAssetScreen() {
    previousScreen = currentScreen;
    currentScreen = 'AssetScreen';
    _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void goDomainScreen() {
    previousScreen = currentScreen;
    currentScreen = 'DomainScreen';
    _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void goAIAssistScreen() {
    previousScreen = currentScreen;
    currentScreen = 'AIAssistScreen';
    _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void toggleMenu() {
    navigatorBoxOnoff = !navigatorBoxOnoff;
    state = this;
  }
}
