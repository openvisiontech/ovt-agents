import 'dart:typed_data';
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:flutter_scene/scene.dart';

class TriangleGeometry extends UnskinnedGeometry {
  TriangleGeometry() {
    // Layout: Position (3), Normal (3), UV (2), Color (4)
    final vertices = Float32List.fromList(<double>[
      // Top
      0.0, 1.0, 0.0, // Position
      0.0, 0.0, 1.0, // Normal
      0.5, 1.0, // UV
      1.0, 0.0, 0.0, 1.0, // Color (Red)
      // Bottom Left
      -1.0, -1.0, 0.0, // Position
      0.0, 0.0, 1.0, // Normal
      0.0, 0.0, // UV
      0.0, 1.0, 0.0, 1.0, // Color (Green)
      // Bottom Right
      1.0, -1.0, 0.0, // Position
      0.0, 0.0, 1.0, // Normal
      1.0, 0.0, // UV
      0.0, 0.0, 1.0, 1.0, // Color (Blue)
    ]);

    final indices = Uint16List.fromList(<int>[0, 1, 2]);

    uploadVertexData(
      ByteData.sublistView(vertices),
      3, // vertex count
      ByteData.sublistView(indices),
      indexType: gpu.IndexType.int16,
    );
  }
}
