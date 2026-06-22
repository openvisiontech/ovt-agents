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
import 'insight_list.dart';
import 'comp_popup_viewer.dart';

class InsightListExamples extends StatefulWidget {
  const InsightListExamples({super.key});

  @override
  State<InsightListExamples> createState() => _InsightListExamplesState();
}

class _InsightListExamplesState extends State<InsightListExamples> {
  final List<String> _items = [
    "Comp Status",
    "Agent Status",
    "Data Topic Clients",
    "Transform Reporters"
  ];
  int _selectedIndex = 0;

  // Mock counts that can be adjusted in the simulation panel
  int _compStatusCount = 5;
  int _agentStatusCount = 2;
  int _dataTopicClientsCount = 12;
  int _transformReportersCount = 8;

  // Popup overlay state
  bool _popupVisible = false;
  String _popupTitle = "";
  dynamic _popupJson;

  void _onUpPressed() {
    setState(() {
      if (_selectedIndex > 0) {
        _selectedIndex--;
      }
    });
  }

  void _onDownPressed() {
    setState(() {
      if (_selectedIndex < _items.length - 1) {
        _selectedIndex++;
      }
    });
  }

  void _onCheckPressed() {
    final item = _items[_selectedIndex];
    setState(() {
      _popupTitle = "$item Telemetry Response";
      switch (item) {
        case "Comp Status":
          _popupJson = {
            "statusdetails": List.generate(_compStatusCount, (i) => {
              "Component": "subsystem_comp_${i + 1}",
              "Health": i % 3 == 0 ? "DEGRADED" : "OK",
              "UptimeSeconds": 1000 + i * 500,
              "ErrorCount": i % 3 == 0 ? 2 : 0,
              "Details": {
                "version": "1.0.$i",
                "load": "${10.0 + i * 8.5}%",
                "memory_mb": 128 + i * 64
              }
            })
          };
          break;
        case "Agent Status":
          _popupJson = {
            "agentstatuslist": List.generate(_agentStatusCount, (i) => {
              "AgentId": "agent-unit-${i + 1}",
              "Status": i == 0 ? "ACTIVE" : "STANDBY",
              "RuntimeSeconds": 2400 + i * 3600,
              "Capabilities": ["navigation", "teleop", "sensor_relay"],
              "ActiveTasksCount": i == 0 ? 1 : 0
            })
          };
          break;
        case "Data Topic Clients":
          _popupJson = {
            "datatopicclientlist": List.generate(_dataTopicClientsCount, (i) => {
              "TopicUri": "/sys/diagnostics/topic_${i + 1}",
              "PublishersCount": 1,
              "SubscribersCount": i % 2 + 1,
              "Protocol": "WebSockets/WSS",
              "Encrypted": true
            })
          };
          break;
        case "Transform Reporters":
          _popupJson = {
            "transformreporterlist": List.generate((_transformReportersCount / 2).ceil(), (i) => {
              "FrameId": "link_reporter_${i + 1}",
              "ParentFrameId": "base_link",
              "BroadcastRateHz": 60.0,
              "BroadcastNode": "tf_node_${i + 1}"
            }),
            "transformclientlist": List.generate((_transformReportersCount / 2).floor(), (i) => {
              "FrameId": "client_link_${i + 1}",
              "ParentFrameId": "link_reporter_${i + 1}",
              "ClientNode": "processing_node_${i + 1}"
            })
          };
          break;
      }
      _popupVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeItem = _items[_selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('InsightList Widget Examples', style: TextStyle(color: Colors.white)),
        backgroundColor: Style.headerBackgroundColor,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
                _compStatusCount = 5;
                _agentStatusCount = 2;
                _dataTopicClientsCount = 12;
                _transformReportersCount = 8;
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Reset Demo Data', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // Left Panel: InsightList sidebar widget wrapper
              SizedBox(
                width: 320,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InsightList(
                    items: _items,
                    selectedIndex: _selectedIndex,
                    compStatusCount: _compStatusCount,
                    agentStatusCount: _agentStatusCount,
                    dataTopicClientsCount: _dataTopicClientsCount,
                    transformReportersCount: _transformReportersCount,
                    onUpPressed: _onUpPressed,
                    onDownPressed: _onDownPressed,
                    onCheckPressed: _onCheckPressed,
                    onClosePressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Close button pressed")),
                      );
                    },
                    onItemTapped: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),

              // Right Panel: Interactive simulation panel
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Insight Telemetry Simulator",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      // Active Item Card
                      Card(
                        color: const Color(0xFF2D2D2D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFF444444)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Simulating Selected Insight: $activeItem",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Adjust the slider counts to update the card badges in the sidebar. Select 'Retrieve' or click Check in the header to view the mock JSON responses.",
                                style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
                              ),
                              const Divider(color: Color(0xFF444444), height: 24),
                              
                              // Slider 1: Comp Status
                              _buildCountSlider(
                                label: "Component Status Records",
                                value: _compStatusCount,
                                max: 20,
                                onChanged: (val) => setState(() => _compStatusCount = val),
                              ),
                              
                              // Slider 2: Agent Status
                              _buildCountSlider(
                                label: "Active Agent Statuses",
                                value: _agentStatusCount,
                                max: 10,
                                onChanged: (val) => setState(() => _agentStatusCount = val),
                              ),
                              
                              // Slider 3: Data Topic Clients
                              _buildCountSlider(
                                label: "Topic Clients Connections",
                                value: _dataTopicClientsCount,
                                max: 40,
                                onChanged: (val) => setState(() => _dataTopicClientsCount = val),
                              ),
                              
                              // Slider 4: Transform Reporters
                              _buildCountSlider(
                                label: "Transform Reporters & Clients",
                                value: _transformReportersCount,
                                max: 30,
                                onChanged: (val) => setState(() => _transformReportersCount = val),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Popup viewer overlay
          if (_popupVisible)
            Container(
              color: Colors.black54,
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.70,
                  heightFactor: 0.80,
                  child: CompPopupViewer(
                    title: _popupTitle,
                    json: _popupJson,
                    onClose: () => setState(() => _popupVisible = false),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCountSlider({
    required String label,
    required int value,
    required double max,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label: $value",
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 5,
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: max,
              activeColor: Style.btnHighlightColor,
              inactiveColor: Colors.grey.shade700,
              onChanged: (val) => onChanged(val.round()),
            ),
          ),
        ],
      ),
    );
  }
}
