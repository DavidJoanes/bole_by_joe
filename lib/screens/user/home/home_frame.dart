// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
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
  var userInfo = GetStorage();
  late int currentIndex = 0;
  final tabs = [
    const Center(child: Home()),
    const Center(child: Order()),
    const Center(child: Profile()),
  ];
  final tabs2 = [
    const Center(child: Home()),
    const Center(child: Order()),
    const Center(child: Delivery()),
    const Center(child: Profile()),
  ];

  _fetchAllPacks() async {
    try {
      var response = await dio.post("$backendUrl2/all-packages");
      if (response.data["success"]) {
        setState(() {
          userInfo.write("allPackages", response.data["data"]);
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
    _restoreSignin();
    _loadHome();
    userInfo.writeIfNull("publicKey", "");
    userInfo.writeIfNull("loading", false);
    userInfo.writeIfNull("adminLoggedIn", false);
    userInfo.writeIfNull("userData", {});
    userInfo.writeIfNull("allPackages", []);
    userInfo.writeIfNull("bestPacks", []);
    userInfo.writeIfNull("normalPacks", []);
    userInfo.writeIfNull("searchResult", []);
    userInfo.writeIfNull("cart", []);
    userInfo.writeIfNull("tempItemsOrdered", []);
    userInfo.writeIfNull("selectedPackage", {});
    userInfo.writeIfNull("country", "Nigeria");
    userInfo.writeIfNull("province", "Rivers");
    userInfo.writeIfNull("city", "Port Harcourt");
    userInfo.writeIfNull("isDarkTheme", false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return userInfo.read("loading")
        ? Center(
            child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.4),
            child: LoadingAnimationWidget.fourRotatingDots(
              color: constantValues.primaryColor,
              size: 100,
            ),
          ))
        : Scaffold(
            body: userInfo.read("userData")["accounttype"] != "dispatcher"
                ? tabs[currentIndex]
                : tabs2[currentIndex],
            bottomNavigationBar: userInfo.read("userData")["accounttype"] !=
                    "dispatcher"
                ? FancyBottomBar(
                    selectedIndex: currentIndex,
                    type: FancyType.FancyV1,
                    items: [
                      FancyItem(
                        textColor: constantValues.primaryColor,
                        title: 'Home',
                        icon: const Icon(Icons.home_outlined),
                      ),
                      FancyItem(
                        textColor: constantValues.navBarItemColor,
                        title: 'Orders',
                        icon: const Icon(Icons.shopping_cart_checkout_outlined),
                      ),
                      FancyItem(
                        textColor: constantValues.navBarItemColor,
                        title: 'Profile',
                        icon: const Icon(Icons.account_circle_outlined),
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
                        icon: const Icon(Icons.home_outlined),
                      ),
                      FancyItem(
                        textColor: constantValues.navBarItemColor,
                        title: 'Orders',
                        icon: const Icon(Icons.shopping_cart_checkout_outlined),
                      ),
                      FancyItem(
                        textColor: constantValues.navBarItemColor,
                        title: 'Delivery',
                        icon: const Icon(Icons.delivery_dining_outlined),
                      ),
                      FancyItem(
                        textColor: constantValues.navBarItemColor,
                        title: 'Profile',
                        icon: const Icon(Icons.account_circle_outlined),
                      ),
                    ],
                    onItemSelected: (index) {
                      setState(() {
                        currentIndex = index;
                        constantValues.navBarItemColor =
                            constantValues.primaryColor;
                      });
                    },
                  ),
          );
  }

  _loadHome() async {
    if (userInfo.read("allPackages").isEmpty) {
      setState(() {
        userInfo.write("loading", true);
      });
      await _fetchAllPacks();
      setState(() {
        userInfo.write("loading", false);
      });
    }
  }

  _restoreSignin() async {
    if (userInfo.read("userData").isNotEmpty) {
      try {
        Map<String, String> retrievedHeader = {
          "access-token": userInfo.read("userData")["token"],
        };
        var response1 = await dio.post(
          "$backendUrl/validate",
          data: {},
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: retrievedHeader),
        );
        if (response1.data["success"]) {
          var response2 = await dio.post(
            "$backendUrl/restore-signin",
            data: {"email": response1.data["data"]["user_id"]},
          );
          setState(() {
            userInfo.write("adminLoggedIn", false);
            userInfo.write("publicKey", response2.data["pk"]);
            userInfo.write("userData", response2.data["data"]);
          });
        }
      } on DioError catch (error) {
        setState(() {
          // userInfo.write("userData", {});
          context.goNamed("signin");
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    }
  }
}
