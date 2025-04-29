import 'package:flutter/material.dart';

import 'utils/animation.dart';

/// An [AnimatedContainer] with predefined [duration] and [curve].
///
/// Is used to animate a container on text scale factor change.
class AnimatedMenuContainer extends AnimatedContainer {
  /// Creates [AnimatedMenuContainer].
  AnimatedMenuContainer({
    super.key,
    super.constraints,
    super.alignment,
    super.padding,
    required super.child,
  }) : super(
         duration: AnimationUtils.kMenuDuration,
         curve: Curves.fastOutSlowIn,
       );
}
