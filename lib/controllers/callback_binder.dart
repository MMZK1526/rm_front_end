import 'package:flutter/material.dart';

class CallbackBinder<T> {
  final Map<T, VoidCallback> _listeners = {};

  VoidCallback? operator [](T key) {
    return _listeners[key];
  }

  void operator []=(T key, VoidCallback callback) {
    _listeners[key] = callback;
  }
}
