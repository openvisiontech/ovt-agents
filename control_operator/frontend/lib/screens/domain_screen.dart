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

class DomainScreen extends ConsumerWidget {
  const DomainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guiData = ref.watch(guiDataProvider);

    final isSmallScreen =
        MediaQuery.of(context).size.width < Style.smallDeviceBreakpoint;

    final List<Widget> navButtons = [];

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
                          const SizedBox.shrink(), // Removed DomainSidebar
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
