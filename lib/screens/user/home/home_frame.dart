// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../screens/user/home/profile.dart';
import '../../../controllers/controller.dart';
import 'delivery.dart';
import 'home.dart';
import 'order.dart';

class HomeFrame extends StatefulWidget {
  const HomeFrame({super.key});

  @override
  State<HomeFrame> createState() => _HomeFrameState();
}

class _HomeFrameState extends State<HomeFrame> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  late int currentIndex = 0;
  final tabs = [
    Center(child: Home()),
    Center(child: Order()),
    Center(child: Profile()),
  ];
  final tabs2 = [
    Center(child: Home()),
    Center(child: Order()),
    Center(child: Delivery()),
    Center(child: Profile()),
  ];

  _fetchAllPacks() async {
      try {
        var response = await dio.post("$backendUrl2/all-packages");
        if (response.data["success"]) {
          setState(() {
            constantValues.allPackages = response.data["data"];
          });
        }
      } on DioError catch (error) {
        return Fluttertoast.showToast(
          msg: error.response!.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
  }

  @override
  void initState() {
    _loadHome();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return 
    constantValues.loading
        ? Center(
            child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.4),
            child: LoadingAnimationWidget.fourRotatingDots(
              color: constantValues.primaryColor,
              size: 100,
            ),
          ))
        : 
        Scaffold(
            body: constantValues.userData["accounttype"] != "dispatcher"
                ? tabs[currentIndex]
                : tabs2[currentIndex],
            bottomNavigationBar: constantValues.userData["accounttype"] != "dispatcher"
                ? FancyBottomBar(
                    selectedIndex: currentIndex,
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
                        icon: Icon(Icons.shopping_cart_checkout_outlined),
                      ),
                      FancyItem(
                        textColor: constantValues.navBarItemColor,
                        title: 'Profile',
                        icon: Icon(Icons.account_circle_outlined),
                      ),
                    ],
                    onItemSelected: (index) {
                      setState(() {
                        currentIndex = index;
                        constantValues.navBarItemColor =
                            constantValues.primaryColor;
                      });
                    },
                  )
                : FancyBottomBar(
                    selectedIndex: currentIndex,
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
                        icon: Icon(Icons.shopping_cart_checkout_outlined),
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
                        currentIndex = index;
                        constantValues.navBarItemColor =
                            constantValues.primaryColor;
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
                  ),
          );
  }

  _loadHome() async {
    if (constantValues.allPackages.isEmpty) {
      setState(() {
        constantValues.loading = true;
      });
      await _fetchAllPacks();
      setState(() {
        constantValues.loading = false;
      });
    }
  }
}
