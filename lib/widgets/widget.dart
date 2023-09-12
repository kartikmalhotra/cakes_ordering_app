import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/config/theme/theme.dart';

class AppCircularProgressIndicator extends StatefulWidget {
  final double? value;
  final Color? color;

  const AppCircularProgressIndicator({
    Key? key,
    this.value,
    this.color = LightAppColors.primary,
  }) : super(key: key);

  @override
  State<AppCircularProgressIndicator> createState() =>
      _AppCircularProgressIndicatorState();
}

class _AppCircularProgressIndicatorState
    extends State<AppCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          CircularProgressIndicator(color: widget.color, value: widget.value),
    );
  }
}
