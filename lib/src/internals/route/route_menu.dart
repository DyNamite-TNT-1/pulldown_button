import 'package:flutter/cupertino.dart';

import '../../items/entry.dart';
import '../../pulldown_button.dart';
import '../../theme/route_theme.dart';
import '../content_size_category.dart';
import '../menu.dart';
import '../utils/animation.dart';
import 'route.dart';

///  Pull-down menu displayed by [PulldownButton].
@immutable
class RoutePulldownMenu extends StatelessWidget {
  /// Creates [RoutePulldownMenu].
  const RoutePulldownMenu({
    super.key,
    required this.items,
    required this.routeTheme,
    required this.alignment,
    required this.animation,
    required this.scrollController,
  });

  /// Items to show in the menu.
  final List<PullDownMenuEntry> items;

  /// A per-menu custom theme.
  ///
  /// Final theme is resolved using [PullDownMenuRouteTheme.resolve].
  final PullDownMenuRouteTheme? routeTheme;

  /// An animation provided by [PulldownMenuRoute] for scale, fade, and size
  /// transitions.
  final Animation<double> animation;

  /// The point menu scales from.
  final Alignment alignment;

  /// Is used to define the initial scroll offset of menu's body.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuRouteTheme.resolve(
      context,
      routeTheme: routeTheme,
    );

    final shadowTween = DecorationTween(
      begin: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.shadow!.color.withValues(alpha: 0),
            blurRadius: theme.shadow!.blurRadius,
            spreadRadius: theme.shadow!.spreadRadius,
          ),
        ],
      ),
      end: BoxDecoration(boxShadow: [theme.shadow!]),
    );

    final clampedAnimation = ClampedAnimation(animation);

    final isInAccessibilityMode = TextUtils.isInAccessibilityMode(context);

    return ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: DecoratedBoxTransition(
        decoration: AnimationUtils.shadowTween
            .animate(clampedAnimation)
            .drive(shadowTween),
        child: FadeTransition(
          opacity: clampedAnimation,
          child: MenuDecoration(
            backgroundColor: theme.backgroundColor!,
            borderRadius: theme.borderRadius!,
            child: FadeTransition(
              opacity: clampedAnimation,
              child: AnimatedMenuContainer(
                constraints: BoxConstraints.tightFor(
                  width:
                      isInAccessibilityMode
                          ? theme.accessibilityWidth
                          : theme.width,
                ),
                child: SizeTransition(
                  axisAlignment: -1,
                  sizeFactor: clampedAnimation,
                  child: MenuBody(
                    scrollController: scrollController,
                    items: items,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
