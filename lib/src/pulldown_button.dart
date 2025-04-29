import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulldown_button/src/internals/utils/extensions.dart';
import 'package:pulldown_button/src/items/divider.dart';

import '../pulldown_button.dart';
import 'internals/menu_config.dart';
import 'internals/route/route.dart';

/// Used to provide information about menu animation state in
/// [PulldownButton.animationBuilder].
///
/// Used by [PulldownButtonAnimationBuilder].
enum PulldownButtonAnimationState {
  /// The menu is closed.
  closed,

  /// The menu is opened by calling [showMenu] using
  /// [PulldownButton.buttonBuilder]'s button widget.
  opened;

  /// Whether the [PulldownMenuButtonBuilder]s button is pressed and the menu
  /// is open.
  bool get isOpen => this == PulldownButtonAnimationState.opened;
}

/// Used to configure what horizontal part of the
/// [PulldownButton.buttonBuilder] will be considered as an anchor to open
/// the menu from.
///
/// It's best suited for situations where [PulldownButton.buttonBuilder] fills
/// the entire width of the screen and it is desired that menu opens from a
/// specific button edge.
enum PulldownMenuAnchor {
  /// The menu will be "opened" from the [PulldownButton.buttonBuilder]
  /// start edge.
  ///
  /// A [TextDirection] must be available to determine if the start is the left
  /// or the right.
  start,

  /// The menu will be "opened" from the [PulldownButton.buttonBuilder] center.
  center,

  /// The menu will be "opened" from the [PulldownButton.buttonBuilder]
  /// end edge.
  ///
  /// A [TextDirection] must be available to determine if the end is the left
  /// or the right.
  end,
}

/// Signature for the callback invoked when a [PulldownButton] is dismissed
/// without selecting an item.
///
/// Used by [PulldownButton.onCanceled].
typedef PulldownMenuCanceled = void Function();

/// Signature used by [PulldownButton] to lazily construct the items shown when
/// the button is pressed.
///
/// Used by [PulldownButton.itemBuilder].
typedef PulldownMenuItemBuilder =
    List<PulldownMenuEntry> Function(BuildContext context);

/// Signature used by [PulldownButton] to build button widget.
///
/// Used by [PulldownButton.buttonBuilder].
typedef PulldownMenuButtonBuilder =
    Widget Function(BuildContext context, Future<void> Function() showMenu);

/// Signature used by [PulldownButton] to create animation for
/// [PulldownButton.buttonBuilder] when the pull-down menu is opened.
///
/// [child] is a button created with [PulldownButton.buttonBuilder].
///
/// Used by [PulldownButton.animationBuilder].
typedef PulldownButtonAnimationBuilder =
    Widget Function(
      BuildContext context,
      PulldownButtonAnimationState state,
      Widget child,
    );

class PulldownButton extends StatefulWidget {
  const PulldownButton({
    super.key,
    required this.itemBuilder,
    required this.buttonBuilder,
    this.onCanceled,
    this.buttonAnchor,
    this.menuOffset = 16,
    this.scrollController,
    this.animationBuilder = defaultAnimationBuilder,
    this.routeTheme,
    this.useRootNavigator = false,
    this.routeSettings,
  });

  final PulldownMenuItemBuilder itemBuilder;

  final PulldownMenuButtonBuilder buttonBuilder;

  /// Called when the user dismisses the pull-down menu.
  final PulldownMenuCanceled? onCanceled;

  /// Whether the pull-down menu is anchored to the center, left, or right side
  /// of the [buttonBuilder].
  ///
  /// If `null` no anchoring will be involved.
  ///
  /// Defaults to `null`.
  final PulldownMenuAnchor? buttonAnchor;

  /// Additional horizontal offset for the pull-down menu if the menu's desired
  /// position is not in the central third of the screen.
  ///
  /// If the menu's desired position is in the right side of the screen,
  /// [menuOffset] is added to said position (menu moves to the right). If the
  /// menu's desired position is in the left side of the screen, [menuOffset]
  /// is subtracted from said position (menu moves to the left).
  ///
  /// Consider using [buttonAnchor] if you want to offset the menu for a large
  /// amount of px.
  ///
  /// Defaults to 16px.
  final double menuOffset;

  /// A scroll controller that can be used to control the scrolling of the
  /// [itemBuilder] in the menu.
  ///
  /// If `null`, uses an internally created [ScrollController].
  final ScrollController? scrollController;

  /// Theme of the route used to display pull-down menu launched from this
  /// [PulldownButton].
  ///
  /// If this property is null, then [PulldownMenuRouteTheme] from
  /// [PulldownButtonTheme.routeTheme] is used.
  ///
  /// If that's null, then [PulldownMenuRouteTheme.defaults] is used.
  final PulldownMenuRouteTheme? routeTheme;

  /// Custom animation for [buttonBuilder] when the pull-down menu is opening or
  /// closing.
  ///
  /// Defaults to [defaultAnimationBuilder] which applies opacity on
  /// [buttonBuilder] as it is in iOS.
  ///
  /// If this property is null, then no animation will be used.
  final PulldownButtonAnimationBuilder? animationBuilder;

  /// Whether to use the root navigator to show the pull-down menu.
  ///
  /// Defaults to `false`.
  ///
  /// This property allows to show the pull-down menu on the root navigator
  /// instead of the current navigator, useful for nested navigation scenarios
  /// where the popup menu wouldn't be visible or would be clipped by the
  /// parent navigators.
  final bool useRootNavigator;

  /// Optional route settings for the pull-down menu.
  ///
  /// See [RouteSettings] for details.
  final RouteSettings? routeSettings;

  /// Default animation builder for [animationBuilder].
  ///
  /// If [state] is [PulldownButtonAnimationState.opened], apply opacity
  /// on [child] as it is in iOS.
  static Widget defaultAnimationBuilder(
    BuildContext context,
    PulldownButtonAnimationState state,
    Widget child,
  ) {
    final isOpen = state.isOpen;

    // All of the values where eyeballed using the iOS 16 Simulator.
    return AnimatedOpacity(
      opacity: isOpen ? 0.4 : 1,
      duration: Duration(milliseconds: isOpen ? 100 : 200),
      curve: isOpen ? Curves.fastLinearToSlowEaseIn : Curves.easeIn,
      child: child,
    );
  }

  @override
  State<PulldownButton> createState() => _PulldownButtonState();
}

class _PulldownButtonState extends State<PulldownButton> {
  PulldownButtonAnimationState state = PulldownButtonAnimationState.closed;

  Future<void> showButtonMenu() async {
    final navigator = Navigator.of(
      context,
      rootNavigator: widget.useRootNavigator,
    );

    final overlay = navigator.overlay!.context.currentRenderBox;
    var button = context.getRect(ancestor: overlay);

    if (widget.buttonAnchor != null) {
      button = _anchorToButtonPart(context, button, widget.buttonAnchor!);
    }

    var items = widget.itemBuilder(context);

    if (items.isEmpty) return;

    items = MenuSeparator.wrapVerticalList(items);

    double height = 0.0;

    for (var item in items) {
      height += item.preferredSize.height;
    }

    // Use [navigator.context] to retrieve the full MediaQuery padding,
    // unaffected by any SafeArea widgets higher in the widget tree.
    final animationAlignment = PulldownMenuRoute.animationAlignment(
      navigator.context,
      button,
      height,
    );

    final hasLeading = MenuConfig.menuHasLeading(items);

    setState(() => state = PulldownButtonAnimationState.opened);

    final action = await _showMenu<VoidCallback>(
      context: context,
      items: items,
      buttonRect: button,
      routeTheme: widget.routeTheme,
      hasLeading: hasLeading,
      animationAlignment: animationAlignment,
      menuOffset: widget.menuOffset,
      menuHeight: height,
      scrollController: widget.scrollController,
      useRootNavigator: widget.useRootNavigator,
      routeSettings: widget.routeSettings,
    );

    if (!mounted) return;

    setState(() => state = PulldownButtonAnimationState.closed);

    if (action != null) {
      action.call();
    } else {
      widget.onCanceled?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonBuilder = widget.buttonBuilder(context, showButtonMenu);

    return widget.animationBuilder?.call(context, state, buttonBuilder) ??
        buttonBuilder;
  }
}

/// Is used internally by [PulldownButton] to show the pull-down menu.
Future<VoidCallback?> _showMenu<VoidCallback>({
  required BuildContext context,
  required Rect buttonRect,
  required List<PulldownMenuEntry> items,
  required PulldownMenuRouteTheme? routeTheme,
  required bool hasLeading,
  required Alignment animationAlignment,
  required double menuOffset,
  required double menuHeight,
  required ScrollController? scrollController,
  required bool useRootNavigator,
  required RouteSettings? routeSettings,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);

  return navigator.push<VoidCallback>(
    PulldownMenuRoute(
      buttonRect: buttonRect,
      items: items,
      barrierLabel: _barrierLabel(context),
      routeTheme: routeTheme,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      hasLeading: hasLeading,
      alignment: animationAlignment,
      menuOffset: menuOffset,
      menuHeight: menuHeight,
      scrollController: scrollController,
      settings: routeSettings,
    ),
  );
}

/// "Anchors" menu to specific [buttonRect] side.
///
/// [anchor] is a side to which it is required to "anchor".
Rect _anchorToButtonPart(
  BuildContext context,
  Rect buttonRect,
  PulldownMenuAnchor anchor,
) {
  final textDirection = Directionality.of(context);

  final side = switch (anchor) {
    PulldownMenuAnchor.start when textDirection == TextDirection.ltr =>
      buttonRect.left,
    PulldownMenuAnchor.start => buttonRect.right,
    PulldownMenuAnchor.center => buttonRect.center.dx,
    PulldownMenuAnchor.end when textDirection == TextDirection.ltr =>
      buttonRect.right,
    PulldownMenuAnchor.end => buttonRect.left,
  };

  return Rect.fromLTRB(side, buttonRect.top, side, buttonRect.bottom);
}

/// Returns a barrier label for [PulldownMenuRoute].
String _barrierLabel(BuildContext context) {
  // Use this instead of `MaterialLocalizations.of(context)` because
  // [MaterialLocalizations] might be null in some cases.
  final materialLocalizations = Localizations.of<MaterialLocalizations>(
    context,
    MaterialLocalizations,
  );

  // Use this instead of `CupertinoLocalizations.of(context)` because
  // [CupertinoLocalizations] might be null in some cases.
  final cupertinoLocalizations = Localizations.of<CupertinoLocalizations>(
    context,
    CupertinoLocalizations,
  );

  // If both localizations are null, fallback to
  // [DefaultMaterialLocalizations().modalBarrierDismissLabel].
  return materialLocalizations?.modalBarrierDismissLabel ??
      cupertinoLocalizations?.modalBarrierDismissLabel ??
      const DefaultMaterialLocalizations().modalBarrierDismissLabel;
}
