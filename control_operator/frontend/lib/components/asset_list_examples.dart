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
import 'asset_list.dart';
import 'comp_popup_viewer.dart';

class AssetListExamples extends StatefulWidget {
  const AssetListExamples({super.key});

  @override
  State<AssetListExamples> createState() => _AssetListExamplesState();
}

class _AssetListExamplesState extends State<AssetListExamples> {
  late List<Map<String, dynamic>> _assets;
  int _selectedIndex = 0;

  // Popup state
  bool _popupVisible = false;
  String _popupTitle = "";
  dynamic _popupJson;
  String? _popupMarkdown;

  @override
  void initState() {
    super.initState();
    _resetMockData();
  }

  void _resetMockData() {
    setState(() {
      _selectedIndex = 0;
      _assets = [
        {
          "Address": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 100,
          },
          "SubsystemType": "UNMANNED",
          "Name": "Scout UGV 01",
          "ControlStatus": "UNDER_CONTROLLED",
          "Client": "OperatorConsole_1",
          "Pose": {
            "Frame": "map",
            "Latitude": 42.35843,
            "Longitude": -71.05977,
            "XPosition": 12.50,
            "YPosition": -45.20,
            "ZPositionType": "ALTITUDE_AGL",
            "ZPosition": 0.00,
            "Roll": 0.2,
            "Pitch": -1.5,
            "Heading": 180.0,
          },
          "Context": """# Scout UGV 01 Context
This is an unmanned ground vehicle designed for tactical reconnaissance and payload transport.

### Capabilities:
- **Max Speed**: 15 km/h
- **Range**: 25 km
- **Payload Capacity**: 50 kg
- **Sensors**: LiDAR, Depth Camera, thermal imaging.""",
          "ProfileImage": "",
        },
        {
          "Address": {
            "SubsystemId": 2,
            "NodeId": 11,
            "CompId": 101,
          },
          "SubsystemType": "AI_AGENT",
          "Name": "SkyHawk UAV 02",
          "ControlStatus": "NOT_CONTROLLED",
          "Client": "",
          "Pose": {
            "Frame": "map",
            "Latitude": 42.36012,
            "Longitude": -71.06211,
            "XPosition": 128.40,
            "YPosition": 94.60,
            "ZPositionType": "ALTITUDE_AGL",
            "ZPosition": 45.00,
            "Roll": 1.5,
            "Pitch": 5.2,
            "Heading": 45.0,
          },
          "Context": """# SkyHawk UAV 02 Context
High-altitude AI-enabled surveillance drone operating autonomously or under remote operator guidance.

### Capabilities:
- **Max Speed**: 75 km/h
- **Ceiling**: 150m AGL
- **Flight Time**: 45 mins
- **Sensors**: EO/IR high-zoom optical lens.""",
          "ProfileImage": "",
        },
        {
          "Address": {
            "SubsystemId": 3,
            "NodeId": 12,
            "CompId": 105,
          },
          "SubsystemType": "CONTROLLER",
          "Name": "Base Station Link",
          "ControlStatus": "NOT_AVAILABLE",
          "Client": "",
          "Pose": null,
          "Context": """# Base Station Link Context
Static controller relay acting as the main interface between the regional command nodes and local robotic sub-grids.""",
          "ProfileImage": "",
        },
        {
          "Address": {
            "SubsystemId": 4,
            "NodeId": 13,
            "CompId": 110,
          },
          "SubsystemType": "META_HUMAN",
          "Name": "Rescue Unit Alpha",
          "ControlStatus": "UNKNOWN",
          "Client": "",
          "Pose": {
            "Frame": "map",
            "Latitude": 42.35712,
            "Longitude": -71.06010,
            "XPosition": -5.30,
            "YPosition": -12.40,
            "ZPositionType": "ALTITUDE_MSL",
            "ZPosition": 14.20,
            "Roll": 0.0,
            "Pitch": 0.0,
            "Heading": 270.0,
          },
          "Context": """# Rescue Unit Alpha Context
First responder humanoid agent or localized team equipped with field telemetry relays.""",
          "ProfileImage": "",
        },
      ];
    });
  }

  void _onUpPressed() {
    setState(() {
      if (_selectedIndex > 0) {
        _selectedIndex--;
      }
    });
  }

  void _onDownPressed() {
    setState(() {
      if (_selectedIndex < _assets.length - 1) {
        _selectedIndex++;
      }
    });
  }

  void _onCheckPressed() {
    final asset = _assets[_selectedIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Selected/Activated Asset: ${asset['Name']} (ID: ${asset['Address']['SubsystemId']})"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onInfoPressed(Map<String, dynamic> asset) {
    setState(() {
      _popupTitle = "${asset['Name']} Details";
      _popupJson = asset;
      _popupMarkdown = asset['Context']?.toString();
      _popupVisible = true;
    });
  }

  void _simulateChangeStatus(String newStatus) {
    setState(() {
      _assets[_selectedIndex] = {
        ..._assets[_selectedIndex],
        "ControlStatus": newStatus,
      };
    });
  }

  void _simulateMove(double dLat, double dLon, double dX, double dY, double dZ) {
    setState(() {
      final asset = _assets[_selectedIndex];
      final pose = asset['Pose'] as Map<String, dynamic>?;
      if (pose != null) {
        final double currentLat = (pose['Latitude'] as num).toDouble();
        final double currentLon = (pose['Longitude'] as num).toDouble();
        final double currentX = (pose['XPosition'] as num).toDouble();
        final double currentY = (pose['YPosition'] as num).toDouble();
        final double currentZ = (pose['ZPosition'] as num).toDouble();

        _assets[_selectedIndex] = {
          ...asset,
          "Pose": {
            ...pose,
            "Latitude": currentLat + dLat,
            "Longitude": currentLon + dLon,
            "XPosition": currentX + dX,
            "YPosition": currentY + dY,
            "ZPosition": currentZ + dZ,
          }
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeAsset = _assets[_selectedIndex];
    final activePose = activeAsset['Pose'] as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('AssetList Widget Examples', style: TextStyle(color: Colors.white)),
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
              // Left Panel: AssetList component wrapped in a fixed-width container to mimic sidebar
              SizedBox(
                width: 320,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AssetList(
                    assets: _assets,
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
                      });
                    },
                    onInfoPressed: _onInfoPressed,
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
                        "Asset Simulation & Controller",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      // Active Asset Profile Details
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
                                "Simulating: ${activeAsset['Name']}",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Type: ${activeAsset['SubsystemType']}  |  Client: ${activeAsset['Client'] ?? 'None'}",
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const Divider(color: Color(0xFF444444), height: 24),
                              
                              // Change Status Control
                              const Text("Change Control Status:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 8),
                              Row(
                                children: ['UNDER_CONTROLLED', 'NOT_CONTROLLED', 'NOT_AVAILABLE', 'UNKNOWN'].map((status) {
                                  final isCurrent = activeAsset['ControlStatus'] == status;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      label: Text(status, style: const TextStyle(fontSize: 10)),
                                      selected: isCurrent,
                                      selectedColor: Style.btnHighlightColor,
                                      labelStyle: TextStyle(
                                        color: isCurrent ? Colors.black : Colors.white,
                                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                      ),
                                      onSelected: (selected) {
                                        if (selected) {
                                          _simulateChangeStatus(status);
                                        }
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Pose Position Controls
                      if (activePose != null)
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
                                const Text(
                                  "Spatial Position Simulators",
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                
                                // Coordinates change buttons
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: Text("Latitude / Longitude:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0.0001, 0, 0, 0, 0),
                                      child: const Text("+ Lat"),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(-0.0001, 0, 0, 0, 0),
                                      child: const Text("- Lat"),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0, 0.0001, 0, 0, 0),
                                      child: const Text("+ Lon"),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0, -0.0001, 0, 0, 0),
                                      child: const Text("- Lon"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: Text("Local X / Y Position:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0, 0, 1.0, 0, 0),
                                      child: const Text("+ X (1m)"),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0, 0, -1.0, 0, 0),
                                      child: const Text("- X (1m)"),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0, 0, 0, 1.0, 0),
                                      child: const Text("+ Y (1m)"),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0, 0, 0, -1.0, 0),
                                      child: const Text("- Y (1m)"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: Text("Altitude (Z):", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0, 0, 0, 0, 2.0),
                                      child: const Text("+ Z (2m)"),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _simulateMove(0, 0, 0, 0, -2.0),
                                      child: const Text("- Z (2m)"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const Card(
                          color: Color(0xFF2D2D2D),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "No Pose available for this static asset",
                                style: TextStyle(color: Colors.white54),
                              ),
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
