/**********************************************************************************
 * Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
 * All rights reserved. This material contains unpublished,
 * copyrighted work, which includes confidential and proprietary
 * information of Open Vision Technology, LLC..
 *
 * Open Vision Technology, LLC. and its licensors retain all intellectual property
 * and proprietary rights in and to this software, related documentation
 * and any modifications thereto. Any use, reproduction, disclosure or
 * distribution of this software and related documentation without an express
 * license agreement from Open Vision Technology, LLC. is strictly prohibited.
 *
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
 * *********************************************************************************
 */

import 'package:flutter/material.dart';
import '../style.dart';

class InsightList extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final int compStatusCount;
  final int agentStatusCount;
  final int dataTopicClientsCount;
  final int transformReportersCount;
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onCheckPressed;
  final VoidCallback onClosePressed;
  final ValueChanged<int> onItemTapped;

  const InsightList({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.compStatusCount,
    required this.agentStatusCount,
    required this.dataTopicClientsCount,
    required this.transformReportersCount,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onCheckPressed,
    required this.onClosePressed,
    required this.onItemTapped,
  });

  @override
  State<InsightList> createState() => _InsightListState();
}

class _InsightListState extends State<InsightList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant InsightList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _scrollToIndex(widget.selectedIndex);
    }
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients ||
        index < 0 ||
        index >= widget.items.length) {
      return;
    }

    const double cardHeight = 120.0; // Estimated card height including margins
    final double targetTop = index * cardHeight;
    final double targetBottom = targetTop + cardHeight;
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
        (targetBottom - viewportHeight).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        ),
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

  IconData _getInsightIcon(String item) {
    switch (item) {
      case "Comp Status":
        return Icons.analytics_outlined;
      case "Agent Status":
        return Icons.smart_toy_outlined;
      case "Data Topic Clients":
        return Icons.hub_outlined;
      case "Transform Reporters":
        return Icons.alt_route_outlined;
      default:
        return Icons.visibility_outlined;
    }
  }

  String _getInsightTitle(String item) {
    switch (item) {
      case "Comp Status":
        return "Component Status";
      case "Agent Status":
        return "Agent Status";
      case "Data Topic Clients":
        return "Data Topic Clients";
      case "Transform Reporters":
        return "Transform Reporters";
      default:
        return item;
    }
  }

  String _getInsightDescription(String item) {
    switch (item) {
      case "Comp Status":
        return "Component status details, health metrics, and subsystem records.";
      case "Agent Status":
        return "Active agent abstractions, telemetry, and execution states.";
      case "Data Topic Clients":
        return "Subscribers, publishers, and topic connectivity metrics.";
      case "Transform Reporters":
        return "broadcasters and client frame transformation trees.";
      default:
        return "Explore detailed diagnostic telemetry and information.";
    }
  }

  int _getInsightCount(String item) {
    switch (item) {
      case "Comp Status":
        return widget.compStatusCount;
      case "Agent Status":
        return widget.agentStatusCount;
      case "Data Topic Clients":
        return widget.dataTopicClientsCount;
      case "Transform Reporters":
        return widget.transformReportersCount;
      default:
        return 0;
    }
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
              borderRadius: const BorderRadius.only(
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
                const Expanded(
                  child: Center(
                    child: Text(
                      "Insights",
                      style: TextStyle(
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
          // Sidebar List of Cards
          Expanded(
            child: widget.items.isEmpty
                ? const Center(
                    child: Text(
                      "No Insight Items",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final title = _getInsightTitle(item);
                        final description = _getInsightDescription(item);
                        final icon = _getInsightIcon(item);
                        final count = _getInsightCount(item);
                        final isSelected = index == widget.selectedIndex;

                        // Avatar with icon container styling
                        final iconWidget = Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Style.headerBackgroundColor,
                                Style.navigatorBackgroundColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: Colors.white, size: 22),
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 6.0,
                          ),
                          elevation: isSelected ? 4 : 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? Style.btnHighlightColor
                                  : Colors.grey.shade300,
                              width: isSelected ? 2.2 : 1.0,
                            ),
                          ),
                          color: isSelected
                              ? Colors.amber.shade50.withOpacity(0.2)
                              : Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => widget.onItemTapped(index),
                            onDoubleTap: isSelected
                                ? widget.onCheckPressed
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      iconWidget,
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              description,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600,
                                                height: 1.25,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Dynamic count indicator badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: count > 0
                                              ? Colors.green.shade50
                                              : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: count > 0
                                                ? Colors.green.shade300
                                                : Colors.grey.shade300,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: count > 0
                                                    ? Colors.green
                                                    : Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              count > 0
                                                  ? "$count records cached"
                                                  : "No cached records",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: count > 0
                                                    ? Colors.green.shade800
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Interactive mini-button to retrieve data directly from the card
                                      if (isSelected)
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: widget.onCheckPressed,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Style.btnHighlightColor
                                                    .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color:
                                                      Style.btnHighlightColor,
                                                  width: 1,
                                                ),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Retrieve",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 8,
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
