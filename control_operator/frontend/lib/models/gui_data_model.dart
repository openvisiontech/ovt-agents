/**********************************************************************************
 * Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
 * All rights reserved. This material contains unpublished,
 * copyrighted work, which includes confidential and proprietary
 * information of Open Vision Technology, LLC..

 * Open Vision Technology, LLC. and its licensors retain all intellectual property
 * and proprietary rights in and to this software, related documentation
 * and any modifications thereto. Any use, reproduction, disclosure or
 * distribution of this software and related documentation without an express
 * license agreement from Open Vision Technology, LLC. is strictly prohibited.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **********************************************************************************
 */

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
    } else if (currentScreen == 'AIAssistScreen') {
      hasLeft = aiAssistLeftSidebarVisible;
      hasRight = aiAssistRightSidebarVisible;
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
    } else if (currentScreen == 'AIAssistScreen') {
      hasLeft = aiAssistLeftSidebarVisible;
      hasRight = aiAssistRightSidebarVisible;
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
  bool domainPopupVisible = false;
  bool domainCommanderVisible = true;

  bool assetLeftSidebarVisible = false;
  bool assetRightSidebarVisible = false;
  bool assetPopupVisible = false;
  bool assetCommanderVisible = true;

  bool aiAssistLeftSidebarVisible = false;
  bool aiAssistRightSidebarVisible = false;
  bool aiAssistPopupVisible = false;

  void toggleAssetCommander() {
    assetCommanderVisible = !assetCommanderVisible;
    state = this;
  }

  void showAssetLeftSidebar() {
    assetLeftSidebarVisible = true;
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

  void showDomainLeftSidebar() {
    domainLeftSidebarVisible = true;
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

  void toggleAIAssistLeftSidebar() {
    aiAssistLeftSidebarVisible = !aiAssistLeftSidebarVisible;
    if (aiAssistLeftSidebarVisible)
      _smallScreenBoxIndex = 0;
    else
      _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void hideAIAssistLeftSidebar() {
    aiAssistLeftSidebarVisible = false;
    _sanitizeSmallScreenBoxIndex();
    state = this;
  }

  void toggleAIAssistRightSidebar() {
    aiAssistRightSidebarVisible = !aiAssistRightSidebarVisible;
    if (aiAssistRightSidebarVisible)
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
