import 'package:flutter/material.dart';
import '../style.dart';

class IconTextBtn extends StatefulWidget {
  final IconData icon;
  final String description;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? iconSize;
  final Color backgroundColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color greyoutColor;
  final bool highlight;
  final bool greyout;

  const IconTextBtn({
    super.key,
    required this.icon,
    required this.description,
    this.onPressed,
    this.width,
    this.height,
    this.iconSize,
    this.backgroundColor = Style.navigatorBackgroundColor,
    this.hoverColor = Style.btnHoverColor,
    this.highlightColor = Style.btnHighlightColor,
    this.greyoutColor = Style.btnGreyoutColor,
    this.highlight = false,
    this.greyout = false,
  });

  @override
  State<IconTextBtn> createState() => _IconTextBtnState();
}

class _IconTextBtnState extends State<IconTextBtn> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color currentColor = widget.backgroundColor;
    if (widget.greyout) {
      currentColor = widget.greyoutColor;
    } else if (_isHovering) {
      currentColor = widget.hoverColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: widget.greyout
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.greyout ? null : widget.onPressed,
        child: Container(
          width: widget.width,
          height: widget.height,
          color: currentColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: widget.iconSize ?? 24,
                color: widget.highlight ? widget.highlightColor : Colors.white,
              ),
              if (widget.description.isNotEmpty)
                Text(
                  widget.description,
                  style: TextStyle(
                    color: widget.highlight
                        ? widget.highlightColor
                        : Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
