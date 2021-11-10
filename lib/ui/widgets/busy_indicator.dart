import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/app_colors.dart';

class BusyIndicator extends StatefulWidget {
  final Color color;
  const BusyIndicator({this.color = busyButtonColor});

  @override
  _BusyIndicatorState createState() => _BusyIndicatorState();
}

class _BusyIndicatorState extends State<BusyIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(
          widget.color,
        ),
      ),
    );
  }
}
