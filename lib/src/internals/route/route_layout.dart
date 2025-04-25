part of 'route.dart';

/// Minimum space from horizontal screen edges for the pull-down menu to be
/// rendered from.
const double _kMenuScreenPadding = 8;

/// Positioning and size of the menu on the screen.
@immutable
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  const _PopupMenuRouteLayout({
    required this.padding,

    required this.buttonRect,
    required this.menuOffset,
  });

  final EdgeInsets padding;

  final Rect buttonRect;
  final double menuOffset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final biggest = constraints.biggest;

    final height = buttonRect.top - padding.top;

    return BoxConstraints.loose(
      Size(biggest.width, height),
    ).deflate(const EdgeInsets.symmetric(horizontal: _kMenuScreenPadding));
  }

  // @override
  // Offset getPositionForChild(Size size, Size childSize) {
  //   final childWidth = childSize.width;
  //   print("childWidth: $childWidth, childHeight: ${childSize.height}");

  //   final horizontalPosition = _MenuHorizontalPosition.get(size, buttonRect);

  //   final x = switch (horizontalPosition) {
  //     _MenuHorizontalPosition.right =>
  //       buttonRect.right - childWidth + menuOffset,
  //     _MenuHorizontalPosition.left => buttonRect.left - menuOffset,
  //     _MenuHorizontalPosition.center =>
  //       buttonRect.left + buttonRect.width / 2 - childWidth / 2
  //   };

  //   final originCenter = buttonRect.center;
  //   final rect = Offset.zero & size;
  //   final subScreens =
  //       DisplayFeatureSubScreen.subScreensInBounds(rect, avoidBounds);
  //   final subScreen = _PositionUtils.closestScreen(subScreens, originCenter);

  //   final dx = _PositionUtils.fitX(x, subScreen, childWidth, padding);
  //   final dy = _PositionUtils.fitY(
  //     buttonRect,
  //     subScreen,
  //     // childSize.height,
  //     88,
  //     padding,
  //     menuPosition,
  //   );

  //   return Offset(dx, dy);
  // }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) =>
      padding != oldDelegate.padding || buttonRect != oldDelegate.buttonRect;
}