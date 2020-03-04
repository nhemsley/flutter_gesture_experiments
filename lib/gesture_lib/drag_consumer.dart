import 'package:flutter/gestures.dart';

import 'interaction_consumer.dart';

class DragConsumer implements Drag {

  InteractionConsumer _interactionConsumer;

  DragConsumer(this._interactionConsumer);


  @override
  void update(DragUpdateDetails details) {
    _interactionConsumer.update(details, this);
  }

  @override
  void cancel() {
    _interactionConsumer.cancel(this);

  }

  @override
  void end(DragEndDetails details) {
    _interactionConsumer.end(details, this);
  }
}