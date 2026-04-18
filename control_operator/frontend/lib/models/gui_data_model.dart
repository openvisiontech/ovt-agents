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
  bool haveControl = false;
  bool commanderVisible = true;
  bool agentsSidebarVisible = false;
  bool domainSidebarVisible = false;
  bool domainCommanderVisible = true;

  void toggleControl() {
    haveControl = !haveControl;
    state = this;
  }

  void toggleCommander() {
    commanderVisible = !commanderVisible;
    state = this;
  }

  void toggleAgentsSidebar() {
    agentsSidebarVisible = !agentsSidebarVisible;
    state = this;
  }

  void hideAgentsSidebar() {
    agentsSidebarVisible = false;
    state = this;
  }

  void toggleDomainSidebar() {
    domainSidebarVisible = !domainSidebarVisible;
    state = this;
  }

  void toggleDomainCommander() {
    domainCommanderVisible = !domainCommanderVisible;
    state = this;
  }

  List<String> agentItems = List.generate(
    20,
    (index) => "Agent Item ${index + 1}",
  );
  int currentAgentIndex = 0;
  String selectedAgentContent = "";

  List<String> assetItems = List.generate(20, (index) => "Asset ${index + 1}");
  int currentAssetIndex = 0;
  String selectedAssetContent = "";

  void moveAgentUp() {
    if (currentAgentIndex > 0) {
      currentAgentIndex--;
      state = this;
    }
  }

  void moveAgentDown() {
    if (currentAgentIndex < agentItems.length - 1) {
      currentAgentIndex++;
      state = this;
    }
  }

  void setCurrentAgentIndex(int index) {
    if (index >= 0 && index < agentItems.length) {
      currentAgentIndex = index;
      state = this;
    }
  }

  void selectAgent() {
    if (currentAgentIndex >= 0 && currentAgentIndex < agentItems.length) {
      selectedAgentContent = agentItems[currentAgentIndex];
      state = this;
    }
  }

  void moveAssetUp() {
    if (currentAssetIndex > 0) {
      currentAssetIndex--;
      state = this;
    }
  }

  void moveAssetDown() {
    if (currentAssetIndex < assetItems.length - 1) {
      currentAssetIndex++;
      state = this;
    }
  }

  void setCurrentAssetIndex(int index) {
    if (index >= 0 && index < assetItems.length) {
      currentAssetIndex = index;
      state = this;
    }
  }

  void selectAsset() {
    if (currentAssetIndex >= 0 && currentAssetIndex < assetItems.length) {
      selectedAssetContent = assetItems[currentAssetIndex];
      state = this;
    }
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
  }

  void goDomainScreen() {
    previousScreen = currentScreen;
    currentScreen = 'DomainScreen';
  }

  void goAIAssistScreen() {
    previousScreen = currentScreen;
    currentScreen = 'AIAssistScreen';
  }

  void toggleMenu() {
    navigatorBoxOnoff = !navigatorBoxOnoff;
  }
}
