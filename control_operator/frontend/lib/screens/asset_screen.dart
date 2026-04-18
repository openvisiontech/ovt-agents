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
        highlight: guiData.agentsSidebarVisible,
        onPressed: () {
          // goAgentsView
          guiData.toggleAgentsSidebar();
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
          guiData.hideAgentsSidebar();
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
          guiData.hideAgentsSidebar();
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

    Widget contentBox = Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              // Center Box (Main Content)
              Expanded(
                child: Row(
                  children: [
                    if (guiData.agentsSidebarVisible)
                      const Expanded(flex: 1, child: AgentsSidebar()),
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Colors.black,
                        child: Stack(
                          children: [
                            const Positioned.fill(child: SceneWidget()),
                            if (guiData.agentsSidebarVisible)
                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.5,
                                  heightFactor: 0.5,
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
                      ),
                    ),
                  ],
                ),
              ),

              // Footer Box (Commander)
              if (guiData.commanderVisible)
                Container(
                  height: Style.commanderHeight,
                  color: Style.commanderBackgroundColor,
                  padding: EdgeInsets.all(Style.margin),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        IconTextBtn(
                          icon: guiData.haveControl
                              ? Icons.cancel
                              : Icons.gamepad,
                          description: guiData.haveControl
                              ? "Release"
                              : "Control",
                          width: Style.commanderBtnWidth,
                          height: double.infinity,
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
                          onPressed: () {
                            guiData.toggleControl();
                          },
                        ),
                        SizedBox(width: Style.commanderBtnSpacing),
                        IconTextBtn(
                          icon: Icons.person, // Mode
                          description: "Mode",
                          width: Style.commanderBtnWidth,
                          height: double.infinity,
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
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
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
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
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
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
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
                          onPressed: () {
                            // Shutdown command
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: guiData.commanderVisible ? Style.commanderHeight : 0,
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    guiData.toggleCommander();
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
                      guiData.commanderVisible
                          ? Icons.expand_more
                          : Icons.expand_less,
                      color: Style.commanderHoverColor,
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
    final guiData = ref.watch(guiDataProvider);

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
                    guiData.moveAgentUp();
                    _scrollToIndex(guiData.currentAgentIndex);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: () {
                    guiData.moveAgentDown();
                    _scrollToIndex(guiData.currentAgentIndex);
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
                    guiData.selectAgent();
                  },
                ),
              ],
            ),
          ),
          // Sidebar List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: guiData.agentItems.length,
              itemBuilder: (context, index) {
                return Container(
                  color: index == guiData.currentAgentIndex
                      ? Colors.blue[100]
                      : null,
                  child: ListTile(
                    title: Text(guiData.agentItems[index]),
                    onTap: () {
                      guiData.setCurrentAgentIndex(index);
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

class AssetHeaderWidget extends StatelessWidget {
  const AssetHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Asset: Target",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
