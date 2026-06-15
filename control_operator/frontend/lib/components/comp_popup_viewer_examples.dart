import 'package:flutter/material.dart';
import '../style.dart';
import 'comp_popup_viewer.dart';

class CompPopupViewerExamples extends StatefulWidget {
  const CompPopupViewerExamples({super.key});

  @override
  State<CompPopupViewerExamples> createState() => _CompPopupViewerExamplesState();
}

class _CompPopupViewerExamplesState extends State<CompPopupViewerExamples> {
  bool _popupVisible = false;
  String _popupTitle = "";
  dynamic _popupJson;
  String? _popupMarkdown;

  // Example 1: Agent Status JSON
  final Map<String, dynamic> _agentStatusJson = {
    "agentstatuslist": [
      {
        "AgentId": "agent-alpha-9",
        "Status": "ACTIVE",
        "Uptime": 86400,
        "ActiveTasks": [
          {"TaskId": "task_102", "Type": "teleop", "Progress": 0.85},
          {"TaskId": "task_105", "Type": "mapping", "Progress": 0.3}
        ],
        "Capabilities": ["navigation", "collision_avoidance", "video_stream"],
        "Metrics": {
          "cpu_usage": 24.5,
          "memory_mb": 512,
          "network_ping_ms": 12.0
        }
      },
      {
        "AgentId": "agent-beta-3",
        "Status": "STANDBY",
        "Uptime": 12400,
        "ActiveTasks": [],
        "Capabilities": ["teleop", "light_control"],
        "Metrics": {
          "cpu_usage": 2.1,
          "memory_mb": 128,
          "network_ping_ms": 18.5
        }
      }
    ]
  };

  // Example 2: Schema Markdown Documentation
  final String _schemaMarkdown = """# Teleoperation Schema Specification

This schema defines the status and command messages used by the **Guarded Teleoperation** module.

## Properties
- `linear_velocity` (double): Forward/backward speed in meters/second. Must be between `-1.0` and `1.0`.
- `angular_velocity` (double): Rotational speed in radians/second. Must be between `-1.5` and `1.5`.
- `safety_mode` (string): Current safety envelope configuration.
  - `guarded`: System will actively prevent collisions.
  - `direct`: Commands passed straight to controller (override).

## Usage Example
```json
{
  "linear_velocity": 0.25,
  "angular_velocity": 0.0,
  "safety_mode": "guarded"
}
```

---
> **Note:** Direct mode should only be used by trained operators during recovery procedures.
""";

  // Example 3: Combined Topic Details (JSON & Markdown)
  final Map<String, dynamic> _topicMetadataJson = {
    "topic": "/mobility/guarded_teleop/cmd_vel",
    "frequency_hz": 20,
    "security": {
      "encrypted": true,
      "protocol": "WebSockets/WSS"
    },
    "access_control": {
      "readers": ["ocu", "gui_operator"],
      "writers": ["teleop_node"]
    }
  };

  final String _topicDetailsMarkdown = """# Data Topic: `cmd_vel`

This data topic transmits high-frequency velocity commands from the Operator Control Unit (OCU) to the robot base.

### Performance Specifications
- **Frequency**: 20 Hz (target)
- **Max Latency**: 50 ms
- **Message Type**: `geometry_msgs/Twist`

### Security Policy
All communications must go through the encrypted transport layer (WSS) and are subjected to role-based access control.
""";

  void _showPopup({
    required String title,
    dynamic json,
    String? markdown,
  }) {
    setState(() {
      _popupTitle = title;
      _popupJson = json;
      _popupMarkdown = markdown;
      _popupVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Match dark background
      appBar: AppBar(
        title: const Text('Popup Viewer Examples', style: TextStyle(color: Colors.white)),
        backgroundColor: Style.headerBackgroundColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Main Examples Selection Page
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CompPopupViewer Demos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Demonstrates different modes of displaying structured status JSON data and Markdown documentation.",
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.2,
                    children: [
                      // Example 1: Interactive JSON Tree
                      _buildDemoCard(
                        title: "Interactive JSON Tree",
                        description: "Displays structured status responses in a collapsible tree or raw text. Features copy-to-clipboard functionality.",
                        icon: Icons.account_tree_outlined,
                        onTap: () => _showPopup(
                          title: "Agent Status JSON Data",
                          json: _agentStatusJson,
                        ),
                      ),
                      // Example 2: Markdown Spec Docs
                      _buildDemoCard(
                        title: "Markdown Spec Docs",
                        description: "Renders formatted Markdown documentation including headings, code blocks, lists, and quote blocks.",
                        icon: Icons.menu_book_outlined,
                        onTap: () => _showPopup(
                          title: "Teleop Schema Documentation",
                          markdown: _schemaMarkdown,
                        ),
                      ),
                      // Example 3: Combined JSON & Markdown
                      _buildDemoCard(
                        title: "Combined JSON + Markdown",
                        description: "Loads both metadata JSON and Markdown instructions simultaneously to display full context side by side.",
                        icon: Icons.dashboard_outlined,
                        onTap: () => _showPopup(
                          title: "Data Topic & Metadata Details",
                          json: _topicMetadataJson,
                          markdown: _topicDetailsMarkdown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

  Widget _buildDemoCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF2D2D2D),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF444444), width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Style.btnHighlightColor, size: 40),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  overflow: TextOverflow.fade,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Launch Demo",
                      style: TextStyle(
                        color: Style.btnHighlightColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: Style.btnHighlightColor, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
