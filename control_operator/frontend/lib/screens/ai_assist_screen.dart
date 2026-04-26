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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../style.dart';
import '../components/icon_text_btn.dart';

class AIAssistScreen extends ConsumerStatefulWidget {
  const AIAssistScreen({super.key});

  @override
  ConsumerState<AIAssistScreen> createState() => _AIAssistScreenState();
}

class _AIAssistScreenState extends ConsumerState<AIAssistScreen> {
  @override
  Widget build(BuildContext context) {
    final guiData = ref.watch(guiDataProvider);
    final isSmallScreen =
        MediaQuery.of(context).size.width < Style.smallDeviceBreakpoint;

    final List<Widget> navButtons = [
      IconTextBtn(
        icon: Icons.chat,
        description: "Chat",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        highlight: guiData.aiAssistLeftSidebarVisible,
        onPressed: () {
          guiData.toggleAIAssistLeftSidebar();
        },
      ),
      SizedBox(
        width: isSmallScreen ? Style.navigatorBtnSpacing : 0,
        height: isSmallScreen ? 0 : Style.navigatorBtnSpacing,
      ),
      IconTextBtn(
        icon: Icons.history,
        description: "History",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        highlight: guiData.aiAssistRightSidebarVisible,
        onPressed: () {
          guiData.toggleAIAssistRightSidebar();
        },
      ),
    ];

    Widget? navBox = guiData.navigatorBoxOnoff
        ? Container(
            width: isSmallScreen ? double.infinity : Style.navigatorWidth,
            height: isSmallScreen ? Style.navigatorBtnHeight : double.infinity,
            decoration: BoxDecoration(
              color: Style.navigatorBackgroundColor,
              border: isSmallScreen
                  ? const Border(
                      top: BorderSide(
                        color: Colors.white,
                        width:
                            2.0, // Two horizontal white lines visual equivalent
                      ),
                    )
                  : null,
            ),
            child: isSmallScreen
                ? Row(children: navButtons)
                : Column(children: navButtons),
          )
        : null;

    final mainContent = Container(
      color: Colors.black, // Match thematic background
      child: Stack(
        children: [
          const Center(
            child: Text(
              "AI Assist Content",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (guiData.aiAssistPopupVisible && !isSmallScreen)
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.33,
                heightFactor: 0.33,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Item Content",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    Widget contentBox = Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              // Center Box
              Expanded(
                child: isSmallScreen
                    ? IndexedStack(
                        index: guiData.smallScreenBoxIndex,
                        children: [
                          Container(
                            color: Colors.yellow,
                            child: const Center(
                              child: Text(
                                "Left Sidebar Placeholder",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          mainContent,
                          Container(
                            color: Colors.green,
                            child: const Center(
                              child: Text(
                                "Right Sidebar Placeholder",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          if (guiData.aiAssistLeftSidebarVisible)
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.yellow,
                                child: const Center(
                                  child: Text(
                                    "Left Sidebar Placeholder",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(flex: 7, child: mainContent),
                          if (guiData.aiAssistRightSidebarVisible)
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: Colors.green,
                                child: const Center(
                                  child: Text(
                                    "Right Sidebar Placeholder",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isSmallScreen) {
      return Column(children: [contentBox, if (navBox != null) navBox]);
    } else {
      return Row(children: [if (navBox != null) navBox, contentBox]);
    }
  }
}

class AIAssistHeaderWidget extends ConsumerWidget {
  final bool isSmallScreen;
  const AIAssistHeaderWidget({super.key, required this.isSmallScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guiData = ref.watch(guiDataProvider);

    return Row(
      children: [
        const Expanded(
          child: Center(
            child: Text(
              "AI Assist",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (isSmallScreen)
          IconButton(
            icon: const Icon(Icons.view_carousel, color: Colors.white),
            onPressed: () {
              guiData.cycleSmallScreenBox();
            },
          ),
      ],
    );
  }
}
