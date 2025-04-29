import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../pulldown_button.dart';

/// Defines the visual properties of the dividers in pull-down menus.
///
/// Is used by [PulldownMenuDivider], [PulldownMenuDivider.large].
///
/// All [PulldownMenuDividerTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [PulldownMenuDividerTheme.defaults].
@immutable
class PulldownMenuDividerTheme with Diagnosticable {
  /// Creates the set of properties used to configure
  /// [PulldownMenuDividerTheme].
  const PulldownMenuDividerTheme({this.dividerColor, this.largeDividerColor});

  /// Creates default set of properties used to configure
  /// [PulldownMenuRouteTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch file.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch file:
  ///   https://developer.apple.com/design/resources/
  const factory PulldownMenuDividerTheme.defaults(BuildContext context) =
      _PulldownMenuDividerDefaults;

  /// The color of the [PulldownMenuDivider].
  final Color? dividerColor;

  /// The color of the [PulldownMenuDivider.large].
  final Color? largeDividerColor;

  /// The [PulldownButtonTheme.dividerTheme] property of the ambient
  /// [PulldownButtonTheme].
  static PulldownMenuDividerTheme? maybeOf(BuildContext context) =>
      PulldownButtonTheme.maybeOf(context)?.dividerTheme;

  /// The helper method to quickly resolve [PulldownMenuDividerTheme] from
  /// [PulldownButtonTheme.dividerTheme] or [PulldownMenuDividerTheme.defaults].
  static PulldownMenuDividerTheme resolve(BuildContext context) {
    final theme = PulldownMenuDividerTheme.maybeOf(context);
    final defaults = PulldownMenuDividerTheme.defaults(context);

    return theme ?? defaults;
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PulldownMenuDividerTheme copyWith({
    Color? dividerColor,
    Color? largeDividerColor,
  }) => PulldownMenuDividerTheme(
    dividerColor: dividerColor ?? this.dividerColor,
    largeDividerColor: largeDividerColor ?? this.largeDividerColor,
  );

  /// Linearly interpolate between two themes.
  static PulldownMenuDividerTheme lerp(
    PulldownMenuDividerTheme? a,
    PulldownMenuDividerTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    return PulldownMenuDividerTheme(
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
      largeDividerColor: Color.lerp(
        a?.largeDividerColor,
        b?.largeDividerColor,
        t,
      ),
    );
  }

  @override
  int get hashCode => Object.hash(dividerColor, largeDividerColor);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PulldownMenuDividerTheme &&
        other.dividerColor == dividerColor &&
        other.largeDividerColor == largeDividerColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('dividerColor', dividerColor, defaultValue: null))
      ..add(
        ColorProperty(
          'largeDividerColor',
          largeDividerColor,
          defaultValue: null,
        ),
      );
  }
}

/// A set of default values for [PulldownMenuDividerTheme].
@immutable
class _PulldownMenuDividerDefaults extends PulldownMenuDividerTheme {
  /// Creates [_PulldownMenuDividerDefaults].
  const _PulldownMenuDividerDefaults(this.context);

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark colors of the [PulldownMenuDivider].
  static const kDividerColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(17, 17, 17, 0.3),
    darkColor: Color.fromRGBO(217, 217, 217, 0.3),
  );

  /// The light and dark colors of the [PulldownMenuDivider.large].
  static const kLargeDividerColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    darkColor: Color.fromRGBO(0, 0, 0, 0.16),
  );

  @override
  Color get dividerColor => kDividerColor.resolveFrom(context);

  @override
  Color get largeDividerColor => kLargeDividerColor.resolveFrom(context);
}
