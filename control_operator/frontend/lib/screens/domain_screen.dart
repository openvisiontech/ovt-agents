import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../style.dart';
import '../components/icon_text_btn.dart';

class DomainScreen extends ConsumerWidget {
  const DomainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guiData = ref.watch(guiDataProvider);
    final isSmallScreen =
        MediaQuery.of(context).size.width < Style.smallDeviceBreakpoint;

    final List<Widget> navButtons = [
      IconTextBtn(
        icon: Icons.list, // List (Asset List)
        description: "List",
        width: Style.navigatorBtnWidth,
        height: Style.navigatorBtnHeight,
        backgroundColor: Style.navigatorBackgroundColor,
        hoverColor: Style.navigatorBtnHoverColor,
        iconSize: Style.navigatorBtnIconPixelSize,
        highlight: guiData.domainLeftSidebarVisible,
        onPressed: () {
          guiData.toggleDomainLeftSidebar();
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
      color: Colors.red[100],
      child: Stack(
        children: [
          const Center(child: Text("Domain View Content")),
          if (guiData.domainLeftSidebarVisible && !isSmallScreen)
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
                          const DomainSidebar(),
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
                          if (guiData.domainLeftSidebarVisible)
                            const Expanded(flex: 1, child: DomainSidebar()),
                          Expanded(flex: 4, child: mainContent),
                          if (guiData.domainRightSidebarVisible)
                            const Expanded(
                              flex: 1,
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

              // Footer Box (Bottom Bar)
              if (guiData.domainCommanderVisible)
                Container(
                  height: Style.commanderHeight,
                  color: Style.commanderBackgroundColor,
                  padding: EdgeInsets.all(Style.margin),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        IconTextBtn(
                          icon: Icons.arrow_back,
                          description: "Left",
                          width: Style.commanderBtnWidth,
                          height: double.infinity,
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
                          onPressed: () {},
                        ),
                        SizedBox(width: Style.commanderBtnSpacing),
                        IconTextBtn(
                          icon: Icons.arrow_forward,
                          description: "Right",
                          width: Style.commanderBtnWidth,
                          height: double.infinity,
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
                          onPressed: () {},
                        ),
                        SizedBox(width: Style.commanderBtnSpacing),
                        IconTextBtn(
                          icon: Icons.arrow_upward,
                          description: "Up",
                          width: Style.commanderBtnWidth,
                          height: double.infinity,
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
                          onPressed: () {},
                        ),
                        SizedBox(width: Style.commanderBtnSpacing),
                        IconTextBtn(
                          icon: Icons.arrow_downward,
                          description: "Down",
                          width: Style.commanderBtnWidth,
                          height: double.infinity,
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
                          onPressed: () {},
                        ),
                        SizedBox(width: Style.commanderBtnSpacing),
                        IconTextBtn(
                          icon: Icons.zoom_in,
                          description: "Zoom In",
                          width: Style.commanderBtnWidth,
                          height: double.infinity,
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
                          onPressed: () {},
                        ),
                        SizedBox(width: Style.commanderBtnSpacing),
                        IconTextBtn(
                          icon: Icons.zoom_out,
                          description: "Zoom Out",
                          width: Style.commanderBtnWidth,
                          height: double.infinity,
                          backgroundColor: Style.commanderBackgroundColor,
                          hoverColor: Style.commanderHoverColor,
                          iconSize: Style.commanderBtnIconPixelSize,
                          onPressed: () {},
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
            bottom: guiData.domainCommanderVisible ? Style.commanderHeight : 0,
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    guiData.toggleDomainCommander();
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
                      guiData.domainCommanderVisible
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

          // Sidebar (Assets)
          // Sidebar (Assets)
          // Sidebar removed from Stack
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

class DomainSidebar extends ConsumerStatefulWidget {
  const DomainSidebar({super.key});

  @override
  ConsumerState<DomainSidebar> createState() => _DomainSidebarState();
}

class _DomainSidebarState extends ConsumerState<DomainSidebar> {
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
    final domainData = ref.watch(domainDataProvider);

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
                    domainData.moveAssetUp();
                    _scrollToIndex(domainData.currentAssetIndex);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: () {
                    domainData.moveAssetDown();
                    _scrollToIndex(domainData.currentAssetIndex);
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Assets",
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
                    if (domainData.subsystemControlAbstractions.isNotEmpty &&
                        domainData.currentAssetIndex <
                            domainData.subsystemControlAbstractions.length) {
                      guiData.subsystemId = domainData.currentAssetSubsystemId;
                      guiData.nodeId = domainData.currentAssetNodeId;
                      guiData.compId = domainData.currentAssetCompId;
                      guiData.name = domainData.currentAssetName;
                      guiData.controlStatus = "UNKNOWN";
                      guiData.controlAvail = "UNKNOWN";
                      guiData.haveAccess = "UNKNOWN";
                      guiData.appAccessRight = "UNKNOWN";
                      guiData.dataAccessRight = "UNKNOWN";
                      guiData.haveControl = "UNKNOWN";
                      guiData.subsystemState = "UNKNOWN";
                      guiData.operatingCategory = "UNKNOWN";
                      guiData.operatingMode = "UNKNOWN";

                      final assetData = ref.read(assetDataProvider.notifier);
                      assetData.subsystemId =
                          domainData.currentAssetSubsystemId;
                      assetData.nodeId = domainData.currentAssetNodeId;
                      assetData.compId = domainData.currentAssetCompId;
                      assetData.interactionMode = "WATCH";
                      assetData.estopButton = "CLEAR";
                      assetData.subsystemStateCmd = "UNKNOWN";
                      assetData.operatingCategory = "UNKNOWN";
                      assetData.operatingMode = "UNKNOWN";
                      assetData.selectedAgentName = "";
                      assetData.selectedAgentUri = "";
                      assetData.agentRunningCmd = "UNKNOWN";
                      assetData.agentControlCmd = "UNKNOWN";
                      assetData.userParams = "";
                      assetData.agentCompletionTimeout = 0;
                    }
                  },
                ),
              ],
            ),
          ),
          // Sidebar List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: domainData.assetItems.length,
              itemBuilder: (context, index) {
                return Container(
                  color: index == domainData.currentAssetIndex
                      ? Colors.blue[100]
                      : null,
                  child: ListTile(
                    title: Text(domainData.assetItems[index]),
                    onTap: () {
                      domainData.setCurrentAssetIndex(index);
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

class DomainHeaderWidget extends ConsumerWidget {
  final bool isSmallScreen;
  const DomainHeaderWidget({super.key, required this.isSmallScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guiData = ref.watch(guiDataProvider);

    return Row(
      children: [
        const Expanded(
          child: Center(
            child: Text(
              "Domain View",
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
