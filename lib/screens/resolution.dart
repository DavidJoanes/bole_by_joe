import 'package:flutter/material.dart';

class Resolution extends StatefulWidget {
  const Resolution(
      {Key? key, required this.desktopScreen, required this.mixedScreen})
      : super(key: key);
  final Widget? desktopScreen;
  final Widget? mixedScreen;

  @override
  State<Resolution> createState() => _ResolutionState();
}

class _ResolutionState extends State<Resolution> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 800) {
        return widget.desktopScreen!;
      } else {
        return widget.mixedScreen!;
      }
    });
  }
}
