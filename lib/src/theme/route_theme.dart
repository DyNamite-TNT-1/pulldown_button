import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../pulldown_button.dart';

/// Defines the visual properties of the routes used to display pull-down menus.
///
/// All [PulldownMenuRouteTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [PulldownMenuRouteTheme.defaults].
@immutable
class PulldownMenuRouteTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PulldownMenuRouteTheme].
  const PulldownMenuRouteTheme({
    this.backgroundColor,
    this.borderRadius,
    this.shadow,
    this.width,
  });

  /// Creates default set of properties used to configure
  /// [PulldownMenuRouteTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch file.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch file:
  ///   https://developer.apple.com/design/resources/
  const factory PulldownMenuRouteTheme.defaults(BuildContext context) =
      _PulldownMenuRouteThemeDefaults;

  /// The background color of the pull-down menu.
  final Color? backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius? borderRadius;

  /// The pull-down menu shadow.
  final BoxShadow? shadow;

  /// The width of pull-down menu.
  final double? width;

  /// The [PulldownButtonTheme.routeTheme] property of the ambient
  /// [PulldownButtonTheme].
  static PulldownMenuRouteTheme? maybeOf(BuildContext context) =>
      PulldownButtonTheme.maybeOf(context)?.routeTheme;

  /// The helper method to quickly resolve [PulldownMenuRouteTheme] from
  /// [PulldownButtonTheme.routeTheme] or [PulldownMenuRouteTheme.defaults]
  /// as well as from theme data from [PulldownButton] or [showPulldownMenu].
  static PulldownMenuRouteTheme resolve(
    BuildContext context, {
    required PulldownMenuRouteTheme? routeTheme,
  }) {
    final theme = PulldownMenuRouteTheme.maybeOf(context);
    final defaults = PulldownMenuRouteTheme.defaults(context);

    return PulldownMenuRouteTheme(
      backgroundColor:
          routeTheme?.backgroundColor ??
          theme?.backgroundColor ??
          defaults.backgroundColor!,
      borderRadius:
          routeTheme?.borderRadius ??
          theme?.borderRadius ??
          defaults.borderRadius!,
      shadow: routeTheme?.shadow ?? theme?.shadow ?? defaults.shadow!,
      width: routeTheme?.width ?? theme?.width ?? defaults.width!,
    );
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PulldownMenuRouteTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    BoxShadow? shadow,
    double? width,
  }) => PulldownMenuRouteTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    shadow: shadow ?? this.shadow,
    width: width ?? this.width,
  );

  /// Linearly interpolate between two themes.
  static PulldownMenuRouteTheme lerp(
    PulldownMenuRouteTheme? a,
    PulldownMenuRouteTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    return PulldownMenuRouteTheme(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
      shadow: BoxShadow.lerp(a?.shadow, b?.shadow, t),
      width: ui.lerpDouble(a?.width, b?.width, t),
    );
  }

  @override
  int get hashCode => Object.hash(backgroundColor, borderRadius, shadow, width);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PulldownMenuRouteTheme &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.shadow == shadow &&
        other.width == width;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('borderRadius', borderRadius, defaultValue: null),
      )
      ..add(DiagnosticsProperty('shadow', shadow, defaultValue: null))
      ..add(DoubleProperty('width', width, defaultValue: null));
  }
}

/// A set of default values for [PulldownMenuRouteTheme].
@immutable
class _PulldownMenuRouteThemeDefaults extends PulldownMenuRouteTheme {
  /// Creates [_PulldownMenuRouteThemeDefaults].
  const _PulldownMenuRouteThemeDefaults(this.context)
    : super(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        width: 250,
        shadow: const BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.2),
          blurRadius: 64,
        ),
      );

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark color of the menu's background.
  static const kBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(247, 247, 247, 0.8),
    darkColor: Color.fromRGBO(36, 36, 36, 0.75),
  );

  @override
  Color get backgroundColor => kBackgroundColor.resolveFrom(context);
}
