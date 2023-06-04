import 'package:flutter/material.dart';

class CenterTimer extends StatefulWidget {
  const CenterTimer({super.key});

  @override
  State<StatefulWidget> createState() => _CenterTimerState();
}

// TODO: Add controller to change colors
class _CenterTimerState extends State<CenterTimer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => print("Holding"),
        onTapUp: (_) => print("Stopped holding"),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Padding(padding: EdgeInsets.all(32), child: Text("5.55")),
        ));
  }
}
