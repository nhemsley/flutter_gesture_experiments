import 'package:flutter/gestures.dart';

import 'drag_consumer.dart';
import 'interaction_history.dart';

class InteractionConsumer {

  static int _numFingers = 5;
  static int _fingerDistanceHeuristic = 100;

  static Offset _thumbPosition = new Offset(200, 860);

  List<double> _initialFingerDistanceProjections = [0, 300, 450, 600, 700];


  List<InteractionHistory> _fingers = new List<InteractionHistory>();

  ImmediateMultiDragGestureRecognizer _recognizer;

  InteractionConsumerUpdateCallback _onUpdate = () => null;

  InteractionConsumer(this._recognizer) {
    registerCallbacks();

    for (var i = 0; i < _numFingers; i++) {
      _fingers.add(new InteractionHistory(new DragConsumer(this)));
    }
  }

  void registerCallbacks() {
    _recognizer.onStart = (position) => this.onStart(position);
  }

  //TODO: heuristics to guess which finger is starting
  Drag onStart(Offset position) {
//  print("InteractionConsumer.onStart");
    int fingerIndex = 0;

    if (isFingerDown) {
//      print("finger down");
      fingerIndex = guessFingerIndex(position);
    } else {
//      print("finger not down");
      fingerIndex = guessInitialFingerIndex(position);
    }

    start(position, fingerIndex);


    return _fingers[fingerIndex].drag;
  }

  void start(Offset position, int fingerIndex) {
    _fingers[fingerIndex].addPosition(position);
    notifyUpdate();
  }

  void update(DragUpdateDetails details, Drag drag) {
//    print("InteractionConsumer.update");
      InteractionHistory finger = findInteractionHistoryFromDrag(drag);
      finger.addPosition(details.localPosition);
    notifyUpdate();
//      print(finger);
//      print(_fingers.indexOf(finger));
  }

  void cancel(Drag drag) {
//    print("cancel");
    notifyUpdate();
  }

  void end(DragEndDetails details, Drag drag) {
//    print("end");
    InteractionHistory history = findInteractionHistoryFromDrag(drag);
    history.end();
    notifyUpdate();
  }

  void notifyUpdate() {
    _onUpdate();
  }

  InteractionHistory findInteractionHistoryFromDrag(Drag drag) {
    return _fingers.firstWhere((finger) => finger.drag == drag);
  }

  int guessFingerIndex(Offset position) {
    return guessInitialFingerIndex(position);
  }

  int guessInitialFingerIndex(Offset position) {

    double distance = (_thumbPosition - position).distance.abs();

    // map to the difference from each finger distance, to the actual distance
    List<double> distances = _initialFingerDistanceProjections.map((dp) => (dp - distance).abs()).toList();
    // sort them
    List<double> sortedDistances = new List<double>.from(distances);
    sortedDistances.sort((a, b) => a.compareTo(b));
    // find the index with the shortest distance
    int index = distances.indexOf(sortedDistances[0]);
    return index;
  }

  set onUpdate (InteractionConsumerUpdateCallback callback) {
    _onUpdate = callback;
  }


  bool get isFingerDown {
    List<bool> hasPositions = _fingers.map((finger) => finger.hasPositions).toList();
//    print(hasPositions);
    return !_fingers.every((finger) => !finger.hasPositions);
  }


  List<InteractionHistory> get fingers {
    return _fingers;
  }

  InteractionHistory get little {
    return _fingers[0];
  }

  InteractionHistory get ring {
    return _fingers[2];
  }

  InteractionHistory get middle {
    return _fingers[1];
  }

  InteractionHistory get index {
    return _fingers[3];
  }

  InteractionHistory get thumb {
    return _fingers[4];
  }

}

typedef InteractionConsumerUpdateCallback = void Function();