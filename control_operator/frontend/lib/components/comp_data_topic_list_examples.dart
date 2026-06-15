import 'package:flutter/material.dart';
import '../style.dart';
import 'comp_data_topic_list.dart';
import 'comp_popup_viewer.dart';

class CompDataTopicListExamples extends StatefulWidget {
  const CompDataTopicListExamples({super.key});

  @override
  State<CompDataTopicListExamples> createState() => _CompDataTopicListExamplesState();
}

class _CompDataTopicListExamplesState extends State<CompDataTopicListExamples> {
  late List<Map<String, dynamic>> _topics;
  final Set<String> _selectedUris = {};
  
  // For showing topic details popup
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
      _selectedUris.clear();
      _selectedUris.add("data://guidance.controller/core_clients.DataStore?location=telemetry");
      _topics = [
        {
          "CompRec": {
            "Address": {
              "SubsystemId": 1,
              "NodeId": 10,
              "CompId": 100
            },
            "CompType": "MISSION_CRITICAL",
            "Name": "Guidance Controller",
            "Descriptor": "Main controller for path planning and navigation"
          },
          "Url": "data://guidance.controller/core_clients.DataStore?location=telemetry",
          "Forwarded": true,
          "ForwardedUrl": "data://relay.node/core_clients.DataStore?location=telemetry_forward",
          "Status": "ACTIVE",
          "DataTopicRecList": [
            {
              "Uri": "data://guidance.controller/telemetry/pose",
              "Comp": {
                "SubsystemId": 1,
                "NodeId": 10,
                "CompId": 100
              },
              "ChannelId": 1,
              "SchemaVersion": 1,
              "Schema": "Pose",
              "RequiredDataAccessRight": "UNCLASSIFIED",
              "ContextFile": "pose_spec.md",
              "Context": "### Pose Telemetry\nProvides high-frequency vehicle position, attitude, and spatial velocity vectors.",
              "HistoryDepth": 100,
              "DisplayDuration": 10
            },
            {
              "Uri": "data://guidance.controller/telemetry/speed",
              "Comp": {
                "SubsystemId": 1,
                "NodeId": 10,
                "CompId": 100
              },
              "ChannelId": 2,
              "SchemaVersion": 1,
              "Schema": "Speed",
              "RequiredDataAccessRight": "CONTROLLED",
              "ContextFile": "speed_spec.md",
              "Context": "### Speed Telemetry\nProvides linear velocity (m/s) and rotational velocity (rad/s) measurements.",
              "HistoryDepth": 50,
              "DisplayDuration": 5
            }
          ]
        },
        {
          "CompRec": {
            "Address": {
              "SubsystemId": 1,
              "NodeId": 10,
              "CompId": 102
            },
            "CompType": "REGULAR",
            "Name": "Camera Payload",
            "Descriptor": "High-resolution electro-optical payload camera"
          },
          "Url": "data://camera.payload/core_clients.DataStore?location=stream",
          "Forwarded": false,
          "ForwardedUrl": "",
          "Status": "NO_RIGHT",
          "DataTopicRecList": [
            {
              "Uri": "data://camera.payload/stream/video",
              "Comp": {
                "SubsystemId": 1,
                "NodeId": 10,
                "CompId": 102
              },
              "ChannelId": 3,
              "SchemaVersion": 2,
              "Schema": "VideoStream",
              "RequiredDataAccessRight": "CLASSIFIED",
              "ContextFile": "video_spec.md",
              "Context": "### Video Stream\nRaw digital video feed of the main payload. Stream is encrypted and requires authorization.",
              "HistoryDepth": 10,
              "DisplayDuration": 0
            }
          ]
        },
        {
          "CompRec": {
            "Address": {
              "SubsystemId": 1,
              "NodeId": 10,
              "CompId": 105
            },
            "CompType": "REGULAR",
            "Name": "Battery Monitor",
            "Descriptor": "Battery state-of-charge, cell voltage, and diagnostics monitor"
          },
          "Url": "data://battery.monitor/core_clients.DataStore?location=diagnostics",
          "Forwarded": false,
          "ForwardedUrl": "",
          "Status": "INACTIVE",
          "DataTopicRecList": [
            {
              "Uri": "data://battery.monitor/diagnostics/soc",
              "Comp": {
                "SubsystemId": 1,
                "NodeId": 10,
                "CompId": 105
              },
              "ChannelId": 4,
              "SchemaVersion": 1,
              "Schema": "BatteryState",
              "RequiredDataAccessRight": "UNCLASSIFIED",
              "ContextFile": "battery_spec.md",
              "Context": "### Battery SoC Telemetry\nTracks remaining state of charge (%), battery health index, voltage, and temperature.",
              "HistoryDepth": 120,
              "DisplayDuration": 60
            }
          ]
        }
      ];
    });
  }

  void _toggleTopicSelected(String uri) {
    setState(() {
      if (_selectedUris.contains(uri)) {
        _selectedUris.remove(uri);
      } else {
        _selectedUris.add(uri);
      }
    });
  }

  void _simulateChangeStatus(int index, String newStatus) {
    setState(() {
      if (index >= 0 && index < _topics.length) {
        _topics[index] = {
          ..._topics[index],
          'Status': newStatus,
        };
      }
    });
  }

  void _simulateToggleForwarded(int index) {
    setState(() {
      if (index >= 0 && index < _topics.length) {
        final current = _topics[index]['Forwarded'] as bool? ?? false;
        _topics[index] = {
          ..._topics[index],
          'Forwarded': !current,
          'ForwardedUrl': !current ? "data://relay.node/core_clients.DataStore?location=forwarded_$index" : "",
        };
      }
    });
  }

  void _showTopicDetails(Map<String, dynamic> topic) {
    final uri = topic['Uri']?.toString() ?? 'Topic';
    final contextStr = topic['Context']?.toString() ?? 'No context available.';
    final schema = topic['Schema']?.toString() ?? 'UnknownSchema';
    
    // Construct rich markdown context details
    final markdown = """# Topic Details: `$uri`

### Metadata Information
- **Schema Name**: `$schema`
- **Schema Version**: `${topic['SchemaVersion'] ?? 0}`
- **Channel ID**: `${topic['ChannelId'] ?? 0}`
- **Required Data Access Right**: `${topic['RequiredDataAccessRight'] ?? 'UNKNOWN'}`
- **History Depth**: `${topic['HistoryDepth'] ?? 0}`
- **Display Duration**: `${topic['DisplayDuration'] ?? 0} seconds`
- **Context File**: `${topic['ContextFile'] ?? 'N/A'}`

---

## Technical Context Description
$contextStr
""";

    setState(() {
      _popupTitle = "$uri Details";
      _popupJson = topic;
      _popupMarkdown = markdown;
      _popupVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark modern theme
      appBar: AppBar(
        title: const Text('CompDataTopicList Examples', style: TextStyle(color: Colors.white)),
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
              // Left Panel: The CompDataTopicList Component
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Interactive List Widget",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: CompDataTopicList(
                          items: _topics,
                          selectedUris: _selectedUris,
                          onCheck: _toggleTopicSelected,
                          onClosePressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Close button pressed")),
                            );
                          },
                          onInfoPressed: _showTopicDetails,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right Panel: Monitor & Simulator Controls
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selected Topics Monitor
                      const Text(
                        "Selected URIs Monitor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 150,
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF444444)),
                        ),
                        child: _selectedUris.isEmpty
                            ? const Center(
                                child: Text(
                                  "No URIs currently selected",
                                  style: TextStyle(color: Colors.white54, fontSize: 13),
                                ),
                              )
                            : ListView(
                                children: _selectedUris.map((uri) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle_outline, color: Style.btnHighlightColor, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            uri,
                                            style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace'),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Simulation Control Panel
                      const Text(
                        "Data Stream Status Simulator",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _topics.length,
                          itemBuilder: (context, index) {
                            final topic = _topics[index];
                            final compRec = topic['CompRec'] as Map<String, dynamic>? ?? {};
                            final compName = compRec['Name']?.toString() ?? 'Unknown';
                            final currentStatus = topic['Status']?.toString() ?? 'UNKNOWN';
                            final isForwarded = topic['Forwarded'] as bool? ?? false;

                            return Card(
                              color: const Color(0xFF2D2D2D),
                              margin: const EdgeInsets.symmetric(vertical: 6.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Color(0xFF444444)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      compName,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text("Status: ", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                        ...['ACTIVE', 'INACTIVE', 'NO_RIGHT', 'UNKNOWN'].map((status) {
                                          final isCurrent = currentStatus == status;
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 6.0),
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
                                                  _simulateChangeStatus(index, status);
                                                }
                                              },
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Text("Forwarded Stream: ", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                        Switch(
                                          value: isForwarded,
                                          activeThumbColor: Style.btnHighlightColor,
                                          onChanged: (val) {
                                            _simulateToggleForwarded(index);
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            isForwarded ? "Forwarded" : "Direct Link",
                                            style: TextStyle(
                                              color: isForwarded ? Colors.green : Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Collapsible Popup overlay
          if (_popupVisible)
            Container(
              color: Colors.black54, // Dim background
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
