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
import 'agent_list.dart';
import 'comp_popup_viewer.dart';

class AgentListExamples extends StatefulWidget {
  const AgentListExamples({super.key});

  @override
  State<AgentListExamples> createState() => _AgentListExamplesState();
}

class _AgentListExamplesState extends State<AgentListExamples> {
  late List<Map<String, dynamic>> _agents;
  int _selectedIndex = 0;

  // Popup state
  bool _popupVisible = false;
  String _popupTitle = "";
  dynamic _popupJson;
  String? _popupMarkdown;

  // Form editing controllers
  final TextEditingController _configController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetMockData();
  }

  @override
  void dispose() {
    _configController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _resetMockData() {
    setState(() {
      _selectedIndex = 0;
      _agents = [
        {
          "Name": "Path Planner Agent",
          "Uri": "agent://scout_ugv_01/navigation/path_planner",
          "User": "YES",
          "Comp": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 200,
          },
          "Configuration": '{"max_speed": 2.5, "allow_backward": true, "safety_margin": 0.5}',
          "RequiredAppAccessRight": "OPERATOR",
          "Context": """# Path Planner Agent Context
Responsible for computing obstacle-free trajectories from current pose to designated target coordinates.

### Parameters:
- **max_speed**: Maximum speed limit for path planning.
- **safety_margin**: Clear radius around known obstacles.""",
          "ProfileImage": "",
          "Requestor": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 100,
          },
          "CompletionTimeout": 30.0,
          "RunTime": 14.5,
          "EnterStateTime": 1718000000.0,
          "State": "RUNNING",
          "FeedbackData": "Navigating to waypoint (12.5, -45.2). Distance remaining: 3.2m.",
          "CompletionCode": "UNKNOWN",
        },
        {
          "Name": "Thermal Threat Detector",
          "Uri": "agent://scout_ugv_01/perception/thermal_threat",
          "User": "NO",
          "Comp": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 201,
          },
          "Configuration": '{"threshold_temp_c": 37.5, "alert_on_human": true}',
          "RequiredAppAccessRight": "OPERATOR",
          "Context": """# Thermal Threat Detector Context
Monitors thermal video feed to identify heat signatures exceeding ambient levels, warning of potential personnel or hotspots.""",
          "ProfileImage": "",
          "Requestor": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 100,
          },
          "CompletionTimeout": 0.0,
          "RunTime": 128.0,
          "EnterStateTime": 1718000000.0,
          "State": "RUNNING",
          "FeedbackData": "Scanning area... No threats detected. Ambient temperature: 22.1C.",
          "CompletionCode": "UNKNOWN",
        },
        {
          "Name": "Diagnostics Self-Test",
          "Uri": "agent://scout_ugv_01/system/diagnostics",
          "User": "NO",
          "Comp": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 202,
          },
          "Configuration": '{"deep_scan": true, "check_can_bus": true}',
          "RequiredAppAccessRight": "MAINTAINER",
          "Context": """# Diagnostics Self-Test Context
Performs a deep diagnostic scan of internal modules including drive motors, battery management systems, CAN bus connectivity, and sensors.""",
          "ProfileImage": "",
          "Requestor": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 102,
          },
          "CompletionTimeout": 10.0,
          "RunTime": 8.2,
          "EnterStateTime": 1718000000.0,
          "State": "COMPLETE",
          "FeedbackData": "All subsystems reporting operational. CAN bus jitter: 0.12ms.",
          "CompletionCode": "SUCCESS",
        },
        {
          "Name": "Calibration Agent",
          "Uri": "agent://scout_ugv_01/system/calibration",
          "User": "YES",
          "Comp": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 203,
          },
          "Configuration": '{"sensor_id": "lidar_vlp16", "ref_points_count": 10}',
          "RequiredAppAccessRight": "ADMINISTRATOR",
          "Context": """# Calibration Agent Context
Allows administrators to calibrate LiDAR extrinsic parameters against known reference points.""",
          "ProfileImage": "",
          "Requestor": null,
          "CompletionTimeout": 60.0,
          "RunTime": 0.0,
          "EnterStateTime": 1718000000.0,
          "State": "UNKNOWN",
          "FeedbackData": "",
          "CompletionCode": "UNKNOWN",
        }
      ];

      _updateTextControllers();
    });
  }

  void _updateTextControllers() {
    if (_agents.isNotEmpty && _selectedIndex < _agents.length) {
      final agent = _agents[_selectedIndex];
      _configController.text = agent['Configuration']?.toString() ?? '';
      _feedbackController.text = agent['FeedbackData']?.toString() ?? '';
    }
  }

  void _onUpPressed() {
    setState(() {
      if (_selectedIndex > 0) {
        _selectedIndex--;
        _updateTextControllers();
      }
    });
  }

  void _onDownPressed() {
    setState(() {
      if (_selectedIndex < _agents.length - 1) {
        _selectedIndex++;
        _updateTextControllers();
      }
    });
  }

  void _onCheckPressed() {
    final agent = _agents[_selectedIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Activated Agent: ${agent['Name']} (${agent['Uri']})"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onInfoPressed(Map<String, dynamic> agent) {
    setState(() {
      _popupTitle = "${agent['Name']} Context Details";
      _popupJson = agent;
      _popupMarkdown = agent['Context']?.toString();
      _popupVisible = true;
    });
  }

  void _updateSelectedField(String field, dynamic val) {
    setState(() {
      _agents[_selectedIndex] = {
        ..._agents[_selectedIndex],
        field: val,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeAgent = _agents[_selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('AgentList Widget Examples', style: TextStyle(color: Colors.white)),
        backgroundColor: Style.headerBackgroundColor,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _resetMockData,
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
              // Left Panel: AgentList component wrapped in a fixed-width container to mimic sidebar
              SizedBox(
                width: 320,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AgentList(
                    agents: _agents,
                    selectedIndex: _selectedIndex,
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
                        _updateTextControllers();
                      });
                    },
                    onInfoPressed: _onInfoPressed,
                  ),
                ),
              ),

              // Right Panel: Interactive simulation panel
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Agent Simulation & State Controller",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      // Active Agent details
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
                                "Simulating Agent: ${activeAgent['Name']}",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Uri: ${activeAgent['Uri']}",
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const Divider(color: Color(0xFF444444), height: 24),
                              
                              // Change State Control
                              const Text("State:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ['UNKNOWN', 'REQUEST_WAIT', 'CONTROL_WAIT', 'RUNNING', 'PAUSED', 'COMPLETE_WAIT', 'COMPLETE'].map((stateVal) {
                                  final isCurrent = activeAgent['State'] == stateVal;
                                  return ChoiceChip(
                                    label: Text(stateVal, style: const TextStyle(fontSize: 10)),
                                    selected: isCurrent,
                                    selectedColor: Style.btnHighlightColor,
                                    labelStyle: TextStyle(
                                      color: isCurrent ? Colors.black : Colors.white,
                                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    onSelected: (selected) {
                                      if (selected) {
                                        _updateSelectedField('State', stateVal);
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),

                              // Change Completion Code Control
                              const Text("Completion Code / Result:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                children: ['UNKNOWN', 'SUCCESS', 'FAIL'].map((codeVal) {
                                  final isCurrent = activeAgent['CompletionCode'] == codeVal;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      label: Text(codeVal, style: const TextStyle(fontSize: 10)),
                                      selected: isCurrent,
                                      selectedColor: Style.btnHighlightColor,
                                      labelStyle: TextStyle(
                                        color: isCurrent ? Colors.black : Colors.white,
                                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                      ),
                                      onSelected: (selected) {
                                        if (selected) {
                                          _updateSelectedField('CompletionCode', codeVal);
                                        }
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),

                              // Change RequiredAppAccessRight Control
                              const Text("Required App Access Right:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ['UNKNOWN', 'NOT_ALLOWED', 'OPERATOR', 'MAINTAINER', 'ADMINISTRATOR'].map((right) {
                                  final isCurrent = activeAgent['RequiredAppAccessRight'] == right;
                                  return ChoiceChip(
                                    label: Text(right, style: const TextStyle(fontSize: 10)),
                                    selected: isCurrent,
                                    selectedColor: Style.btnHighlightColor,
                                    labelStyle: TextStyle(
                                      color: isCurrent ? Colors.black : Colors.white,
                                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    onSelected: (selected) {
                                      if (selected) {
                                        _updateSelectedField('RequiredAppAccessRight', right);
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),

                              // RunTime simulator buttons
                              Row(
                                children: [
                                  const Text("Run Time: ", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  Text(
                                    "${activeAgent['RunTime']}s",
                                    style: const TextStyle(color: Colors.yellow, fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      final double current = (activeAgent['RunTime'] as num).toDouble();
                                      _updateSelectedField('RunTime', current + 1.0);
                                    },
                                    child: const Text("+1s"),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      final double current = (activeAgent['RunTime'] as num).toDouble();
                                      _updateSelectedField('RunTime', (current - 1.0).clamp(0.0, 10000.0));
                                    },
                                    child: const Text("-1s"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Text input fields
                              const Text("Edit Configuration JSON:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _configController,
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFF1E1E1E),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter config json string',
                                ),
                                onChanged: (text) {
                                  _updateSelectedField('Configuration', text);
                                },
                              ),
                              const SizedBox(height: 16),

                              const Text("Edit Feedback Data:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _feedbackController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFF1E1E1E),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter feedback details',
                                ),
                                onChanged: (text) {
                                  _updateSelectedField('FeedbackData', text);
                                },
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
                    markdown: _popupMarkdown,
                    onClose: () => setState(() => _popupVisible = false),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
