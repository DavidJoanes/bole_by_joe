import 'package:bolebyjoanes/screens/resolution.dart';
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
          textStyle: const TextStyle()),
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
          textStyle: const TextStyle()),
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
          textStyle: const TextStyle()),
    ),
    actions: [
      iconButton,
      const SizedBox(width: 15),
    ],
  );
}

BottomAppBar bottomAppBar(BuildContext context, Widget child) {
    Size size = MediaQuery.of(context).size;
  return BottomAppBar(
    child: Resolution(desktopScreen:  Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width*0.1), child: child), mixedScreen: child),
  );
}
