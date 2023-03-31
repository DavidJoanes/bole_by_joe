// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/controller.dart';

final constantValues = Get.find<Constants>();

class TextFieldContainer extends StatelessWidget {
  final double width;
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.width,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: width,
      decoration: BoxDecoration(
        color: constantValues.isDarkTheme
            ? constantValues.blackColor3
            : constantValues.greyColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class TextFieldContainer2 extends StatelessWidget {
  final double width;
  final Widget child;
  const TextFieldContainer2({
    Key? key,
    required this.width,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: width,
      decoration: BoxDecoration(
        color: constantValues.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class TextFieldContainer3 extends StatelessWidget {
  final Widget child;
  final double width;
  final double horizontalGap;
  final double verticalGap;
  final double radius;
  const TextFieldContainer3({
    Key? key,
    required this.child,
    required this.width,
    required this.horizontalGap,
    required this.verticalGap,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalGap),
      padding: EdgeInsets.symmetric(
          horizontal: horizontalGap, vertical: verticalGap),
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

class TextFieldContainer4 extends StatelessWidget {
  final double width;
  final Widget child;
  const TextFieldContainer4({
    Key? key,
    required this.width,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: width,
      decoration: BoxDecoration(
        color: constantValues.greyColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
