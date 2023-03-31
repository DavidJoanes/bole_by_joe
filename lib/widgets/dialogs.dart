// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/controller.dart';

final constantValues = Get.find<Constants>();

class Dialog1 extends StatefulWidget {
  Dialog1({
    Key? key,
    required this.title,
  }) : super(key: key);
  final Widget title;

  @override
  State<Dialog1> createState() => _Dialog1State();
}

class _Dialog1State extends State<Dialog1> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      scrollable: true,
    );
  }
}

class Dialog1b extends StatefulWidget {
  Dialog1b({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);
  final Widget title;
  final String message;

  @override
  State<Dialog1b> createState() => _Dialog1bState();
}

class _Dialog1bState extends State<Dialog1b> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: Text(widget.message),
      scrollable: true,
    );
  }
}

class Dialog2 extends StatefulWidget {
  Dialog2(
      {Key? key,
      required this.title,
      required this.widget,
      required this.buttonText,
      required this.onPressed})
      : super(key: key);
  final Widget title;
  final Widget widget;
  final String buttonText;
  final Function onPressed;

  @override
  State<Dialog2> createState() => _Dialog2State();
}

class _Dialog2State extends State<Dialog2> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Stack(children: [
        widget.title,
        Positioned(
            right: 2,
            top: 0,
            child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  context.pop();
                }))
      ]),
      content: widget.widget,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            widget.onPressed();
          },
          child: Text(widget.buttonText,
              style: TextStyle(color: constantValues.primaryColor)),
        )
      ],
    );
  }
}

class Dialog2b extends StatefulWidget {
  Dialog2b({
    Key? key,
    required this.title,
    required this.widget,
    required this.buttons,
  }) : super(key: key);
  final Widget title;
  final Widget widget;
  final List<Widget> buttons;

  @override
  State<Dialog2b> createState() => _Dialog2bState();
}

class _Dialog2bState extends State<Dialog2b> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: widget.title,
      content: widget.widget,
      actions: widget.buttons,
    );
  }
}
