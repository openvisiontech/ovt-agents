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
