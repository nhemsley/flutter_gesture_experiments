import 'package:flutter/gestures.dart';

import 'interaction.dart';

class InteractionHistory {

  // position history of finger
  List<Interaction> _positions;
  Drag _drag;

  InteractionHistoryUpdateCallback _onUpdate;

  InteractionHistory(this._drag) {
//    print("InteractionHistory.new");
    _positions = new List<Interaction>();
  }

  DragGestureRecognizer a;

  void addPosition(Offset position) {
    Interaction interaction = new Interaction(position);
    _positions.add(interaction);
//    if (_positions.length > 0) print("addPosition length > 0");
//    print("addPosition");
    if (_onUpdate != null) {
//      print("addPosition: _onUpdate");
      _onUpdate(position, this);
    }
  }

  void end() {
    _positions.clear();
  }

  List<Interaction> get positions { return _positions; }

  Drag get drag { return _drag; }

  bool get hasPositions {
    return _positions.length > 0;
  }

  bool get isEngaged {return hasPositions; }

  set onUpdate (InteractionHistoryUpdateCallback callback) {
    _onUpdate = callback;
  }

}

typedef InteractionHistoryUpdateCallback = void Function(Offset position, InteractionHistory history);

