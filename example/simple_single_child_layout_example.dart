import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Simple example for [CustomSingleChildLayout].
/// 
/// Run by https://dartpad.dev/

void main() {
  runApp(const CupertinoSheetApp());
}

class CupertinoSheetApp extends StatelessWidget {
  const CupertinoSheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(title: 'Cupertino Sheet', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 300,
              height: 300,
              color: Colors.amber,

              child: CustomSingleChildLayout(
                delegate: CenterWithOffsetDelegate(Offset(0, 0)),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red.withValues(alpha: 0.5),
                ),
              ),
            ),
            Container(
              width: 300,
              height: 300,
              color: Colors.green,

              child: CustomSingleChildLayout(
                delegate: CenterWithOffsetDelegate(Offset(40, 40)),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Container(color: Colors.orange.withValues(alpha: 0.5)),
                ),
              ),
            ),
            CustomSingleChildLayout(
              delegate: CenterWithOffsetDelegate(Offset(40, 40)),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Container(color: Colors.blue.withValues(alpha: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CenterWithOffsetDelegate extends SingleChildLayoutDelegate {
  final Offset offset;

  CenterWithOffsetDelegate(this.offset);

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(200, 200);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tight(Size(100, 100));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    print("size: $size, childSize: $childSize");
    // Center the child, then apply the offset
    return Offset(
      (size.width - childSize.width) / 2 + offset.dx,
      (size.height - childSize.height) / 2 + offset.dy,
    );
  }

  @override
  bool shouldRelayout(covariant CenterWithOffsetDelegate oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
