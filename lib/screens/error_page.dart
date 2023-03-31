// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../screens/resolution.dart';
import '../controllers/controller.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  final constantValues = Get.find<Constants>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Resolution(
                desktopScreen: desktopScreen(context),
                mixedScreen: mixedScreen(context))),
      ),
    );
  }

  Widget desktopScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/error1.jpg"),
            fit: BoxFit.fitWidth,
          )),
        ),
        Text("Sorry mate! There's nothing here.",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              color: constantValues.whiteColor,
              fontWeight: FontWeight.w800,
            ))),
      ],
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/error2.jpg"),
            fit: BoxFit.fitWidth,
          )),
        ),
        Text("Sorry mate! There's nothing here.",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              color: constantValues.whiteColor,
              fontWeight: FontWeight.w800,
            ))),
      ],
    );
  }
}
