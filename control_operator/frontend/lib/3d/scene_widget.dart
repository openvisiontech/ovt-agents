import 'package:flutter/material.dart';

import 'scene_widget_native.dart' if (dart.library.js) 'scene_widget_web.dart';

class SceneWidget extends StatelessWidget {
  const SceneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SceneWidgetImpl();
  }
}
