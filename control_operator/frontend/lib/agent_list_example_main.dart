import 'package:flutter/material.dart';
import 'components/agent_list_examples.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agent List Examples',
      home: AgentListExamples(),
    ),
  );
}
