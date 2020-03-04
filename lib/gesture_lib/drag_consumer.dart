import 'package:flutter/gestures.dart';

import 'interaction_consumer.dart';

/// Notified by the flutter runtime when Interactions are updated
/// Notifies in turn [InteractionConsumer _interactionConsumer]
/// that there has been an update, which is where the real work happens
class DragConsumer implements Drag {

  InteractionConsumer _interactionConsumer;

  DragConsumer(this._interactionConsumer);


  @override
  void update(DragUpdateDetails details) {
//    print("DragConsumer.update");
    _interactionConsumer.update(details, this);
  }

  @override
  void cancel() {
//    print("DragConsumer.cancel");

    _interactionConsumer.cancel(this);

  }

  @override
  void end(DragEndDetails details) {
//    print("DragConsumer.end");

    _interactionConsumer.end(details, this);
  }
}