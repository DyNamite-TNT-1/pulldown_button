import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../items/entry.dart';
import 'divider_theme.dart';
import 'item_theme.dart';
import 'route_theme.dart';

/// Defines the visual properties of the routes used to display pull-down menus
/// as well as any widgets that extend [PulldownMenuEntry].
///
/// Widgets that extend [PulldownMenuEntry] obtain the current
/// [PulldownButtonTheme] object using `PulldownTheme.of(context)`.
///
/// [PulldownButtonTheme] should be specified in [ThemeData.extensions] or
/// using [PulldownButtonInheritedTheme] in the `builder` property of
/// [MaterialApp] or [CupertinoApp].
///
/// All [PulldownButtonTheme] properties are `null` by default.
/// If any of these properties are null, or some properties of sub-themes are
/// null, the pull-down menu will use iOS 16 defaults specified in each
/// sub-theme.
@immutable
class PulldownButtonTheme extends ThemeExtension<PulldownButtonTheme>
    with Diagnosticable {
  /// Creates the set of properties used to configure [PulldownButtonTheme].
  const PulldownButtonTheme({
    this.routeTheme,
    this.itemTheme,
    this.dividerTheme,
  });

  /// Sub-theme for visual properties of the routes used to display pull-down
  /// menus.
  final PulldownMenuRouteTheme? routeTheme;

  /// Sub-theme for visual properties of the items in pull-down menus.
  final PulldownMenuItemTheme? itemTheme;

  /// Sub-theme for visual properties of the dividers in pull-down menus.
  final PulldownMenuDividerTheme? dividerTheme;

  /// Get [PulldownButtonTheme] from [PulldownButtonInheritedTheme].
  ///
  /// If that's null get [PulldownButtonTheme] from [ThemeData.extensions]
  /// property of the ambient [Theme].
  static PulldownButtonTheme? maybeOf(BuildContext context) =>
      PulldownButtonInheritedTheme.maybeOf(context) ??
      Theme.of(context).extensions[PulldownButtonTheme] as PulldownButtonTheme?;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  @override
  PulldownButtonTheme copyWith({
    PulldownMenuRouteTheme? routeTheme,
    PulldownMenuItemTheme? itemTheme,
    PulldownMenuDividerTheme? dividerTheme,
  }) => PulldownButtonTheme(
    routeTheme: routeTheme ?? this.routeTheme,
    itemTheme: itemTheme ?? this.itemTheme,
    dividerTheme: dividerTheme ?? this.dividerTheme,
  );

  /// Linearly interpolate between two themes.
  @override
  PulldownButtonTheme lerp(
    ThemeExtension<PulldownButtonTheme>? other,
    double t,
  ) {
    if (other is! PulldownButtonTheme || identical(this, other)) return this;

    return PulldownButtonTheme(
      routeTheme: PulldownMenuRouteTheme.lerp(routeTheme, other.routeTheme, t),
      itemTheme: PulldownMenuItemTheme.lerp(itemTheme, other.itemTheme, t),
      dividerTheme: PulldownMenuDividerTheme.lerp(
        dividerTheme,
        other.dividerTheme,
        t,
      ),
    );
  }

  @override
  int get hashCode => Object.hash(routeTheme, itemTheme, dividerTheme);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PulldownButtonTheme &&
        other.routeTheme == routeTheme &&
        other.itemTheme == itemTheme &&
        other.dividerTheme == dividerTheme;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('routeTheme', routeTheme, defaultValue: null))
      ..add(DiagnosticsProperty('itemTheme', itemTheme, defaultValue: null))
      ..add(
        DiagnosticsProperty('dividerTheme', dividerTheme, defaultValue: null),
      );
  }
}

/// Alternative way of defining [PulldownButtonTheme].
///
/// Example:
///
/// ```dart
/// CupertinoApp(
///    builder: (context, child) => PulldownInheritedTheme(
///      data: const PulldownTheme(
///        ...
///      ),
///      child: child!,
///  ),
/// home: ...,
/// ```
@immutable
class PulldownButtonInheritedTheme extends InheritedTheme {
  /// Creates a [PulldownButtonInheritedTheme].
  const PulldownButtonInheritedTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final PulldownButtonTheme data;

  /// Returns the current [PulldownButtonTheme] from the closest
  /// [PulldownButtonInheritedTheme] ancestor.
  ///
  /// If there is no ancestor, it returns `null`.
  static PulldownButtonTheme? maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<PulldownButtonInheritedTheme>()
          ?.data;

  @override
  bool updateShouldNotify(covariant PulldownButtonInheritedTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      PulldownButtonInheritedTheme(data: data, child: child);
}
