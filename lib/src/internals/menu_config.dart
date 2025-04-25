import 'package:flutter/cupertino.dart';

import '../items/entry.dart';
import '../items/item.dart';

class MenuConfig extends InheritedWidget {
  /// Creates [MenuConfig].
  const MenuConfig({super.key, required super.child, required this.hasLeading});

  /// Whether the pull-down menu has any [PullDownMenuItem]s with leading
  /// widget such as chevron.
  final bool hasLeading;

  /// Used to determine if the menu has any items with a leading widget.
  static bool menuHasLeading(List<PullDownMenuEntry> items) => items
      .whereType<PulldownMenuItem>()
      .any((element) => element.selected != null);

  /// Returns a [bool] value indicating whether menu has any
  /// [PullDownMenuItem]s  with leading widget from the closest [MenuConfig]
  /// ancestor.
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuConfig>()!.hasLeading;

  @override
  bool updateShouldNotify(MenuConfig oldWidget) =>
      hasLeading != oldWidget.hasLeading;
}
