import 'package:flutter/material.dart';
import 'package:rm_front_end/controllers/input_manager.dart';

/// A class that manages the input of registers for a Register Machine.
///
/// Initially, there are 4 register input fields. When the user clicks the
/// "Add" button, a new register input field is added. When the user clicks
/// the "Reset Inputs" button, all register input fields are reset.
///
/// If a register value is not provided, it defaults to 0.
class RegisterInputManager extends ChangeNotifier {
  /// The initial number of register input fields.
  static const initialRegisterInputCount = 4;

  /// The list of [InputManager]s for the register input fields.
  final _registerInputManagers = <InputManager<void>>[];

  /// The [ScrollController] for the register input fields.
  final scrollController = ScrollController();

  /// If the register input fields should be scrolled to the end on post frame.
  bool _scrollToEnd = false;

  /// Get the [TextEditingController] for the register input field at [index].
  TextEditingController getController(int index) =>
      _registerInputManagers[index].textController;

  /// If the register input fields are reset.
  bool get isRegisterInputResetted =>
      _registerInputManagers.length == initialRegisterInputCount &&
      _registerInputManagers.every((im) => im.textController.text.isEmpty);

  /// The number of register input fields.
  int get registerCount => _registerInputManagers.length;

  /// The list of register values, replacing empty inputs with "0".
  List<String> get registerValues => _registerInputManagers
      .map(
        (im) => im.textController.text.isEmpty ? '0' : im.textController.text,
      )
      .toList();

  /// Initialise the [InputManager]s for the four initial register input fields.
  void initState() {
    for (final im in _registerInputManagers) {
      im.dispose();
    }
    _registerInputManagers.clear();

    _registerInputManagers.addAll(
      List.generate(initialRegisterInputCount, (_) => InputManager()),
    );
    for (final im in _registerInputManagers) {
      im.initState();
      im.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (final im in _registerInputManagers) {
      im.dispose();
    }
    _registerInputManagers.clear();
    scrollController.dispose();
    super.dispose();
  }

  /// Reset the register input fields.
  void onReset() {
    initState();
    notifyListeners();
  }

  /// Add a new register input field.
  void onAddRegister() {
    final im = InputManager();
    im.initState();
    im.addListener(notifyListeners);
    _registerInputManagers.add(im);

    /// Scroll to the end of the register input fields to show the new register
    /// on the next frame.
    _scrollToEnd = true;

    notifyListeners();

    // Scroll to the end of the register input fields to show the new register
    // input field.
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  /// Scroll to the end of the register input fields to show the new register.
  ///
  /// This is called after the frame is rendered because the max scroll position
  /// is not updated until after the frame is rendered.
  void onPostFrame() {
    if (_scrollToEnd) {
      _scrollToEnd = false;

      // Scroll to the end of the register input fields to show the new register
      // input field.
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
