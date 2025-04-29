part of 'route.dart';

/// Minimum space from horizontal screen edges for the pull-down menu to be
/// rendered from.
const double _kMenuScreenPadding = 8;

/// Positioning and size of the menu on the screen.
@immutable
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  const _PopupMenuRouteLayout({
    required this.padding,
    required this.avoidBounds,
    required this.buttonRect,
    required this.menuOffset,
    required this.menuSize,
  });

  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Rect buttonRect;
  final double menuOffset;
  final Size menuSize;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tight(menuSize);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final childWidth = childSize.width;
    final horizontalPosition = _MenuHorizontalPosition.get(size, buttonRect);

    final x = switch (horizontalPosition) {
      _MenuHorizontalPosition.right =>
        buttonRect.right - childWidth + menuOffset,
      _MenuHorizontalPosition.left => buttonRect.left - menuOffset,
      _MenuHorizontalPosition.center =>
        buttonRect.left + buttonRect.width / 2 - childWidth / 2,
    };

    final originCenter = buttonRect.center;
    final rect = Offset.zero & size;
    final subScreens = DisplayFeatureSubScreen.subScreensInBounds(
      rect,
      avoidBounds,
    );
    final subScreen = _PositionUtils.closestScreen(subScreens, originCenter);

    final dx = _PositionUtils.fitX(x, subScreen, childWidth, padding);
    final dy = _PositionUtils.fitY(
      buttonRect,
      subScreen,
      menuSize.height,
      padding,
    );

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(covariant _PopupMenuRouteLayout oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        menuSize != oldDelegate.menuSize;
  }
}

/// A set of utils to help calculating menu's position on screen.
@immutable
abstract class _PositionUtils {
  const _PositionUtils._();

  /// Returns closest screen for specific [point].
  static Rect closestScreen(Iterable<Rect> screens, Offset point) {
    var closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }

    return closest;
  }

  /// Returns the `y` a top left offset point for menu's container.
  static double fitY(
    Rect buttonRect,
    Rect screen,
    double menuHeight,
    EdgeInsets padding,
  ) {
    var y = buttonRect.top;
    final buttonHeight = buttonRect.height;

    final isEnoughBottomSpace =
        screen.height - padding.bottom - buttonRect.bottom >= menuHeight;

    final additionalPadding =
        buttonHeight < kMinInteractiveDimensionCupertino ? 5 : 0;

    !isEnoughBottomSpace
        ? y -= menuHeight + additionalPadding
        : y += buttonHeight + additionalPadding;

    return y;
  }

  /// Returns the `x` a top left offset point for menu's container.
  static double fitX(
    double wantedX,
    Rect screen,
    double childWidth,
    EdgeInsets padding,
  ) {
    final leftSafeArea = screen.left + _kMenuScreenPadding + padding.left;
    final rightSafeArea = screen.right - _kMenuScreenPadding - padding.right;

    if (wantedX < leftSafeArea) {
      return leftSafeArea;
    } else if (wantedX + childWidth > rightSafeArea) {
      return rightSafeArea - childWidth;
    }

    return wantedX;
  }
}
