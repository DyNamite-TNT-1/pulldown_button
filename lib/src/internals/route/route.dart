import 'package:flutter/cupertino.dart';

import '../../theme/route_theme.dart';
import '../continuous_swipe.dart';
import '../../items/entry.dart';
import '../menu_config.dart';
import '../utils/animation.dart';
import 'route_menu.dart';

part 'route_layout.dart';

class PulldownMenuRoute<VoidCallback> extends PopupRoute<VoidCallback> {
  /// Creates [PullDownMenuRoute].
  PulldownMenuRoute({
    required this.items,
    required this.barrierLabel,
    required this.routeTheme,
    required this.buttonRect,
    required this.capturedThemes,
    required this.hasLeading,
    required this.alignment,
    required this.menuOffset,
    required this.scrollController,
    required super.settings,
  });

  /// Items to show in the [RoutePullDownMenu] created by this route.
  final List<PullDownMenuEntry> items;

  /// Captured inherited themes, specifically [PullDownButtonInheritedTheme],
  /// to pass to [RoutePullDownMenu] and all its [items].
  final CapturedThemes capturedThemes;

  /// The custom route theme to be used by [RoutePullDownMenu].
  final PullDownMenuRouteTheme? routeTheme;

  /// Whether the pull-down menu has any [PullDownMenuItem]s with leading
  /// widget such as chevron.
  final bool hasLeading;

  /// Rect of a button used to open the pull-down menu.
  ///
  /// Is used to calculate the final menu's position.
  final Rect buttonRect;

  final Alignment alignment;

  /// Is used to define additional on-side offset to the menu's final position.
  final double menuOffset;

  /// A scroll controller that can be used to control the scrolling of the
  /// [items] in the menu.
  final ScrollController? scrollController;

  @override
  final String barrierLabel;

  @override
  Animation<double> createAnimation() => CurvedAnimation(
    parent: super.createAnimation(),
    curve: AnimationUtils.kCurve,
    reverseCurve: AnimationUtils.kCurveReverse,
  );

  @override
  Duration get transitionDuration => AnimationUtils.kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return MenuConfig(
      hasLeading: hasLeading,
      child: RoutePulldownMenu(
        scrollController: scrollController,
        items: items.toList(),
        routeTheme: routeTheme,
        animation: animation,
        alignment: alignment,
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final mediaQuery = MediaQuery.of(context);

    return SwipeRegion(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        child: CustomSingleChildLayout(
          delegate: _PopupMenuRouteLayout(
            buttonRect: buttonRect,
            padding: mediaQuery.padding,
            menuOffset: menuOffset,
          ),
          child: capturedThemes.wrap(child),
        ),
      ),
    );
  }
}

/// A predicted menu's horizontal position.
///
/// Is used by [PullDownMenuRoute.animationAlignment]
enum _MenuHorizontalPosition {
  /// The button's left side is located closer to the left side of the screen
  /// than the button's right side to the right side of the screen.
  left,

  /// The button's right side is located closer to the right side of the screen
  /// than the button's left side to the left side of the screen.
  right,

  /// Both horizontal button's sides are located in an allowed screen zone
  /// around center.
  center;

  /// Returns a [_MenuHorizontalPosition] for provided screen [size] and a
  /// [buttonRect].
  static _MenuHorizontalPosition get(Size size, Rect buttonRect) {
    final leftPosition = buttonRect.left;
    final rightPosition = buttonRect.right;

    final width = size.width;
    final widthCenter = width / 2;

    // Allowed threshold of screen side (left / right) for the menu to be opened
    // using "centered" alignment.
    // Based on native comparison with iOS 16 Simulator.
    const threshold = 0.2744;

    final leftCenteredThreshold = widthCenter * (1 - threshold);
    final rightCenteredThreshold = widthCenter * threshold + widthCenter;

    if (buttonRect.center.dx == widthCenter ||
        (leftPosition >= leftCenteredThreshold &&
            rightPosition <= rightCenteredThreshold)) {
      return _MenuHorizontalPosition.center;
    } else if (leftPosition < width - rightPosition) {
      return _MenuHorizontalPosition.left;
    } else {
      return _MenuHorizontalPosition.right;
    }
  }
}
