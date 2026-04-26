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

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show exit;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'style.dart';
import 'components/icon_text_btn.dart';
import 'providers/data_providers.dart';
import 'screens/asset_screen.dart';
import 'screens/domain_screen.dart';
import 'screens/ai_assist_screen.dart';
import 'comms/web_rtc_client.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guiData = ref.watch(guiDataProvider);
    final headerData = ref.watch(headerDataProvider);
    final isSmallScreen =
        MediaQuery.of(context).size.width < Style.smallDeviceBreakpoint;

    Widget currentHeaderWidget = const SizedBox.shrink();
    if (guiData.currentScreen == 'AssetScreen') {
      currentHeaderWidget = AssetHeaderWidget(isSmallScreen: isSmallScreen);
    } else if (guiData.currentScreen == 'DomainScreen') {
      currentHeaderWidget = DomainHeaderWidget(isSmallScreen: isSmallScreen);
    } else if (guiData.currentScreen == 'AIAssistScreen') {
      currentHeaderWidget = AIAssistHeaderWidget(isSmallScreen: isSmallScreen);
    }

    return Scaffold(
      backgroundColor: Colors.black, // Window background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(Style.margin),
        child: Column(
          children: [
            // Header
            Container(
              height: Style.headerHeight,
              color: Style.headerBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: Style.margin / 2),
              child: Row(
                children: [
                  IconTextBtn(
                    icon: Icons.domain,
                    description: "Domain",
                    width: Style.headerBtnWidth,
                    height: double.infinity,
                    backgroundColor: Style.headerBackgroundColor,
                    hoverColor: Style.headerBtnHoverColor,
                    iconSize: Style.headerIconPixelSize,
                    highlight: guiData.currentScreen == 'DomainScreen',
                    onPressed: () {
                      if (guiData.currentScreen != 'DomainScreen') {
                        if (guiData.currentScreen == 'AssetScreen') {
                          ref
                              .read(actionRequestsProvider.notifier)
                              .leavingAssetScreen();
                        } else if (guiData.currentScreen == 'AIAssistScreen') {
                          ref
                              .read(actionRequestsProvider.notifier)
                              .leavingAIAssistScreen();
                        }
                        guiData.goDomainScreen();
                      }
                    },
                  ),
                  const SizedBox(width: Style.margin),
                  IconTextBtn(
                    icon: Icons.web_asset,
                    description: "Asset",
                    width: Style.headerBtnWidth,
                    height: double.infinity,
                    backgroundColor: Style.headerBackgroundColor,
                    hoverColor: Style.headerBtnHoverColor,
                    iconSize: Style.headerIconPixelSize,
                    highlight: guiData.currentScreen == 'AssetScreen',
                    onPressed: () {
                      if (guiData.currentScreen != 'AssetScreen') {
                        if (guiData.currentScreen == 'DomainScreen') {
                          ref
                              .read(actionRequestsProvider.notifier)
                              .leavingDomainScreen();
                          ref.read(domainDataProvider.notifier).clear();
                        }
                        guiData.goAssetScreen();
                      }
                    },
                  ),
                  const SizedBox(width: Style.margin),
                  IconTextBtn(
                    icon: Icons.support_agent,
                    description: "AI Assist",
                    width: Style.headerBtnWidth,
                    height: double.infinity,
                    backgroundColor: Style.headerBackgroundColor,
                    hoverColor: Style.headerBtnHoverColor,
                    iconSize: Style.headerIconPixelSize,
                    highlight: guiData.currentScreen == 'AIAssistScreen',
                    onPressed: () {
                      if (guiData.currentScreen != 'AIAssistScreen') {
                        if (guiData.currentScreen == 'DomainScreen') {
                          ref
                              .read(actionRequestsProvider.notifier)
                              .leavingDomainScreen();
                          ref.read(domainDataProvider.notifier).clear();
                        } else if (guiData.currentScreen == 'AssetScreen') {
                          ref
                              .read(actionRequestsProvider.notifier)
                              .leavingAssetScreen();
                        }
                        guiData.goAIAssistScreen();
                      }
                    },
                  ),
                  const SizedBox(width: Style.margin),
                  IconTextBtn(
                    icon: Icons.settings,
                    description: "Settings",
                    width: Style.headerBtnWidth,
                    height: double.infinity,
                    backgroundColor: Style.headerBackgroundColor,
                    hoverColor: Style.headerBtnHoverColor,
                    iconSize: Style.headerIconPixelSize,
                    onPressed: () {
                      // goSettings
                      if (guiData.currentScreen == 'DomainScreen') {
                        ref
                            .read(actionRequestsProvider.notifier)
                            .leavingDomainScreen();
                        ref.read(domainDataProvider.notifier).clear();
                      } else if (guiData.currentScreen == 'AssetScreen') {
                        ref
                            .read(actionRequestsProvider.notifier)
                            .leavingAssetScreen();
                      } else if (guiData.currentScreen == 'AIAssistScreen') {
                        ref
                            .read(actionRequestsProvider.notifier)
                            .leavingAIAssistScreen();
                      }
                    },
                  ),
                  Expanded(
                    child: Container(
                      // Header Center View Placeholder
                      color: Colors.transparent,
                      child: isSmallScreen ? null : currentHeaderWidget,
                    ),
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: WebRTCClient().connectionState,
                    builder: (context, state, child) {
                      IconData iconData = Icons.wifi_off;
                      Color iconColor = Colors.red;
                      if (state == 'connected') {
                        iconData = Icons.wifi;
                        iconColor = Colors.green;
                      } else if (state == 'connecting') {
                        iconData = Icons.sync;
                        iconColor = Colors.orange;
                      }
                      return Tooltip(
                        message: 'WebRTC: $state',
                        child: Icon(
                          iconData,
                          color: iconColor,
                          size: Style.headerIconPixelSize,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: Style.margin),
                  IconTextBtn(
                    icon: Icons.menu, // \ue5d2
                    description: "Toggle",
                    width: Style.headerBtnWidth,
                    height: double.infinity,
                    backgroundColor: Style.headerBackgroundColor,
                    hoverColor: Style.headerBtnHoverColor,
                    iconSize: Style.headerIconPixelSize,
                    onPressed: () {
                      guiData.toggleMenu();
                    },
                  ),
                  const SizedBox(width: Style.margin),
                  if (!kIsWeb)
                    IconTextBtn(
                      icon: Icons.exit_to_app, // \ue8ac
                      description: "Exit",
                      width: Style.headerBtnWidth,
                      height: double.infinity,
                      backgroundColor: Style.headerBackgroundColor,
                      hoverColor: Style.headerBtnHoverColor,
                      iconSize: Style.headerIconPixelSize,
                      onPressed: () {
                        exit(0);
                      },
                    ),
                  const SizedBox(width: Style.margin),
                  IconTextBtn(
                    icon: Icons.stop_circle, // \ue769
                    description: "EStop",
                    width: Style.headerBtnWidth,
                    height: double.infinity,
                    highlightColor: Style.stopColor,
                    iconSize: Style.headerIconPixelSize,
                    greyout: headerData.assetSelected != true,
                    highlight: headerData.estop == 'SET',
                    onPressed: () {
                      if (headerData.estop == 'SET') {
                        headerData.estop = 'CLEAR';
                      } else if (headerData.estop == 'CLEAR') {
                        headerData.estop = 'SET';
                      }
                    },
                  ),
                ],
              ),
            ),
            if (isSmallScreen) ...[
              const SizedBox(height: Style.margin),
              Container(
                height: Style.headerHeight,
                width: double.infinity,
                color: Style.headerBackgroundColor,
                child: currentHeaderWidget,
              ),
            ],
            const SizedBox(height: Style.margin),
            // Content Box
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Builder(
                  builder: (context) {
                    if (guiData.currentScreen == 'AssetScreen') {
                      return const AssetScreen();
                    } else if (guiData.currentScreen == 'AIAssistScreen') {
                      return const AIAssistScreen();
                    } else {
                      return const DomainScreen();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
