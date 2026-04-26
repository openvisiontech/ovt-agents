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
