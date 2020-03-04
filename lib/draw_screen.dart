import 'dart:io';
import 'dart:ui';

import 'gesture_lib/interaction_history.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'gesture_lib/interaction_consumer.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {

  InteractionConsumer _interactionConsumer;
  ImmediateMultiDragGestureRecognizer _recognizer;

  _DrawState() {
    _recognizer = new ImmediateMultiDragGestureRecognizer();

    _interactionConsumer = new InteractionConsumer(_recognizer);

  }

  @override
  Widget build(BuildContext context) {
//    print("building widget");


    _interactionConsumer.onUpdate = () {
      setState(() {
//        print("setState()");

      });
    };

    CustomPaint painter = new CustomPaint(
      size: Size.infinite,
      painter: DrawingPainter(
          _interactionConsumer
      ),
    );

    Widget gestureDetector = buildGestureDetector(_recognizer, painter);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
      ),
      body: gestureDetector,
    );
  }

  Widget buildGestureDetector(ImmediateMultiDragGestureRecognizer recognizer, CustomPaint child) {
//    print("buildGestureDetector");
//    print(child);
    return RawGestureDetector(
      gestures: {
        ImmediateMultiDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<ImmediateMultiDragGestureRecognizer>(
              () => recognizer,
              (ImmediateMultiDragGestureRecognizer instance) {
          },
        ),
      },
      child: child,
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter(this._interactionConsumer);
  InteractionConsumer _interactionConsumer;
  @override
  void paint(Canvas canvas, Size size) {

//    print("paint");
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    List<InteractionHistory> activeFingers = _interactionConsumer.fingers.where((finger) => finger.hasPositions).toList();
//    print(activeFingers);
    for (InteractionHistory fingerHistory in activeFingers) {
      if (fingerHistory.hasPositions) {
        canvas.drawCircle(fingerHistory.positions.last.position, 100, paint);

      }

    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
//  print("should repaint");

  return true;
}
}
