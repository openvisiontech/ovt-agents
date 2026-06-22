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
import '../components/comp_data_topic_list.dart';
import '../components/comp_popup_viewer.dart';
import '../components/asset_list.dart';
import '../components/agent_list.dart';
import '../components/insight_list.dart';
import '../3d/scene_widget.dart';

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  @override
  Widget build(BuildContext context) {
    final headerData = ref.watch(headerDataProvider);
    final guiData = ref.watch(guiDataProvider);
    final assetData = ref.watch(assetDataProvider);
    final actionRequests = ref.watch(actionRequestsProvider);
    final isSmallScreen =
        MediaQuery.of(context).size.width < Style.smallDeviceBreakpoint;

    final List<Widget> navButtons = [
      IconTextBtn(
        icon: Icons.list,
        description: "Assets",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        highlight:
            guiData.assetLeftSidebarVisible &&
            guiData.assetLeftSidebarState == 'Assets',
        onPressed: () {
          actionRequests.assetListUpdate = true;
          guiData.assetLeftSidebarState = 'Assets';
          guiData.showAssetLeftSidebar();
          guiData.hideAssetPopup();
        },
      ),
      SizedBox(
        width: isSmallScreen ? Style.navigatorBtnSpacing : 0,
        height: isSmallScreen ? 0 : Style.navigatorBtnSpacing,
      ),
      IconTextBtn(
        icon: Icons.smart_toy, // Agents (capability functions)
        description: "Agents",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        highlight:
            guiData.assetLeftSidebarVisible &&
            guiData.assetLeftSidebarState == 'Agents',
        onPressed: () {
          actionRequests.agentListUpdate = true;
          guiData.assetLeftSidebarState = 'Agents';
          guiData.showAssetLeftSidebar();
          guiData.hideAssetPopup();
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
        highlight:
            guiData.assetLeftSidebarVisible &&
            guiData.assetLeftSidebarState == 'Data',
        onPressed: () {
          actionRequests.dataTopicListUpdate = true;
          guiData.assetLeftSidebarState = 'Data';
          guiData.showAssetLeftSidebar();
          guiData.hideAssetPopup();
        },
      ),
      SizedBox(
        width: isSmallScreen ? Style.navigatorBtnSpacing : 0,
        height: isSmallScreen ? 0 : Style.navigatorBtnSpacing,
      ),
      IconTextBtn(
        icon: Icons.support_agent, // AI Assist
        description: "AI Assist",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        highlight: guiData.assetRightSidebarVisible,
        onPressed: () {
          guiData.toggleAssetRightSidebar();
        },
      ),
      const Spacer(),
      IconTextBtn(
        icon: Icons.visibility, // Insight
        description: "Insights",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        highlight:
            guiData.assetLeftSidebarVisible &&
            guiData.assetLeftSidebarState == 'Insights',
        onPressed: () {
          guiData.assetLeftSidebarState = 'Insights';
          guiData.showAssetLeftSidebar();
          guiData.hideAssetPopup();
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
                widthFactor: 0.70,
                heightFactor: 0.80,
                child: Builder(
                  builder: (context) {
                    dynamic popupJson;
                    String? popupMarkdown = guiData.popupMarkdown;

                    if (guiData.popupInsightType != null) {
                      switch (guiData.popupInsightType) {
                        case "Comp Status":
                          popupJson = {
                            "statusdetails": assetData.statusDetails,
                          };
                          break;
                        case "Agent Status":
                          popupJson = {
                            "agentstatuslist": assetData.agentStatus,
                          };
                          break;
                        case "Data Topic Clients":
                          popupJson = {
                            "datatopicclientlist":
                                assetData.dataTopicClientList,
                          };
                          break;
                        case "Transform Reporters":
                          popupJson = {
                            "transformreporterlist":
                                assetData.transformReporterList,
                            "transformclientlist":
                                assetData.transformClientList,
                          };
                          break;
                      }
                    } else {
                      popupJson = guiData.popupJson;
                    }

                    return CompPopupViewer(
                      title: guiData.popupTitle,
                      json: popupJson,
                      markdown: popupMarkdown,
                      onClose: () =>
                          ref.read(guiDataProvider.notifier).hideAssetPopup(),
                    );
                  },
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
                          const AssetLeftSidebar(),
                          mainContent,
                          const AssetRightSidebar(),
                        ],
                      )
                    : Row(
                        children: [
                          if (guiData.assetLeftSidebarVisible)
                            const Expanded(flex: 2, child: AssetLeftSidebar()),
                          Expanded(flex: 6, child: mainContent),
                          if (guiData.assetRightSidebarVisible)
                            const Expanded(flex: 4, child: AssetRightSidebar()),
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

class AssetLeftSidebar extends ConsumerWidget {
  const AssetLeftSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guiData = ref.watch(guiDataProvider);
    final assetData = ref.watch(assetDataProvider);

    final state = guiData.assetLeftSidebarState;

    if (state == 'Assets') {
      return AssetList(
        assets: assetData.assetAbstractions,
        selectedIndex: assetData.currentAssetIndex,
        onUpPressed: () => ref.read(assetDataProvider.notifier).moveAssetUp(),
        onDownPressed: () =>
            ref.read(assetDataProvider.notifier).moveAssetDown(),
        onCheckPressed: () {
          ref.read(assetDataProvider.notifier).selectAsset();
          ref.read(headerDataProvider.notifier).assetSelected = true;
        },
        onClosePressed: () {
          ref.read(guiDataProvider.notifier).hideAssetLeftSidebar();
        },
        onItemTapped: (index) {
          ref.read(assetDataProvider.notifier).setCurrentAssetIndex(index);
        },
        onInfoPressed: (asset) {
          final name = asset['Name']?.toString() ?? 'Asset';
          final contextStr = asset['Context']?.toString() ?? '';
          ref
              .read(guiDataProvider.notifier)
              .showPopup(
                title: "$name Context",
                markdown: contextStr.isNotEmpty
                    ? contextStr
                    : "No context available for this asset.",
              );
        },
      );
    } else if (state == 'Agents') {
      return AgentList(
        agents: assetData.agentAbstractions,
        selectedIndex: assetData.currentAgentIndex,
        onUpPressed: () => ref.read(assetDataProvider.notifier).moveAgentUp(),
        onDownPressed: () =>
            ref.read(assetDataProvider.notifier).moveAgentDown(),
        onCheckPressed: () =>
            ref.read(assetDataProvider.notifier).selectAgent(),
        onClosePressed: () {
          ref.read(guiDataProvider.notifier).hideAssetLeftSidebar();
          ref.read(actionRequestsProvider.notifier).agentListUpdate = false;
        },
        onItemTapped: (index) {
          ref.read(assetDataProvider.notifier).setCurrentAgentIndex(index);
        },
        onInfoPressed: (agent) {
          final name = agent['Name']?.toString() ?? 'Agent';
          final contextStr = agent['Context']?.toString() ?? '';
          ref
              .read(guiDataProvider.notifier)
              .showPopup(
                title: "$name Context",
                markdown: contextStr.isNotEmpty
                    ? contextStr
                    : "No context available for this agent.",
              );
        },
      );
    } else if (state == 'Data') {
      // Data Topics
      return CompDataTopicList(
        items: assetData.dataTopicList,
        selectedUris: assetData.selectedTopicUris,
        onCheck: (uri) {
          ref.read(assetDataProvider.notifier).toggleTopicSelected(uri);
        },
        onClosePressed: () {
          ref.read(guiDataProvider.notifier).hideAssetLeftSidebar();
          ref.read(actionRequestsProvider.notifier).dataTopicListUpdate = false;
        },
        onInfoPressed: (topic) {
          final uri = topic['Uri']?.toString() ?? 'Topic';
          final topicContext =
              topic['Context']?.toString() ?? 'No topic context available.';
          final schemaName = topic['Schema']?.toString() ?? '';
          final schemaContext = ref
              .read(assetDataProvider.notifier)
              .getSchemaContext(schemaName);

          final md =
              '## Topic Context\n$topicContext\n\n---\n## Schema: $schemaName\n${schemaContext ?? "No schema context available."}';

          ref
              .read(guiDataProvider.notifier)
              .showPopup(title: "$uri Details", markdown: md);
        },
      );
    } else if (state == 'Insights') {
      return InsightList(
        items: assetData.insightMenuItems,
        selectedIndex: assetData.currentInsightMenuItemIndex,
        compStatusCount: assetData.statusDetails.length,
        agentStatusCount: assetData.agentStatus.length,
        dataTopicClientsCount: assetData.dataTopicClientList.length,
        transformReportersCount:
            assetData.transformReporterList.length +
            assetData.transformClientList.length,
        onUpPressed: () =>
            ref.read(assetDataProvider.notifier).moveInsightMenuItemUp(),
        onDownPressed: () =>
            ref.read(assetDataProvider.notifier).moveInsightMenuItemDown(),
        onCheckPressed: () {
          ref.read(assetDataProvider.notifier).selectInsightMenuItem();
          final selected = ref
              .read(assetDataProvider.notifier)
              .selectedInsightMenuItem;
          switch (selected) {
            case "Comp Status":
              ref.read(actionRequestsProvider.notifier).leavingAssetScreen();
              ref.read(actionRequestsProvider.notifier).statusDetailsUpdate =
                  true;
              ref
                  .read(guiDataProvider.notifier)
                  .showPopup(
                    title: "Component Status Details",
                    insightType: "Comp Status",
                  );
              break;
            case "Agent Status":
              ref.read(actionRequestsProvider.notifier).leavingAssetScreen();
              ref.read(actionRequestsProvider.notifier).agentStatusUpdate =
                  true;
              ref
                  .read(guiDataProvider.notifier)
                  .showPopup(
                    title: "Agent Status List",
                    insightType: "Agent Status",
                  );
              break;
            case "Data Topic Clients":
              ref.read(actionRequestsProvider.notifier).leavingAssetScreen();
              ref
                      .read(actionRequestsProvider.notifier)
                      .dataTopicClientListUpdate =
                  true;
              ref
                  .read(guiDataProvider.notifier)
                  .showPopup(
                    title: "Data Topic Clients",
                    insightType: "Data Topic Clients",
                  );
              break;
            case "Transform Reporters":
              ref.read(actionRequestsProvider.notifier).leavingAssetScreen();
              ref
                      .read(actionRequestsProvider.notifier)
                      .transformReporterListUpdate =
                  true;
              ref
                  .read(guiDataProvider.notifier)
                  .showPopup(
                    title: "Transform Reporters & Clients",
                    insightType: "Transform Reporters",
                  );
              break;
            default:
              break;
          }
        },
        onClosePressed: () {
          ref.read(guiDataProvider.notifier).hideAssetLeftSidebar();
        },
        onItemTapped: (index) {
          ref
              .read(assetDataProvider.notifier)
              .setCurrentInsightMenuItemIndex(index);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class AssetRightSidebar extends ConsumerWidget {
  const AssetRightSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Style.navigatorBackgroundColor,
      child: const Center(
        child: Text(
          "AI Assist Placeholder",
          style: TextStyle(color: Colors.white),
        ),
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
