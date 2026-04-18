import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamDataModel extends Notifier<StreamDataModel> {
  @override
  StreamDataModel build() => this;
  @override
  bool updateShouldNotify(StreamDataModel previous, StreamDataModel next) =>
      true;

  List<dynamic> jsonTopics = [];

  void addTopic(dynamic topic) {
    jsonTopics.add(topic);
    state = this;
  }

  void removeExpiredTopics() {
    // Logic to be implemented or driven by isolates
    state = this;
  }
}
