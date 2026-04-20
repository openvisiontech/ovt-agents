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
        onPressed: () {},
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
        onPressed: () {},
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
      child: const Center(
        child: Text(
          "AI Assist Content",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    Widget contentBox = Expanded(
      child: isSmallScreen
          ? IndexedStack(
              index: guiData.smallScreenBoxIndex,
              children: [
                const Center(
                  child: Text(
                    "Left Sidebar Placeholder",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                // Assuming placeholders for sidebar until AI Assist logic requires specific sidebars.
                // Or if AI Assist has visible sidebars tracking logic:
                if (guiData
                    .domainLeftSidebarVisible) // Place holder toggle logic if any needed
                  const Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Left Sidebar Placeholder",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                Expanded(flex: 4, child: mainContent),
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
