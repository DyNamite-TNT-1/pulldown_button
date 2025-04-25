import 'package:flutter/material.dart';

/// Used to limit types of children passed to [PullDownButton.itemBuilder].
@immutable
abstract class PullDownMenuEntry implements PreferredSizeWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PullDownMenuEntry();
}
