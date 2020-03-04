import 'package:flutter/material.dart';

class Interaction {
  Offset _position;
  DateTime _time;

  Interaction(this._position) {
    _time = new DateTime.now();
  }

  Offset get position {
    return _position;
  }

  DateTime get time {
    return _time;
  }

}