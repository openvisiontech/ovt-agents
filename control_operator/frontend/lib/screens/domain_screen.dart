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
        highlight: guiData.domainSidebarVisible,
        onPressed: () {
          guiData.toggleDomainSidebar();
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
              // Center Box (Main Content)
              Expanded(
                child: Row(
                  children: [
                    if (guiData.domainSidebarVisible)
                      const Expanded(flex: 1, child: DomainSidebar()),
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Colors.red[100],
                        child: Stack(
                          children: [
                            const Center(child: Text("Domain View Content")),
                            if (guiData.domainSidebarVisible)
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
                    guiData.moveAssetUp();
                    _scrollToIndex(guiData.currentAssetIndex);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: () {
                    guiData.moveAssetDown();
                    _scrollToIndex(guiData.currentAssetIndex);
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
                    guiData.selectAsset();
                  },
                ),
              ],
            ),
          ),
          // Sidebar List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: guiData.assetItems.length,
              itemBuilder: (context, index) {
                return Container(
                  color: index == guiData.currentAssetIndex
                      ? Colors.blue[100]
                      : null,
                  child: ListTile(
                    title: Text(guiData.assetItems[index]),
                    onTap: () {
                      guiData.setCurrentAssetIndex(index);
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

class DomainHeaderWidget extends StatelessWidget {
  const DomainHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Domain View",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
