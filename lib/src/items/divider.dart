import 'package:flutter/material.dart';
import '../../pulldown_button.dart';
import '../theme/divider_theme.dart';

const double _kMenuDividerHeight = 0;
const double _kMenuLargeDividerHeight = 8;

/// A horizontal divider for a cupertino style pull-down menu.
///
/// This widget adapts the [Divider] for use in pull-down menus.
@immutable
class PullDownMenuDivider extends StatelessWidget implements PullDownMenuEntry {
  /// Creates a horizontal divider for a pull-down menu.
  @Deprecated(
    'Can be safely removed as the pull-down menu now automatically '
    'inserts dividers when needed. '
    'This feature was deprecated after v0.9.0.',
  )
  const PullDownMenuDivider({
    super.key,
    this.color,
  }) : _isLarge = false;

  /// Creates a large horizontal divider for a pull-down menu.
  const PullDownMenuDivider.large({
    super.key,
    this.color,
  }) : _isLarge = true;

  /// The color of the divider.
  ///
  /// If this property is null, then, depending on the constructor,
  /// [PullDownMenuDividerTheme.dividerColor] or
  /// [PullDownMenuDividerTheme.largeDividerColor] from
  /// [PullDownButtonTheme.dividerTheme] is used.
  ///
  /// If that's null, then defaults from [PullDownMenuDividerTheme.defaults] are
  /// used.
  final Color? color;

  /// Whether this [PullDownMenuDivider] is large or not.
  final bool _isLarge;

  /// The height and thickness of the divider entry.
  ///
  /// Can be 0 pixels ([PullDownMenuDivider]) or 8 pixels
  /// ([PullDownMenuDivider.large]) depending on the constructor.
  double get height =>
      _isLarge ? _kMenuLargeDividerHeight : _kMenuDividerHeight;

  /// Helper method that simplifies separation of pull-down menu items.
  @Deprecated(
    'Can be safely removed as the pull-down menu now automatically '
    'inserts dividers when needed. '
    'This feature was deprecated after v0.9.0.',
  )
  static List<PullDownMenuEntry> wrapWithDivider(
    List<PullDownMenuEntry> items,
  ) =>
      items;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuDividerTheme.resolve(context);

    final divider =
        color ?? (_isLarge ? theme.largeDividerColor : theme.dividerColor)!;

    return Divider(
      height: height,
      thickness: height,
      color: divider,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(height);
}
