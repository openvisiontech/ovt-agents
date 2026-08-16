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

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../style.dart';

class AgentList extends StatefulWidget {
  final List<Map<String, dynamic>> agents;
  final int selectedIndex;
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onCheckPressed;
  final VoidCallback onClosePressed;
  final ValueChanged<int> onItemTapped;
  final void Function(Map<String, dynamic> agent) onInfoPressed;

  const AgentList({
    super.key,
    required this.agents,
    required this.selectedIndex,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onCheckPressed,
    required this.onClosePressed,
    required this.onItemTapped,
    required this.onInfoPressed,
  });

  @override
  State<AgentList> createState() => _AgentListState();
}

class _AgentListState extends State<AgentList> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, Uint8List> _imageCache = {};

  void _cleanImageCache() {
    final activeBase64s = <String>{};
    for (final agent in widget.agents) {
      final profileStr = agent['ProfileImage']?.toString() ?? '';
      if (profileStr.startsWith("data:image/jpeg;base64,")) {
        activeBase64s.add(profileStr.substring("data:image/jpeg;base64,".length));
      }
    }
    _imageCache.removeWhere((key, value) => !activeBase64s.contains(key));
  }

  @override
  void didUpdateWidget(covariant AgentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _scrollToIndex(widget.selectedIndex);
    }
    _cleanImageCache();
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients ||
        index < 0 ||
        index >= widget.agents.length) {
      return;
    }

    // Estimate card height (including margin)
    const double cardHeight = 290.0;
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
        (targetBottom - viewportHeight).clamp(0.0, _scrollController.position.maxScrollExtent),
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

  Color _getStateColor(String state) {
    switch (state.toUpperCase()) {
      case 'RUNNING':
        return Colors.green;
      case 'PAUSED':
        return Colors.orange;
      case 'REQUEST_WAIT':
      case 'CONTROL_WAIT':
      case 'COMPLETE_WAIT':
        return Colors.amber.shade800;
      case 'COMPLETE':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getCompletionCodeColor(String code) {
    switch (code.toUpperCase()) {
      case 'SUCCESS':
        return Colors.green;
      case 'FAIL':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getAccessRightColor(String right) {
    switch (right.toUpperCase()) {
      case 'OPERATOR':
        return Colors.blue.shade700;
      case 'MAINTAINER':
        return Colors.purple.shade700;
      case 'ADMINISTRATOR':
        return Colors.red.shade700;
      case 'NOT_ALLOWED':
        return Colors.red;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatAddress(Map<String, dynamic>? address) {
    if (address == null) return "N/A";
    final subsystemId = address['SubsystemId'] ?? 0;
    final nodeId = address['NodeId'] ?? 0;
    final compId = address['CompId'] ?? 0;
    return "$subsystemId.$nodeId.$compId";
  }

  String _formatNum(dynamic val, int decimals) {
    if (val == null) return "N/A";
    if (val is num) {
      return val.toStringAsFixed(decimals);
    }
    final parsed = double.tryParse(val.toString());
    if (parsed != null) {
      return parsed.toStringAsFixed(decimals);
    }
    return val.toString();
  }

  Widget _buildFieldBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBox(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? "None" : value,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.black87,
              fontFamily: 'monospace',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
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
          // Header
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
                      "Agents",
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
            child: widget.agents.isEmpty
                ? const Center(
                    child: Text(
                      "No Agents Available",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      itemCount: widget.agents.length,
                      itemBuilder: (context, index) {
                        final agent = widget.agents[index];
                        final name = agent['Name']?.toString() ?? 'Unknown Agent';
                        final uri = agent['Uri']?.toString() ?? 'Unknown Uri';
                        
                        final stateVal = agent['State']?.toString() ?? 'UNKNOWN';
                        final completionCode = agent['CompletionCode']?.toString() ?? 'UNKNOWN';
                        final accessRight = agent['RequiredAppAccessRight']?.toString() ?? 'UNKNOWN';
                        
                        final runTime = agent['RunTime'];
                        final timeout = agent['CompletionTimeout'];
                        final num? timeoutNum = timeout is num ? timeout : num.tryParse(timeout?.toString() ?? '');
                        final bool hasTimeout = timeoutNum != null && timeoutNum > 0;
                        final requestor = agent['Requestor'] as Map<String, dynamic>?;

                        final config = agent['Configuration']?.toString() ?? '';
                        final feedback = agent['FeedbackData']?.toString() ?? '';

                        final profileStr = agent['ProfileImage']?.toString() ?? '';
                        Widget? profileWidget;
                        if (profileStr.startsWith("data:image/jpeg;base64,")) {
                          try {
                            final base64Data = profileStr.substring("data:image/jpeg;base64,".length);
                            final bytes = _imageCache.putIfAbsent(base64Data, () => base64Decode(base64Data));
                            profileWidget = ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                bytes,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              ),
                            );
                          } catch (e) {
                            // ignore error
                          }
                        }

                        if (profileWidget == null) {
                          profileWidget = Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Style.headerBackgroundColor, Style.navigatorBackgroundColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.smart_toy, color: Colors.white, size: 22),
                          );
                        }

                        final isSelected = index == widget.selectedIndex;

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                          elevation: isSelected ? 4 : 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? Style.btnHighlightColor : Colors.grey.shade300,
                              width: isSelected ? 2.2 : 1.0,
                            ),
                          ),
                          color: isSelected ? Colors.amber.shade50.withOpacity(0.2) : Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => widget.onItemTapped(index),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row: Avatar, Agent Name/Uri, Info button
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      profileWidget,
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              uri,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade600,
                                                fontFamily: 'monospace',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => widget.onInfoPressed(agent),
                                        tooltip: "Show context info",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Row 1: State & Completion Code
                                  Row(
                                    children: [
                                      _buildFieldBadge("State", stateVal, _getStateColor(stateVal)),
                                      const SizedBox(width: 6),
                                      _buildFieldBadge("Result", completionCode, _getCompletionCodeColor(completionCode)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  
                                  // Row 2: RequiredAppAccessRight & RunTime
                                  Row(
                                    children: [
                                      _buildFieldBadge("Access", accessRight, _getAccessRightColor(accessRight)),
                                      const SizedBox(width: 6),
                                      _buildFieldBadge("RunTime", "${_formatNum(runTime, 1)}s", Colors.blueGrey),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  // Row 3: Requestor & Timeout
                                  Row(
                                    children: [
                                      _buildFieldBadge("Req", _formatAddress(requestor), Colors.teal),
                                      const SizedBox(width: 6),
                                      _buildFieldBadge("Timeout", hasTimeout ? "${_formatNum(timeoutNum, 0)}s" : "None", Colors.brown),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // TextBox: Configuration
                                  _buildTextBox("Configuration", config),
                                  const SizedBox(height: 6),

                                  // TextBox: FeedbackData
                                  _buildTextBox("Feedback Data", feedback),
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
