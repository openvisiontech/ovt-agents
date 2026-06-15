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
import 'package:flutter/material.dart';
import '../style.dart';

class AssetList extends StatefulWidget {
  final List<Map<String, dynamic>> assets;
  final int selectedIndex;
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onCheckPressed;
  final VoidCallback onClosePressed;
  final ValueChanged<int> onItemTapped;
  final void Function(Map<String, dynamic> asset) onInfoPressed;

  const AssetList({
    super.key,
    required this.assets,
    required this.selectedIndex,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onCheckPressed,
    required this.onClosePressed,
    required this.onItemTapped,
    required this.onInfoPressed,
  });

  @override
  State<AssetList> createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant AssetList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _scrollToIndex(widget.selectedIndex);
    }
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients ||
        index < 0 ||
        index >= widget.assets.length) {
      return;
    }

    // Rough estimate of card height (including margin)
    const double cardHeight = 220.0;
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

  Color _getControlStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NOT_AVAILABLE':
        return Colors.red;
      case 'NOT_CONTROLLED':
        return Colors.green;
      case 'UNDER_CONTROLLED':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPoseLabel(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black87,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
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
          // Header (consistency with sidebar layout)
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
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: widget.onClosePressed,
                ),
              ],
            ),
          ),
          // Sidebar List of Cards
          Expanded(
            child: widget.assets.isEmpty
                ? const Center(
                    child: Text(
                      "No Subsystems Discovered",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      itemCount: widget.assets.length,
                      itemBuilder: (context, index) {
                        final asset = widget.assets[index];
                        final name = asset['Name']?.toString() ?? 'Unknown';
                        final type = asset['SubsystemType']?.toString() ?? 'UNKNOWN';
                        
                        final address = asset['Address'] as Map<String, dynamic>? ?? {};
                        final subsystemId = address['SubsystemId'] ?? 0;
                        final nodeId = address['NodeId'] ?? 0;
                        final compId = address['CompId'] ?? 0;
                        
                        final controlStatus = asset['ControlStatus']?.toString() ?? 'UNKNOWN';
                        final controlAvailable = !(controlStatus == 'UNKNOWN' || controlStatus == 'NOT_AVAILABLE');
                        
                        final pose = asset['Pose'] as Map<String, dynamic>?;
                        final frame = pose?['Frame']?.toString() ?? 'unknown';

                        final profileStr = asset['ProfileImage']?.toString() ?? '';
                        Widget? profileWidget;
                        if (profileStr.startsWith("data:image/jpeg;base64,")) {
                          try {
                            String base64Data = profileStr.substring("data:image/jpeg;base64,".length);
                            profileWidget = ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                base64Decode(base64Data),
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
                          IconData typeIcon;
                          switch (type.toUpperCase()) {
                            case 'UNMANNED':
                              typeIcon = Icons.directions_car;
                              break;
                            case 'AI_AGENT':
                              typeIcon = Icons.smart_toy;
                              break;
                            case 'CONTROLLER':
                              typeIcon = Icons.gamepad;
                              break;
                            case 'META_HUMAN':
                              typeIcon = Icons.person;
                              break;
                            case 'PROCESS_TOOL':
                              typeIcon = Icons.build;
                              break;
                            default:
                              typeIcon = Icons.help_outline;
                          }
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
                            child: Icon(typeIcon, color: Colors.white, size: 22),
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
                                  // Header Row: Avatar, Subsystem Name/ID, Info button
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
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "Subsystem ID: $subsystemId",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "Addr: $subsystemId.$nodeId.$compId",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => widget.onInfoPressed(asset),
                                        tooltip: "Show context info",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Control Available Status Row
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.sports_esports,
                                        size: 14,
                                        color: controlAvailable ? Colors.green : Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Control: ${controlAvailable ? 'Available' : 'Unavailable'}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: controlAvailable ? Colors.green.shade700 : Colors.grey.shade600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: _getControlStatusColor(controlStatus).withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: _getControlStatusColor(controlStatus),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Text(
                                          controlStatus,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: _getControlStatusColor(controlStatus),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Pose Details Area
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade200, width: 1),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Pose Info",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              "Frame: $frame",
                                              style: const TextStyle(
                                                fontSize: 9,
                                                color: Colors.black54,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        if (pose == null)
                                          const Text(
                                            "Pose is not available",
                                            style: TextStyle(fontSize: 10, color: Colors.grey),
                                          )
                                        else
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 4,
                                            children: [
                                              _buildPoseLabel("Lat", _formatNum(pose['Latitude'], 5)),
                                              _buildPoseLabel("Lon", _formatNum(pose['Longitude'], 5)),
                                              _buildPoseLabel("X", "${_formatNum(pose['XPosition'], 2)}m"),
                                              _buildPoseLabel("Y", "${_formatNum(pose['YPosition'], 2)}m"),
                                              _buildPoseLabel("Z", "${_formatNum(pose['ZPosition'], 2)}m (${pose['ZPositionType'] ?? 'UNKNOWN'})"),
                                              _buildPoseLabel("Roll", "${_formatNum(pose['Roll'], 1)}°"),
                                              _buildPoseLabel("Pitch", "${_formatNum(pose['Pitch'], 1)}°"),
                                              _buildPoseLabel("Heading", "${_formatNum(pose['Heading'], 1)}°"),
                                            ],
                                          ),
                                      ],
                                    ),
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
