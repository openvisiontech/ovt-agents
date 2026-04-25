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
    final actionRequests = ref.watch(actionRequestsProvider);

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
        highlight: actionRequests.assetListAutoUpdate,
        onPressed: () {
          actionRequests.toggleAssetListAutoUpdate();
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
          const Center(child: Text("Domain View Content")),
          if (guiData.domainPopupVisible && !isSmallScreen)
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
                            const Expanded(flex: 2, child: DomainSidebar()),
                          Expanded(flex: 7, child: mainContent),
                          if (guiData.domainRightSidebarVisible)
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

              // Footer Box (Bottom Bar)
              if (guiData.domainCommanderVisible)
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
                            icon: Icons.arrow_back,
                            description: "Left",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            onPressed: () {},
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.arrow_forward,
                            description: "Right",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            onPressed: () {},
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.arrow_upward,
                            description: "Up",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            onPressed: () {},
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.arrow_downward,
                            description: "Down",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            onPressed: () {},
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.zoom_in,
                            description: "Zoom In",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            onPressed: () {},
                          ),
                          SizedBox(width: Style.commanderBtnSpacing),
                          IconTextBtn(
                            icon: Icons.zoom_out,
                            description: "Zoom Out",
                            width: Style.commanderBtnWidth,
                            height: double.infinity,
                            backgroundColor: Style.commanderBtnBackgroundColor,
                            hoverColor: Style.commanderBtnHoverColor,
                            iconSize: Style.commanderBtnIconPixelSize,
                            onPressed: () {},
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
                      color: Style.commanderBtnHoverColor,
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
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: () {
                    if (domainData.subsystemAbstractions.isNotEmpty &&
                        domainData.currentAssetIndex <
                            domainData.subsystemAbstractions.length) {
                      final assetData = ref.read(assetDataProvider.notifier);
                      assetData.assetName = domainData.currentAssetName;
                      assetData.subsystemId =
                          int.tryParse(
                            domainData.currentAssetSubsystemId.toString(),
                          ) ??
                          0;
                      assetData.nodeId =
                          int.tryParse(
                            domainData.currentAssetNodeId.toString(),
                          ) ??
                          0;
                      assetData.compId =
                          int.tryParse(
                            domainData.currentAssetCompId.toString(),
                          ) ??
                          0;

                      assetData.controlStatus =
                          domainData.currentAssetControlStatus;
                      assetData.controlAvail =
                          domainData.currentAssetControlAvail;

                      assetData.haveAccess = "UNKNOWN";
                      assetData.appAccessRight = "UNKNOWN";
                      assetData.dataAccessRight = "UNKNOWN";
                      assetData.haveControl = "UNKNOWN";
                      assetData.subsystemStateCmd = "UNKNOWN";
                      assetData.operatingCategory = "UNKNOWN";
                      assetData.operatingMode = "UNKNOWN";

                      assetData.interactionMode = "WATCH";
                      assetData.subsystemStateCmd = "UNKNOWN";
                      assetData.operatingCategory = "UNKNOWN";
                      assetData.operatingMode = "UNKNOWN";
                      assetData.selectedAgentName = "";
                      assetData.selectedAgentUri = "";
                      assetData.agentRunningCmd = "UNKNOWN";
                      assetData.agentControlCmd = "UNKNOWN";
                      assetData.userParams = {};
                      assetData.agentCompletionTimeout = 0;
                    }
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Assets",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    //hide the domain left sidebar
                    //stop the asset list auto update
                    ref.read(guiDataProvider.notifier).hideDomainLeftSidebar();
                    ref
                            .read(actionRequestsProvider.notifier)
                            .assetListAutoUpdate =
                        false;
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
                Color statusColor = Colors.grey;
                if (domainData.subsystemAbstractions.isNotEmpty &&
                    index < domainData.subsystemAbstractions.length) {
                  final asset = domainData.subsystemAbstractions[index];
                  if (asset is Map) {
                    final controlStatus =
                        asset['ControlStatus']?.toString() ?? "UNKNOWN";
                    switch (controlStatus) {
                      case "NOT_AVAILABLE":
                        statusColor = Colors.red;
                        break;
                      case "NOT_CONTROLLED":
                        statusColor = Colors.green;
                        break;
                      case "UNDER_CONTROLLED":
                        statusColor = Colors.yellow;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }
                  }
                }

                return Container(
                  color: index == domainData.currentAssetIndex
                      ? Colors.blue[100]
                      : null,
                  child: ListTile(
                    leading: Icon(Icons.circle, color: statusColor, size: 16),
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
