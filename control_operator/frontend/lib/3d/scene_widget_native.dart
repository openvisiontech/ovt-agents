/**********************************************************************************
 * Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
 * All rights reserved. This material contains unpublished,
 * copyrighted work, which includes confidential and proprietary
 * information of Open Vision Technology, LLC..

 * Open Vision Technology, LLC. and its licensors retain all intellectual property
 * and proprietary rights in and to this software, related documentation
 * and any modifications thereto. Any use, reproduction, disclosure or
 * distribution of this software and related documentation without an express
 * license agreement from Open Vision Technology, LLC. is strictly prohibited.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **********************************************************************************
 */

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
