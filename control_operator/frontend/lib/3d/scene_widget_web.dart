import 'dart:async';
import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

class SceneWidgetImpl extends StatefulWidget {
  const SceneWidgetImpl({super.key});

  @override
  State<SceneWidgetImpl> createState() => _SceneWidgetImplState();
}

class _SceneWidgetImplState extends State<SceneWidgetImpl> {
  three.ThreeJS? threeJs;

  @override
  void dispose() {
    threeJs?.dispose();
    super.dispose();
  }

  Future<void> setup() async {
    if (threeJs == null) return;
    threeJs!.scene = three.Scene();

    threeJs!.camera = three.PerspectiveCamera(
      75,
      threeJs!.width / threeJs!.height,
      0.1,
      1000,
    );
    threeJs!.camera.position.z = 5;

    final geometry = three.BufferGeometry();
    final vertices = [
      0.0, 1.0, 0.0, // top
      -1.0, -1.0, 0.0, // bottom left
      1.0, -1.0, 0.0, // bottom right
    ];

    final positionAttribute = three.Float32BufferAttribute.fromList(
      vertices,
      3,
    );
    geometry.setAttribute(three.Attribute.position, positionAttribute);

    final material = three.MeshBasicMaterial.fromMap({
      'color': 0xff0000,
      'side': three.DoubleSide,
    });
    final mesh = three.Mesh(geometry, material);
    threeJs!.scene.add(mesh);

    threeJs!.addAnimationEvent((dt) {
      mesh.rotation.x += 0.01;
      mesh.rotation.y += 0.01;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        threeJs ??= three.ThreeJS(
          onSetupComplete: () {
            setState(() {});
          },
          setup: setup,
        );

        // Update size if renderer is available
        if (threeJs!.renderer != null) {
          threeJs!.renderer!.setSize(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          if (threeJs!.camera is three.PerspectiveCamera) {
            final camera = threeJs!.camera as three.PerspectiveCamera;
            camera.aspect = constraints.maxWidth / constraints.maxHeight;
            camera.updateProjectionMatrix();
          }
        }

        return threeJs!.build();
      },
    );
  }
}
