import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'dart:io';

class ARMeasureScreen extends StatefulWidget {
  @override
  _ARMeasureScreen createState() => _ARMeasureScreen();
}

class _ARMeasureScreen extends State<ARMeasureScreen> {
  ARKitController arkitController;
  vector.Vector3 lastPosition;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Platform.isIOS ? Scaffold(
      body: Container(
        child: ARKitSceneView(
          enableTapRecognizer: true,
          onARKitViewCreated: onARKitViewCreated,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          arkitController
            ..remove('point')
            ..remove('text')
            ..remove('line');
          lastPosition = null;
        },
      ),
    ) :
    const Scaffold(
      body: const Center(
        child: Text('Androidには対応しておりません\n現在開発中のためしばらくお待ち下さい。'),
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onARTap = (ar) {
      final point = ar.firstWhere(
            (o) => o.type == ARKitHitTestResultType.featurePoint,
        orElse: () => null,
      );
      if (point != null) {
        _onARTapHandler(point);
      }
    };
  }

  void _onARTapHandler(ARKitTestResult point) {
    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );
    final material = ARKitMaterial(
        lightingModelName: ARKitLightingModel.constant,
        diffuse: ARKitMaterialProperty(color: Colors.blue));
    final sphere = ARKitSphere(
      radius: 0.006,
      materials: [material],
    );
    final node = ARKitNode(
      name: 'point',
      geometry: sphere,
      position: position,
    );
    arkitController.add(node);

    if (lastPosition != null) {
      final line = ARKitLine(
        fromVector: lastPosition,
        toVector: position,
      );
      final lineNode = ARKitNode(
          name: 'line',
          geometry: line
      );
      arkitController.add(lineNode);

      final distance = _calculateDistanceBetweenPoints(position, lastPosition);
      final point = _getMiddleVector(position, lastPosition);
      _drawText(distance, point);
    }
    lastPosition = position;
  }

  String _calculateDistanceBetweenPoints(vector.Vector3 A, vector.Vector3 B) {
    final length = A.distanceTo(B);
    return '${(length * 100).toStringAsFixed(2)} cm';
  }

  vector.Vector3 _getMiddleVector(vector.Vector3 A, vector.Vector3 B) {
    return vector.Vector3((A.x + B.x) / 2, (A.y + B.y) / 2, (A.z + B.z) / 2);
  }

  void _drawText(String text, vector.Vector3 point) {
    final textGeometry = ARKitText(
      text: text,
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.red),
        )
      ],
    );
    const scale = 0.001;
    final vectorScale = vector.Vector3(scale, scale, scale);
    final node = ARKitNode(
      name: 'text',
      geometry: textGeometry,
      position: point,
      scale: vectorScale,
    );
    arkitController.add(node);
  }
}