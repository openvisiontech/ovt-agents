import 'package:flutter/material.dart';
import '../style.dart';

class CompDataTopicList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Set<String> selectedUris;
  final void Function(String uri) onCheck;
  final VoidCallback onClosePressed;
  final void Function(Map<String, dynamic> topic) onInfoPressed;

  const CompDataTopicList({
    super.key,
    required this.items,
    required this.selectedUris,
    required this.onCheck,
    required this.onClosePressed,
    required this.onInfoPressed,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'INACTIVE':
        return Colors.grey;
      case 'NO_RIGHT':
        return Colors.red;
      default:
        return Colors.blueGrey;
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
          // Header
          Container(
            height: 50,
            decoration: const BoxDecoration(
              color: Style.headerBackgroundColor,
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Data Topics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onClosePressed,
                ),
              ],
            ),
          ),
          // Scrollable List
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      "No Data Topics Available",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final compRec =
                          item['CompRec'] as Map<String, dynamic>? ?? {};
                      final compName =
                          compRec['Name']?.toString() ?? 'Unknown Component';
                      final compDescriptor =
                          compRec['Descriptor']?.toString() ?? '';
                      final address =
                          compRec['Address'] as Map<String, dynamic>? ?? {};
                      final addressStr =
                          "${address['SubsystemId'] ?? 0}.${address['NodeId'] ?? 0}.${address['CompId'] ?? 0}";
                      final streamUrl = item['Forwarded'] == "true"
                          ? item['ForwardedUrl']?.toString() ?? ''
                          : item['Url']?.toString() ?? '';
                      final status = item['Status']?.toString() ?? 'UNKNOWN';
                      final topicRecs =
                          item['DataTopicRecList'] as List<dynamic>? ?? [];

                      final isStreamChecked = selectedUris.contains(streamUrl);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Checkbox(
                              activeColor: Style.btnHighlightColor,
                              value: isStreamChecked,
                              onChanged: (bool? checked) {
                                if (streamUrl.isNotEmpty) {
                                  onCheck(streamUrl);
                                }
                              },
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$compName ($addressStr)",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${compDescriptor.isNotEmpty ? compDescriptor : 'Not Specified'}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        streamUrl,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      status,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: _getStatusColor(status),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: _getStatusColor(status),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              const Divider(height: 1),
                              if (topicRecs.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    "No individual topic records",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              else
                                ...topicRecs.map<Widget>((topicDynamic) {
                                  final topic =
                                      topicDynamic as Map<String, dynamic>? ??
                                      {};
                                  final topicUri =
                                      topic['Uri']?.toString() ?? '';
                                  final accessRight =
                                      topic['RequiredDataAccessRight']
                                          ?.toString() ??
                                      'UNKNOWN';
                                  final isTopicChecked = selectedUris.contains(
                                    topicUri,
                                  );

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      leading: Checkbox(
                                        activeColor: Style.btnHighlightColor,
                                        value: isTopicChecked,
                                        onChanged: (bool? checked) {
                                          if (topicUri.isNotEmpty) {
                                            onCheck(topicUri);
                                          }
                                        },
                                      ),
                                      title: Text(
                                        topicUri,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Access: $accessRight",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.info_outline,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                        onPressed: () => onInfoPressed(topic),
                                      ),
                                    ),
                                  );
                                }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
