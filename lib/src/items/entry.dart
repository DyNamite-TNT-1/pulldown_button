import 'package:flutter/material.dart';
import '../pulldown_button.dart';

/// Used to limit types of children passed to [PulldownButton.itemBuilder].
@immutable
abstract class PulldownMenuEntry implements PreferredSizeWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PulldownMenuEntry();
}
