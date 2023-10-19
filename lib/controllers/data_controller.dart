// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

final constantValues = Get.find<Constants>();
class Packages {
  var image;
  var packageName;
  var price;
  var description;
  var text1;
  var text2;
  var text3;
  var color1;
  var color2;

  Packages(this.image, this.packageName, this.price, this.description,
      this.text1, this.text2, this.text3, this.color1, this.color2);
}

class PackageData {
  PackageData(this.context);
  late BuildContext context;

  late List<Packages> packages = [
    Packages(
        AssetImage("assets/images/quickie.png"),
        "Quickie",
        1000,
        "As a first-time customer, we love to encourage you to patronize our Quickie pack at 20% discount. We hope you enjoy your meal, and return for more.",
        "UP TO",
        "20% Off",
        "On your first order",
        constantValues.blackColor,
        constantValues.blackColor2),
    Packages(
        AssetImage("assets/images/basic.png"),
        "Basic",
        2200,
        "Love is in the air and we know it. That's why we cjhoose to spread love by offering you a 15% discount on our Basic pack. We're sure you'll enjoy this delicacy as a sign of our love to you. Happy valentine's day to you and yours!",
        "GET",
        "15% Off",
        "On our Valentine's pack",
        constantValues.tealColor,
        constantValues.indigoColor),
    Packages(
        AssetImage("assets/images/foodie.png"),
        "Foodie",
        4000,
        "Christ is risen, Hallelujah! In the spirit of the season we're offering you 10% dscount on our Foodie pack. We pray that every aspect of your life rises with Christ today. Happy Easter to you!",
        "GRAB",
        "10% Off",
        "On our Easter pack",
        constantValues.yellowColor,
        constantValues.purpleColor),
    Packages(
        AssetImage("assets/images/family.png"),
        "Family",
        8000,
        "A King is born today beloveth! Grab our family pack for a whooping discount of 30% this christmas season in celebration of the birth of our Lord. Merry Christmas to you and yours!",
        "WHOOPING",
        "30% Off",
        "On our Christmas pack",
        constantValues.pinkColor,
        constantValues.tealColor),
  ];
}