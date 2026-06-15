import 'package:flutter/material.dart';
import 'components/asset_list_examples.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asset List Examples',
      home: AssetListExamples(),
    ),
  );
}
