import 'package:flutter/material.dart';
import 'selectable_list.dart';

class SelectableListExamples extends StatefulWidget {
  const SelectableListExamples({super.key});

  @override
  State<SelectableListExamples> createState() => _SelectableListExamplesState();
}

class _SelectableListExamplesState extends State<SelectableListExamples> {
  int _selectedIndex1 = 0;
  int _selectedIndex2 = 0;
  int _selectedIndex3 = 0;
  int _selectedIndex4 = 0;

  final String _dummyImageBase64 = "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SelectableList Examples')),
      body: Row(
        children: [
          // Example 1: Using statusColors
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableList(
                title: 'Status Colors Example',
                items: const ['System Online', 'System Warning', 'System Error', 'System Offline'],
                selectedIndex: _selectedIndex1,
                statusColors: const [
                  Colors.green,
                  Colors.yellow,
                  Colors.red,
                  Colors.grey,
                ],
                onUpPressed: () {
                  if (_selectedIndex1 > 0) {
                    setState(() => _selectedIndex1--);
                  }
                },
                onDownPressed: () {
                  if (_selectedIndex1 < 3) {
                    setState(() => _selectedIndex1++);
                  }
                },
                onCheckPressed: () {
                  debugPrint('Checked Status Colors: $_selectedIndex1');
                },
                onClosePressed: () {
                  debugPrint('Closed Status Colors');
                },
                onItemTapped: (index) {
                  setState(() => _selectedIndex1 = index);
                },
              ),
            ),
          ),

          // Example 2: Using trailingWidgets
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableList(
                title: 'Trailing Widgets Example',
                items: const ['Network Settings', 'User Profile', 'System Info'],
                selectedIndex: _selectedIndex2,
                trailingWidgets: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.blue),
                    onPressed: () {
                      debugPrint('Network Settings icon clicked');
                      // Add your logic here
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      debugPrint('User Profile edit clicked');
                      // Add your logic here
                    },
                  ),
                  // Trailing widget can be any widget, not just a button
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.info_outline, color: Colors.grey),
                  ),
                ],
                onUpPressed: () {
                  if (_selectedIndex2 > 0) {
                    setState(() => _selectedIndex2--);
                  }
                },
                onDownPressed: () {
                  if (_selectedIndex2 < 2) {
                    setState(() => _selectedIndex2++);
                  }
                },
                onCheckPressed: () {
                  debugPrint('Checked Trailing Widgets: $_selectedIndex2');
                },
                onClosePressed: () {
                  debugPrint('Closed Trailing Widgets');
                },
                onItemTapped: (index) {
                  setState(() => _selectedIndex2 = index);
                },
              ),
            ),
          ),

          // Example 3: Using an Image as trailing widget
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableList(
                title: 'Image Trailing Example',
                items: const ['Item with Image', 'Another Item'],
                selectedIndex: _selectedIndex3,
                trailingWidgets: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      'https://picsum.photos/36/36',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 36,
                        height: 36,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 20),
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 20, color: Colors.blue),
                  ),
                ],
                onUpPressed: () {
                  if (_selectedIndex3 > 0) {
                    setState(() => _selectedIndex3--);
                  }
                },
                onDownPressed: () {
                  if (_selectedIndex3 < 1) {
                    setState(() => _selectedIndex3++);
                  }
                },
                onCheckPressed: () {
                  debugPrint('Checked Image Example: $_selectedIndex3');
                },
                onClosePressed: () {
                  debugPrint('Closed Image Example');
                },
                onItemTapped: (index) {
                  setState(() => _selectedIndex3 = index);
                },
              ),
            ),
          ),

          // Example 4: Using Profile Images
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableList(
                title: 'Profile Images Example',
                items: const ['User Alpha', 'User Beta'],
                selectedIndex: _selectedIndex4,
                profileImages: [
                  _dummyImageBase64,
                  _dummyImageBase64,
                ],
                onUpPressed: () {
                  if (_selectedIndex4 > 0) {
                    setState(() => _selectedIndex4--);
                  }
                },
                onDownPressed: () {
                  if (_selectedIndex4 < 1) {
                    setState(() => _selectedIndex4++);
                  }
                },
                onCheckPressed: () {
                  debugPrint('Checked Profile Images: $_selectedIndex4');
                },
                onClosePressed: () {
                  debugPrint('Closed Profile Images');
                },
                onItemTapped: (index) {
                  setState(() => _selectedIndex4 = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
