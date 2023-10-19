import 'package:flutter/material.dart';
import 'package:get/get.dart';

// String backendUrl = "https://bolebyjoe.up.railway.app/api/v1";
// String backendUrl2 = "https://bolebyjoe.up.railway.app/api/v2";
String backendUrl = "https://curious-red-cygnet.cyclic.app/api/v1";
String backendUrl2 = "https://curious-red-cygnet.cyclic.app/api/v2";
// String backendUrl = "http://localhost:7000/api/v1";
// String backendUrl2 = "http://localhost:7000/api/v2";

class Constants extends GetxController {
  // App version
  String appVersion = "1.1.13";
  // Colors
  Map<int, Color> defaultColor = {
    50: const Color(0xFFFFF3E0),
    100: const Color(0xFFFFE0B2),
    200: const Color(0xFFFFCC80),
    300: const Color(0xFFFFB74D),
    400: const Color(0xFFFFA726),
    500: Colors.orange,
    600: const Color(0xFFFB8C00),
    700: const Color(0xFFF57C00),
    800: const Color(0xFFEF6C00),
    900: const Color(0xFFE65100),
  };
  var navBarItemColor = Colors.grey;
  var primaryColor = Colors.orange;
  var primaryColor2 = Colors.orangeAccent;
  var whiteColor = Colors.white;
  var whiteColor2 = const Color.fromARGB(133, 255, 255, 255);
  var blackColor = Colors.black;
  var blackColor2 = const Color.fromARGB(255, 48, 48, 48);
  var blackColor3 = const Color.fromARGB(255, 82, 82, 82);
  var greyColor = const Color.fromARGB(153, 229, 229, 229);
  var greyColor2 = Colors.grey;
  var transparentColor = Colors.transparent;
  var transparentColor2 = const Color.fromARGB(147, 0, 0, 0);
  var overlayColor = const Color.fromARGB(125, 0, 0, 0);
  var successColor = Colors.green;
  var errorColor = Colors.red;
  var indigoColor = Colors.indigo;
  var purpleColor = Colors.purple;
  var pinkColor = Colors.pink;
  var brownColor = Colors.brown;
  var yellowColor = Colors.yellow;
  var amberColor = Colors.amber;
  var tealColor = Colors.teal;

  // Temporal values
  String? tempSelectCancelledOrder;
  String? nameOfLocation;
  String? modeOfPayment;
  String? estimatedDeliveryDay = "0";
  String? estimatedDeliveryTime;
  var toRemove = [];

  // Password recovery
  int? authCode;
}
