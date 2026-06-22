import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/components/asset_list.dart';
import 'package:frontend/components/agent_list.dart';

void main() {
  const String sampleBase64 =
      "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAP//////////////////////////////////////////////////////////////////////////////////////wgALCAABAAEBAREA/8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPxA=";

  group('AssetList Profile Image Tests', () {
    testWidgets('should render AssetList with base64 image and handle updates', (WidgetTester tester) async {
      List<Map<String, dynamic>> assets = [
        {
          "Address": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 100,
          },
          "SubsystemType": "UNMANNED",
          "Name": "Scout UGV 01",
          "ControlStatus": "UNDER_CONTROLLED",
          "ProfileImage": sampleBase64,
        }
      ];

      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetList(
              assets: assets,
              selectedIndex: selectedIndex,
              onUpPressed: () {},
              onDownPressed: () {},
              onCheckPressed: () {},
              onClosePressed: () {},
              onItemTapped: (index) {},
              onInfoPressed: (asset) {},
            ),
          ),
        ),
      );

      // Verify asset list displays item
      expect(find.text("Scout UGV 01"), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      // Trigger didUpdateWidget by updating the status of the asset (keeping the same base64 image)
      assets = [
        {
          "Address": {
            "SubsystemId": 1,
            "NodeId": 10,
            "CompId": 100,
          },
          "SubsystemType": "UNMANNED",
          "Name": "Scout UGV 01",
          "ControlStatus": "NOT_CONTROLLED",
          "ProfileImage": sampleBase64,
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetList(
              assets: assets,
              selectedIndex: selectedIndex,
              onUpPressed: () {},
              onDownPressed: () {},
              onCheckPressed: () {},
              onClosePressed: () {},
              onItemTapped: (index) {},
              onInfoPressed: (asset) {},
            ),
          ),
        ),
      );

      expect(find.text("Scout UGV 01"), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('AgentList Profile Image Tests', () {
    testWidgets('should render AgentList with base64 image and handle updates', (WidgetTester tester) async {
      List<Map<String, dynamic>> agents = [
        {
          "Name": "SkyHawk UAV 02",
          "Uri": "agent://skyhawk02",
          "State": "RUNNING",
          "RequiredAppAccessRight": "OPERATOR",
          "ProfileImage": sampleBase64,
        }
      ];

      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AgentList(
              agents: agents,
              selectedIndex: selectedIndex,
              onUpPressed: () {},
              onDownPressed: () {},
              onCheckPressed: () {},
              onClosePressed: () {},
              onItemTapped: (index) {},
              onInfoPressed: (agent) {},
            ),
          ),
        ),
      );

      // Verify agent list displays item
      expect(find.text("SkyHawk UAV 02"), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      // Trigger didUpdateWidget by updating the state of the agent
      agents = [
        {
          "Name": "SkyHawk UAV 02",
          "Uri": "agent://skyhawk02",
          "State": "PAUSED",
          "RequiredAppAccessRight": "OPERATOR",
          "ProfileImage": sampleBase64,
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AgentList(
              agents: agents,
              selectedIndex: selectedIndex,
              onUpPressed: () {},
              onDownPressed: () {},
              onCheckPressed: () {},
              onClosePressed: () {},
              onItemTapped: (index) {},
              onInfoPressed: (agent) {},
            ),
          ),
        ),
      );

      expect(find.text("SkyHawk UAV 02"), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
