import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'triangle_geometry.dart';

class SceneWidgetImpl extends StatefulWidget {
  const SceneWidgetImpl({super.key});

  @override
  State<SceneWidgetImpl> createState() => _SceneWidgetImplState();
}

class _SceneWidgetImplState extends State<SceneWidgetImpl>
    with SingleTickerProviderStateMixin {
  Scene? _scene;
  Node? _node;
  PerspectiveCamera? _camera;
  Ticker? _ticker;
  double _rotation = 0.0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initScene();
  }

  Future<void> _initScene() async {
    try {
      await Scene.initializeStaticResources();

      _scene = Scene();

      // Create Camera
      _camera = PerspectiveCamera(
        position: vm.Vector3(0, 0, 5),
        target: vm.Vector3(0, 0, 0),
      );

      // Create Triangle
      final geometry = TriangleGeometry();
      final material = UnlitMaterial();

      final mesh = Mesh(geometry, material);
      _node = Node(mesh: mesh);
      _scene!.add(_node!);

      // Start Animation
      _ticker = createTicker((elapsed) {
        setState(() {
          _rotation += 0.02;
          if (_node != null) {
            _node!.localTransform =
                vm.Matrix4.rotationY(_rotation) *
                vm.Matrix4.rotationX(_rotation * 0.5);
          }
        });
      });
      _ticker!.start();

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(
          "Error: $_error",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return CustomPaint(
      painter: ScenePainter(_scene, _camera),
      child: Container(),
    );
  }
}

class ScenePainter extends CustomPainter {
  ScenePainter(this.scene, this.camera);
  final Scene? scene;
  final Camera? camera;

  @override
  void paint(Canvas canvas, Size size) {
    if (scene == null || camera == null) return;
    scene!.render(camera!, canvas, viewport: Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
