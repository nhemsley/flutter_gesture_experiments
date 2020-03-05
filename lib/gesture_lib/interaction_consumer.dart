import 'package:flutter/gestures.dart';

import 'drag_consumer.dart';
import 'interaction_history.dart';

class InteractionConsumer {

  List<InteractionHistory> _fingers = new List<InteractionHistory>();

  ImmediateMultiDragGestureRecognizer _recognizer;

  InteractionConsumerUpdateCallback _onUpdate = () => null;

  InteractionConsumer(this._recognizer) {
    registerCallbacks();

  }

  void registerCallbacks() {
    _recognizer.onStart = (position) => this.onStart(position);
  }

  /// onStart is the first method call from the flutter runtime when a finger is pressed down
  /// @returns the [Drag drag] that is associated with this interaction. The flutter runtime
  /// will notify this [Drag drag] of any updates.
  Drag onStart(Offset position) {
//  print("InteractionConsumer.onStart");

    InteractionHistory interactionHistory = new InteractionHistory(new DragConsumer(this));

    _fingers.add(interactionHistory);
    start(position, interactionHistory);

    return interactionHistory.drag;
  }

  void start(Offset position, InteractionHistory interactionHistory) {
    interactionHistory.addPosition(position);
    notifyUpdate();
  }

  void update(DragUpdateDetails details, Drag drag) {
//    print("InteractionConsumer.update");
      InteractionHistory finger = findInteractionHistoryFromDrag(drag);
      finger.addPosition(details.localPosition);
      notifyUpdate();
  }

  void cancel(Drag drag) {
//    print("cancel");
    InteractionHistory history = findInteractionHistoryFromDrag(drag);
    _fingers.remove(history);
//    print(_fingers.length);
    notifyUpdate();
  }

  void end(DragEndDetails details, Drag drag) {
//    print("end");
    InteractionHistory history = findInteractionHistoryFromDrag(drag);
    _fingers.remove(history);
//    print(_fingers.length);
    notifyUpdate();
  }

  void notifyUpdate() {
//    debugMemUsage();
    _onUpdate();
  }

  InteractionHistory findInteractionHistoryFromDrag(Drag drag) {
    return _fingers.firstWhere((finger) => finger.drag == drag);
  }

  set onUpdate (InteractionConsumerUpdateCallback callback) {
    _onUpdate = callback;
  }

  void debugMemUsage() {
    List<int> lengths = _fingers.map((f) => f.positions.length).toList();
    print(lengths);
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