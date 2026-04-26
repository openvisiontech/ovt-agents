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
import '../3d/scene_widget.dart';

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  @override
  Widget build(BuildContext context) {
    final guiData = ref.watch(guiDataProvider);
    final assetData = ref.watch(assetDataProvider);
    final actionRequests = ref.watch(actionRequestsProvider);
    final isSmallScreen =
        MediaQuery.of(context).size.width < Style.smallDeviceBreakpoint;

    final List<Widget> navButtons = [
      IconTextBtn(
        icon: Icons.smart_toy, // Agents (capability functions)
        description: "Agents",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        highlight: guiData.assetLeftSidebarVisible,
        onPressed: () {
          actionRequests.agentListUpdate = true;
        },
      ),
      SizedBox(
        width: isSmallScreen ? Style.navigatorBtnSpacing : 0,
        height: isSmallScreen ? 0 : Style.navigatorBtnSpacing,
      ),
      IconTextBtn(
        icon: Icons.dataset, // Data
        description: "Data",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        onPressed: () {
          // goDataView (placeholder)
          guiData.hideAssetLeftSidebar();
        },
      ),
      SizedBox(
        width: isSmallScreen ? Style.navigatorBtnSpacing : 0,
        height: isSmallScreen ? 0 : Style.navigatorBtnSpacing,
      ),
      IconTextBtn(
        icon: Icons.visibility, // Insight
        description: "Insight",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        onPressed: () {
          // goInsightView
          guiData.hideAssetLeftSidebar();
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
      color: Style.backgroundColor,
      child: Stack(
        children: [
          const Positioned.fill(child: SceneWidget()),
          if (guiData.assetPopupVisible && !isSmallScreen)
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
                          const AgentsSidebar(),
                          mainContent,
                          const Center(
                            child: Text(
                              "Right Sidebar Placeholder",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          if (guiData.assetLeftSidebarVisible)
                            const Expanded(flex: 2, child: AgentsSidebar()),
                          Expanded(flex: 7, child: mainContent),
                          if (guiData.assetRightSidebarVisible)
                            const Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  "Right Sidebar Placeholder",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),

              // Footer Box (Commander)
              if (guiData.assetCommanderVisible)
                Container(
                  width: double.infinity,
                  height: Style.commanderHeight,
                  decoration: BoxDecoration(
                    color: Style.commanderBackgroundColor,
                    border: Border.all(
                      color: Style.commanderBorderColor,
                      width: 1.0,
                    ),
                  ),
                  padding: EdgeInsets.all(Style.margin),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          IconTextBtn(
                            icon: (assetData.haveControl == "YES")
                                ? Icons.cancel
                                : Icons.gamepad,
                            description: (assetData.haveControl == "YES")
                                ? "Release"
                                : "Control",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            greyout: assetData.controlAvail == false,
                            onPressed: () {
                              if (assetData.controlAvail == false) return;
                              assetData.interactionMode =
                                  (assetData.haveControl == "YES")
                                  ? "WATCH"
                                  : "CONTROL";
                            },
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.person, // Mode
                            description: "Mode",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            greyout: assetData.haveControl != "YES",
                            onPressed: () {
                              // Open Mode Dialog
                            },
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.refresh, // Reset
                            description: "Reset",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            greyout: assetData.haveControl != "YES",
                            onPressed: () {
                              // Reset command
                            },
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.delete_forever, // Render Useless
                            description: "RndrUseles",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            greyout: assetData.haveControl != "YES",
                            onPressed: () {
                              // Render Useless command
                            },
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.power_settings_new, // Shutdown
                            description: "Shutdown",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            greyout: assetData.haveControl != "YES",
                            onPressed: () {
                              // Shutdown command
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: guiData.assetCommanderVisible ? Style.commanderHeight : 0,
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    guiData.toggleAssetCommander();
                  },
                  child: Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Style.commanderBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Style.commanderBorderColor,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      guiData.assetCommanderVisible
                          ? Icons.expand_more
                          : Icons.expand_less,
                      color: Style.commanderBtnHoverColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
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

class AgentsSidebar extends ConsumerStatefulWidget {
  const AgentsSidebar({super.key});

  @override
  ConsumerState<AgentsSidebar> createState() => _AgentsSidebarState();
}

class _AgentsSidebarState extends ConsumerState<AgentsSidebar> {
  final ScrollController _scrollController = ScrollController();
  final double _itemHeight = 56.0; // Approximate height of a ListTile

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final double targetTop = index * _itemHeight;
    final double targetBottom = targetTop + _itemHeight;
    final double viewportHeight = _scrollController.position.viewportDimension;
    final double currentOffset = _scrollController.offset;

    if (targetTop < currentOffset) {
      _scrollController.animateTo(
        targetTop,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (targetBottom > currentOffset + viewportHeight) {
      _scrollController.animateTo(
        targetBottom - viewportHeight,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetData = ref.watch(assetDataProvider);

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Sidebar Header
          Container(
            height: 50,
            color: Style.headerBackgroundColor,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Colors.white),
                  onPressed: () {
                    assetData.moveAgentUp();
                    _scrollToIndex(assetData.currentAgentIndex);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: () {
                    assetData.moveAgentDown();
                    _scrollToIndex(assetData.currentAgentIndex);
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Agents",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: () {
                    assetData.selectAgent();
                  },
                ),
              ],
            ),
          ),
          // Sidebar List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: assetData.agentItems.length,
              itemBuilder: (context, index) {
                return Container(
                  color: index == assetData.currentAgentIndex
                      ? Colors.blue[100]
                      : null,
                  child: ListTile(
                    title: Text(assetData.agentItems[index]),
                    onTap: () {
                      assetData.setCurrentAgentIndex(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AssetHeaderWidget extends ConsumerWidget {
  final bool isSmallScreen;
  const AssetHeaderWidget({super.key, required this.isSmallScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guiData = ref.watch(guiDataProvider);
    final assetData = ref.watch(assetDataProvider);
    final address =
        "${assetData.subsystemId}.${assetData.nodeId}.${assetData.compId}";
    final name = assetData.assetName;

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name ($address)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Ctrl: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Icon(
                          Icons.sports_esports,
                          color: assetData.haveControl == "YES"
                              ? Colors.green
                              : Colors.grey,
                          size: 22,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                if (assetData.haveAccess == "YES") ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "App: ${assetData.appAccessRight}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "Data: ${assetData.dataAccessRight}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                ],
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "State: ${assetData.subsystemState}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Mode: ${assetData.operatingMode}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
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
