// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, prefer_const_constructors

import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/controller.dart';

final constantValues = Get.find<Constants>();

class CustomBottoNavigationBarUser extends StatefulWidget {
  CustomBottoNavigationBarUser({super.key, required this.tabs, required this.currentindex});
  var tabs;
  late int currentindex;

  @override
  State<CustomBottoNavigationBarUser> createState() =>
      _CustomBottoNavigationBarUserState();
}

class _CustomBottoNavigationBarUserState extends State<CustomBottoNavigationBarUser> {
  @override
  Widget build(BuildContext context) {
    return FancyBottomBar(
      selectedIndex: widget.currentindex,
      type: FancyType.FancyV1,
      items: [
        FancyItem(
          textColor: constantValues.primaryColor,
          title: 'Home',
          icon: Icon(Icons.home_outlined),
        ),
        FancyItem(
          textColor: constantValues.navBarItemColor,
          title: 'Order',
          icon: Icon(Icons.shopping_cart_outlined),
        ),
        FancyItem(
          textColor: constantValues.navBarItemColor,
          title: 'Profile',
          icon: Icon(Icons.account_circle_outlined),
        ),
      ],
      onItemSelected: (index) {
        setState(() {
          widget.currentindex = index;
          constantValues.navBarItemColor = constantValues.primaryColor;
        });
      },
    );
  }
}

class CustomBottomNavigationBarDispatch extends StatefulWidget {
  CustomBottomNavigationBarDispatch({super.key, required this.tabs, required this.currentindex});
  var tabs;
  late int currentindex;

  @override
  State<CustomBottomNavigationBarDispatch> createState() =>
      _CustomBottomNavigationBarDispatchState();
}

class _CustomBottomNavigationBarDispatchState
    extends State<CustomBottomNavigationBarDispatch> {
  @override
  Widget build(BuildContext context) {
    return FancyBottomBar(
      selectedIndex: widget.currentindex,
      type: FancyType.FancyV1,
      items: [
        FancyItem(
          textColor: constantValues.primaryColor,
          title: 'Home',
          icon: Icon(Icons.home_outlined),
        ),
        FancyItem(
          textColor: constantValues.navBarItemColor,
          title: 'Order',
          icon: Icon(Icons.shopping_cart_outlined),
        ),
        FancyItem(
          textColor: constantValues.navBarItemColor,
          title: 'Delivery',
          icon: Icon(Icons.delivery_dining_outlined),
        ),
        FancyItem(
          textColor: constantValues.navBarItemColor,
          title: 'Profile',
          icon: Icon(Icons.account_circle_outlined),
        ),
      ],
      onItemSelected: (index) {
        setState(() {
          widget.currentindex = index;
          constantValues.navBarItemColor = constantValues.primaryColor;
        });
        // if (index == 0) {
        //   context.goNamed('home');
        // } else if (index == 1) {
        //   context.goNamed('orders');
        // } else if (index == 2) {
        //   context.goNamed('delivery');
        // } else {
        //   context.goNamed('profile');
        // }
      },
    );
  }
}
