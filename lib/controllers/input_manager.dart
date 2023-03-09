import 'dart:async';

import 'package:flutter/widgets.dart';

class InputManager<T> extends ChangeNotifier {
  final textController = TextEditingController();
  bool _hasInput = false;
  String? _currentSearchedInput;
  T? _data;

  bool get hasInput => _hasInput;
  String? get currentSearchedInput => _currentSearchedInput;
  T? get data => _data;

  void initState() {
    textController.addListener(() {
      final hasInput =
          textController.text.isNotEmpty || _currentSearchedInput != null;
      if (hasInput != _hasInput) {
        _hasInput = hasInput;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> onQuery(FutureOr<T?> Function(String) callback) async {
    final inputText = textController.text;

    if (inputText.isEmpty) {
      final curInput = _currentSearchedInput;
      if (curInput == null) {
        return;
      }
      textController.text = curInput;
    } else {
      final response = await callback(inputText);
      _currentSearchedInput = inputText;
      _data = response;
    }

    notifyListeners();
  }

  void onReset() {
    textController.clear();
    _hasInput = false;
    _currentSearchedInput = null;
    _data = null;
    notifyListeners();
  }
}
