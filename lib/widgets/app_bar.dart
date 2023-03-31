// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/controller.dart';

final constantValues = Get.find<Constants>();

AppBar primaryAppBar(BuildContext context, String name) {
  return AppBar(
    elevation: 0,
    leading: null,
    title: Text(
      name,
      style: GoogleFonts.poppins(
          textStyle: TextStyle()),
    ),
  );
}

AppBar secondaryAppBar(BuildContext context, String name, Function onPressed) {
  return AppBar(
    elevation: 0,
    leading: BackButton(
      onPressed: () {
        onPressed();
      },
    ),
    title: Text(
      name,
      style: GoogleFonts.poppins(
          textStyle: TextStyle()),
    ),
  );
}

AppBar secondaryAppBar2(BuildContext context, String name, var iconButton) {
  return AppBar(
    elevation: 0,
    leading: null,
    title: Text(
      name,
      style: GoogleFonts.poppins(
          textStyle: TextStyle()),
    ),
    actions: [
      iconButton,
      SizedBox(width: 15),
    ],
  );
}

BottomAppBar bottomAppBar(BuildContext context, Widget child) {
  return BottomAppBar(
    child: child,
  );
}
