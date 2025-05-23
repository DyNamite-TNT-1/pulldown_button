import 'package:flutter/cupertino.dart';

class AnimationUtils {
  /// Pull-down menu animation duration.
  static const Duration kMenuDuration = Duration(milliseconds: 300);

  /// Pull-down menu animation curve used on menu open.
  ///
  /// A cubic animation curve that starts slowly and ends with an overshoot of
  /// its bounds before reaching its end.
  static const Curve kCurve = Cubic(0.075, 0.82, 0.4, 1.065);

  /// Pull-down menu animation curve used on menu close.
  static const Curve kCurveReverse = Curves.easeIn;

  /// A curve tween for [PulldownMenuRouteTheme.shadow].
  static final CurveTween shadowTween = CurveTween(
    curve: const Interval(1 / 3, 1),
  );
}

class ClampedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  /// Creates [ClampedAnimation].
  ClampedAnimation(this.parent);

  @override
  final Animation<double> parent;

  @override
  double get value => parent.value.clamp(0, 1);
}
