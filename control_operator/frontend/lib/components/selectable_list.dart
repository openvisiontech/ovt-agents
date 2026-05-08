import 'dart:convert';
import 'package:flutter/material.dart';
import '../style.dart';

class SelectableList extends StatefulWidget {
  final String title;
  final List<String> items;
  final int selectedIndex;
  final List<Color>? statusColors;
  final List<Widget>? trailingWidgets;
  final List<String>? profileImages;
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onCheckPressed;
  final VoidCallback onClosePressed;
  final ValueChanged<int> onItemTapped;

  const SelectableList({
    super.key,
    required this.title,
    required this.items,
    required this.selectedIndex,
    this.statusColors,
    this.trailingWidgets,
    this.profileImages,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onCheckPressed,
    required this.onClosePressed,
    required this.onItemTapped,
  });

  @override
  State<SelectableList> createState() => _SelectableListState();
}

class _SelectableListState extends State<SelectableList> {
  final ScrollController _scrollController = ScrollController();
  final double _itemHeight = 56.0; // Approximate height of a ListTile

  @override
  void didUpdateWidget(covariant SelectableList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _scrollToIndex(widget.selectedIndex);
    }
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients ||
        index < 0 ||
        index >= widget.items.length)
      return;

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
            decoration: BoxDecoration(
              color: Style.headerBackgroundColor,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Colors.white),
                  onPressed: widget.onUpPressed,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: widget.onDownPressed,
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: widget.onCheckPressed,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: widget.onClosePressed,
                ),
              ],
            ),
          ),
          // Sidebar List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                Widget? statusIcon;
                if (widget.statusColors != null &&
                    index < widget.statusColors!.length) {
                  statusIcon = Icon(
                    Icons.circle,
                    color: widget.statusColors![index],
                    size: 16,
                  );
                }

                Widget? trailingWidget;
                if (widget.trailingWidgets != null &&
                    index < widget.trailingWidgets!.length) {
                  trailingWidget = widget.trailingWidgets![index];
                }

                Widget? combinedTrailing;
                if (statusIcon != null && trailingWidget != null) {
                  combinedTrailing = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [statusIcon, const SizedBox(width: 8), trailingWidget],
                  );
                } else {
                  combinedTrailing = statusIcon ?? trailingWidget;
                }

                Widget? leadingWidget;
                if (widget.profileImages != null &&
                    index < widget.profileImages!.length) {
                  String profileStr = widget.profileImages![index];
                  if (profileStr.startsWith("data:image/jpeg;base64,")) {
                    try {
                      String base64Data = profileStr.substring("data:image/jpeg;base64,".length);
                      leadingWidget = ClipOval(
                        child: Image.memory(
                          base64Decode(base64Data),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      );
                    } catch (e) {
                      // ignore error
                    }
                  }
                }

                return Container(
                  color: index == widget.selectedIndex
                      ? Colors.blue[100]
                      : null,
                  child: ListTile(
                    title: Text(widget.items[index]),
                    leading: leadingWidget,
                    trailing: combinedTrailing,
                    onTap: () {
                      widget.onItemTapped(index);
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
