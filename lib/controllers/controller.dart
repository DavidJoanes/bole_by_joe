// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool adminLoggedIn = false;
String backendUrl = "https://bbj.up.railway.app/api/v1";
String backendUrl2 = "https://bbj.up.railway.app/api/v2";
// String backendUrl = "http://localhost:7000/api/v1";
// String backendUrl2 = "http://localhost:7000/api/v2";

class Constants extends GetxController {
  // Paystack key
  String publicKey = "";
  // App version
  String appVersion = "1.12";
  // Colors
  Map<int, Color> defaultColor = {
    50: Color(0xFFFFF3E0),
    100: Color(0xFFFFE0B2),
    200: Color(0xFFFFCC80),
    300: Color(0xFFFFB74D),
    400: Color(0xFFFFA726),
    500: Colors.orange,
    600: Color(0xFFFB8C00),
    700: Color(0xFFF57C00),
    800: Color(0xFFEF6C00),
    900: Color(0xFFE65100),
  };
  var navBarItemColor = Colors.grey;
  var primaryColor = Colors.orange;
  var primaryColor2 = Colors.orangeAccent;
  var whiteColor = Colors.white;
  var whiteColor2 = Color.fromARGB(133, 255, 255, 255);
  var blackColor = Colors.black;
  var blackColor2 = Color.fromARGB(255, 48, 48, 48);
  var blackColor3 = Color.fromARGB(255, 82, 82, 82);
  var greyColor = Color.fromARGB(153, 229, 229, 229);
  var greyColor2 = Colors.grey;
  var transparentColor = Colors.transparent;
  var transparentColor2 = Color.fromARGB(147, 0, 0, 0);
  var overlayColor = Color.fromARGB(125, 0, 0, 0);
  var successColor = Colors.green;
  var errorColor = Colors.red;
  var indigoColor = Colors.indigo;
  var purpleColor = Colors.purple;
  var pinkColor = Colors.pink;
  var brownColor = Colors.brown;
  var yellowColor = Colors.yellow;
  var tealColor = Colors.teal;

  // Temporal values
  bool loading = false;
  bool isDarkTheme = false;
  String? emailAddress;
  bool? rememberPassword = false;
  late var selectedPackage = {};
  var userData = {};
  var tempUserData = {};
  var orderOwnerData = {};
  var dispatcherData = {};
  var searchResult = [];
  var cart = [];
  var allPackages = [];
  var allOrders = [];
  var allAccounts = [];
  var allLocations = [];
  var allRefunds = [];
  var allDataLogs = [];
  var bestPacks = [];
  var normalPacks = [];
  var activeOrders = [];
  var completedOrders = [];
  var cancelledOrders = [];
  var tempItemsOrdered = [];
  var activeDeliveryRequests = [];
  var completedDeliveryRequests = [];
  var itemsOrdered = [];
  var myLocations = [];
  var refundHistory = [];

  String country = "Nigeria";
  String province = "Rivers";
  String city = "Port Harcourt";
  String? tempSelectCancelledOrder;
  String? nameOfLocation;
  String? modeOfPayment;
  String? estimatedDeliveryDay = "0";
  String? estimatedDeliveryTime;
  var toRemove = [];

  // Password recovery
  int? authCode;
}
