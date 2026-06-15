import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../style.dart';

class CompPopupViewer extends StatefulWidget {
  final String title;
  final dynamic json;
  final String? markdown;
  final VoidCallback onClose;

  const CompPopupViewer({
    super.key,
    required this.title,
    this.json,
    this.markdown,
    required this.onClose,
  });

  @override
  State<CompPopupViewer> createState() => _CompPopupViewerState();
}

class _CompPopupViewerState extends State<CompPopupViewer> {
  bool _isTreeView = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollUp() {
    if (_scrollController.hasClients) {
      final target = (_scrollController.offset - 150).clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollDown() {
    if (_scrollController.hasClients) {
      final target = (_scrollController.offset + 150).clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasJson = widget.json != null;
    final hasMarkdown = widget.markdown != null && widget.markdown!.isNotEmpty;

    return Card(
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Style.borderColor, width: 2),
      ),
      color: Colors.white,
      child: Column(
        children: [
          // Header Area
          Container(
            height: 54,
            decoration: const BoxDecoration(
              color: Style.headerBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasJson) ...[
                  // Toggle view mode
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToggleButton(
                          label: "Tree View",
                          isActive: _isTreeView,
                          onPressed: () => setState(() => _isTreeView = true),
                        ),
                        _buildToggleButton(
                          label: "Raw JSON",
                          isActive: !_isTreeView,
                          onPressed: () => setState(() => _isTreeView = false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                  tooltip: "Scroll Up",
                  onPressed: _scrollUp,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  tooltip: "Scroll Down",
                  onPressed: _scrollDown,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  tooltip: "Close Popup",
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: Container(
              color: const Color(0xFF1E1E1E), // Premium dark theme for details
              width: double.infinity,
              child: _buildContent(hasJson, hasMarkdown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Style.btnHighlightColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool hasJson, bool hasMarkdown) {
    if (!hasJson && !hasMarkdown) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Style.btnHighlightColor),
            ),
            SizedBox(height: 16),
            Text(
              "Waiting for data...",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (hasJson) {
      if (_isTreeView) {
        return Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: JsonTreeViewer(json: widget.json),
          ),
        );
      } else {
        return RawJsonViewer(json: widget.json, scrollController: _scrollController);
      }
    }

    // Otherwise Markdown
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: Markdown(
        controller: _scrollController,
        data: widget.markdown!,
        styleSheet: MarkdownStyleSheet.fromTheme(
          Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
              bodyMedium: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ).copyWith(
          p: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          h1: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 2),
          h2: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.8),
          h3: const TextStyle(color: Style.btnHighlightColor, fontSize: 15, fontWeight: FontWeight.bold, height: 1.6),
          listBullet: const TextStyle(color: Style.btnHighlightColor),
          code: const TextStyle(
            color: Color(0xFFCE9178),
            backgroundColor: Color(0xFF2D2D2D),
            fontFamily: 'monospace',
            fontSize: 13,
          ),
          codeblockPadding: const EdgeInsets.all(12),
          codeblockDecoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade800),
          ),
        ),
      ),
    );
  }
}

/// A tree viewer widget for Map and List structures.
class JsonTreeViewer extends StatelessWidget {
  final dynamic json;

  const JsonTreeViewer({super.key, required this.json});

  @override
  Widget build(BuildContext context) {
    if (json is Map<String, dynamic>) {
      final map = json as Map<String, dynamic>;
      if (map.isEmpty) {
        return const Text("{}", style: TextStyle(color: Colors.grey, fontFamily: 'monospace'));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: map.entries.map((e) => JsonNodeWidget(nodeKey: e.key, value: e.value)).toList(),
      );
    } else if (json is List<dynamic>) {
      final list = json as List<dynamic>;
      if (list.isEmpty) {
        return const Text("[]", style: TextStyle(color: Colors.grey, fontFamily: 'monospace'));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          list.length,
          (i) => JsonNodeWidget(nodeKey: "[$i]", value: list[i]),
        ),
      );
    } else {
      return JsonValueWidget(value: json);
    }
  }
}

/// An interactive, collapsible node in the JSON hierarchy.
class JsonNodeWidget extends StatefulWidget {
  final String nodeKey;
  final dynamic value;

  const JsonNodeWidget({
    super.key,
    required this.nodeKey,
    required this.value,
  });

  @override
  State<JsonNodeWidget> createState() => _JsonNodeWidgetState();
}

class _JsonNodeWidgetState extends State<JsonNodeWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final val = widget.value;
    final isCollapsible = val is Map<String, dynamic> || val is List<dynamic>;

    if (!isCollapsible) {
      return Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 4, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.nodeKey}: ",
              style: const TextStyle(
                color: Color(0xFF9CDCFE), // Light blue for keys
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(child: JsonValueWidget(value: val)),
          ],
        ),
      );
    }

    final int childCount = val is Map ? val.length : (val as List).length;
    final String bracketOpen = val is Map ? "{" : "[";
    final String bracketClose = val is Map ? "}" : "]";
    final String typeLabel = val is Map ? "Object" : "Array";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                    color: Colors.white54,
                    size: 20,
                  ),
                  Text(
                    "${widget.nodeKey}: ",
                    style: const TextStyle(
                      color: Color(0xFF9CDCFE),
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    bracketOpen,
                    style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13),
                  ),
                  if (!_isExpanded)
                    Text(
                      " ... $bracketClose ($childCount items, $typeLabel)",
                      style: const TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: JsonTreeViewer(json: val),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 4),
            child: Text(
              bracketClose,
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ],
      ],
    );
  }
}

/// Renders a leaf/primitive JSON value.
class JsonValueWidget extends StatelessWidget {
  final dynamic value;

  const JsonValueWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return const Text(
        "null",
        style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 13),
      );
    } else if (value is bool) {
      return Text(
        value.toString(),
        style: const TextStyle(color: Color(0xFF569CD6), fontFamily: 'monospace', fontSize: 13), // Blue
      );
    } else if (value is num) {
      return Text(
        value.toString(),
        style: const TextStyle(color: Color(0xFFB5CEA8), fontFamily: 'monospace', fontSize: 13), // Soft green-yellow
      );
    } else {
      // String or fallback
      return Text(
        "\"$value\"",
        style: const TextStyle(color: Color(0xFFCE9178), fontFamily: 'monospace', fontSize: 13), // Amber/salmon
      );
    }
  }
}

/// Renders the raw JSON string with Copy to Clipboard support.
class RawJsonViewer extends StatelessWidget {
  final dynamic json;
  final ScrollController? scrollController;

  const RawJsonViewer({super.key, required this.json, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final String rawJsonStr = const JsonEncoder.withIndent('  ').convert(json);

    return Column(
      children: [
        Container(
          color: const Color(0xFF252526),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.copy, size: 16, color: Colors.black),
                label: const Text("Copy JSON", style: TextStyle(color: Colors.black, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Style.btnHighlightColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: rawJsonStr));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("JSON copied to clipboard!"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(
                rawJsonStr,
                style: const TextStyle(
                  color: Color(0xFFD4D4D4),
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
