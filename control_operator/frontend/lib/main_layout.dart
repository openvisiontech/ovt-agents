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
      currentHeaderWidget = const AssetHeaderWidget();
    } else if (guiData.currentScreen == 'DomainScreen') {
      currentHeaderWidget = const DomainHeaderWidget();
    } else if (guiData.currentScreen == 'AIAssistScreen') {
      currentHeaderWidget = const AIAssistHeaderWidget();
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
                    },
                  ),
                  Expanded(
                    child: Container(
                      // Header Center View Placeholder
                      color: Colors.transparent,
                      child: isSmallScreen ? null : currentHeaderWidget,
                    ),
                  ),
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
                    greyout: headerData.estop != 'SET' && headerData.estop != 'CLEAR',
                    highlight: headerData.estop == 'SET',
                    onPressed: () {
                      if (headerData.estop == 'SET') {
                        headerData.estop = 'CLEAR';
                      } else if (headerData.estop == 'CLEAR')
                        headerData.estop = 'SET';
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
