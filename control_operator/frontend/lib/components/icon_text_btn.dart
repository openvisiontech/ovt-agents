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
