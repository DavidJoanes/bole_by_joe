// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/controller.dart';

class Background extends StatelessWidget {
  final double height;
  final Widget child;
  const Background({
    Key? key,
    required this.height,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constantValues = Get.find<Constants>();
    Size size = MediaQuery.of(context).size;
    final fontStyle1b = GoogleFonts.jost(
        textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w300));
    return Container(
      color: constantValues.greyColor,
      width: double.infinity,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 50,
            child: Image.asset(
              "assets/icons/center.png",
              width: size.width * 0.5,
            ),
          ),
          Positioned(
            bottom: 2,
            left: 2,
            child: Text("Version: ${constantValues.appVersion}",
                style: fontStyle1b),
          ),
          Positioned(
            bottom: -size.height * 0.03,
            right: -size.width * 0.05,
            child: Image.asset(
              "assets/icons/bottom.png",
              width: size.width * 0.2,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
