// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../controllers/data_controller.dart';
import '../../../controllers/theme_modifier.dart';
import '../../../widgets/bestpackages.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/all_packages.dart';
import '../../../widgets/profile_picture.dart';
import '../../resolution.dart';

final globalBucket = PageStorageBucket();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(userInfo.read("searchResult"));
  int subTotal = 0;
  var bgImages = <String>[
    "https://images.unsplash.com/photo-1635013973782-d6577fc8cb0c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80",
    "https://images.unsplash.com/photo-1667308888281-8030a5f827c5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjZ8fHBsYW50YWlufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60",
    "https://images.unsplash.com/photo-1501812271548-22b85c830741?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGxhbnRhaW58ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60",
  ];
  late int randomIndex = Random().nextInt(bgImages.length);

  _calculateTotal() {
    subTotal = 0;
    if (userInfo.read("cart").isNotEmpty) {
      for (var item in userInfo.read("cart")) {
        setState(() {
          subTotal += item["price"] as int;
        });
      }
    } else {
      setState(() {
        subTotal = 0;
      });
    }
  }

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  _fetchDiscountedPacks() async {
    try {
      var response = await dio.post("$backendUrl/discounted-packages");
      if (response.data["success"]) {
        userInfo.write("bestPacks", response.data["data"]);
      }
    } on DioError catch (error) {
      return Fluttertoast.showToast(
        msg: error.response!.data["message"],
        toastLength: Toast.LENGTH_LONG,
        webPosition: "center",
      );
    }
  }

  _fetchNormalPacks() async {
    try {
      var response = await dio.post("$backendUrl/normal-packages");
      if (response.data["success"]) {
        userInfo.write("normalPacks", response.data["data"]);
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
    _fetchDiscountedPacks();
    _fetchNormalPacks();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    userInfo.read("searchResult").clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    final fontStyle1 = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor, fontWeight: FontWeight.w400));
    final fontstyle1 = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontstyle1b = GoogleFonts.poppins(
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400));
    return PageStorage(
      bucket: globalBucket,
      child: Scaffold(
        appBar: userInfo.read("userData").isEmpty
            ? AppBar(
                title: Container(
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(userInfo.read("isDarkTheme")
                                ? "assets/icons/logo3b.png"
                                : "assets/icons/logob.png")))),
                centerTitle: true,
                actions: [
                  IconButton(
                    tooltip: "Cart",
                    icon: Stack(
                      children: [
                        const Icon(Icons.shopping_basket_outlined),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Text(
                              "${userInfo.read("cart").length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: constantValues.errorColor),
                            ))
                      ],
                    ),
                    onPressed: () {
                      context.goNamed("cartalog");
                    },
                  ),
                  const SizedBox(width: 5),
                ],
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(size.width * 0.02),
                    child: TextScroll(
                      "Hey there! Welcome to Bole by Joanes, the Numero Uno of PITAKWA bole. We'll be updating you with the latest information via this scroll.",
                      intervalSpaces: (size.width * 0.26).round(),
                      style: fontStyle1,
                      velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                    )),
              )
            : AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ProfilePicture(
                    image:
                        userInfo.read("userData")["profileimage"]["url"] != ""
                            ? userInfo.read("userData")["profileimage"]["url"]
                            : "assets/icons/user.png",
                    radius: 15,
                    onClicked: () {},
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello", style: fontstyle1b),
                    Text(
                      (userInfo.read("userData")["lastname"] as String)
                          .toTitleCase(),
                      style: fontstyle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    tooltip: "Cart",
                    icon: Stack(
                      children: [
                        const Icon(Icons.shopping_basket_outlined),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Text(
                              "${userInfo.read("cart").length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: constantValues.errorColor),
                            ))
                      ],
                    ),
                    onPressed: () {
                      context.goNamed("cartalog");
                    },
                  ),
                  const SizedBox(width: 15),
                ],
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(size.width * 0.02),
                    child: TextScroll(
                      "Hey there! Welcome to Bole by Joanes, the Numero Uno of PITAKWA bole. We'll be updating you with the latest information via this scroll.",
                      intervalSpaces: (size.width * 0.26).round(),
                      style: fontStyle1,
                      velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                    )),
              ),
        floatingActionButton: CircleAvatar(
          radius: 20,
          backgroundColor: constantValues.blackColor,
          child: IconButton(
            tooltip: userInfo.read("isDarkTheme")
                  ? "Turn on" : "Turn off",
            icon: Icon(
              userInfo.read("isDarkTheme")
                  ? Icons.lightbulb_circle
                  : Icons.lightbulb_circle_outlined,
            ),
            onPressed: () {
              setState(() {
                userInfo.write("isDarkTheme", !userInfo.read("isDarkTheme"));
              });
              themeChanger.setTheme(userInfo.read("isDarkTheme")
                  ? ThemeData.dark()
                  : ThemeData(
                      primarySwatch: MaterialColor(
                          0xFFFFA726, constantValues.defaultColor),
                      brightness: Brightness.light));
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Resolution(
                  desktopScreen: desktopScreen(context),
                  mixedScreen: mixedScreen(context))),
        ),
      ),
    );
  }

  Widget customAppBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontstyle1 = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontstyle1b = GoogleFonts.poppins(
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300));
    return userInfo.read("userData").isEmpty
        ? Card(
            elevation: 2,
            child: ListTile(
              title: Container(
                  height: size.height * 0.03,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(userInfo.read("isDarkTheme")
                              ? "assets/icons/logo3b.png"
                              : "assets/icons/logob.png")))),
              trailing: IconButton(
                tooltip: "Cart",
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_basket_outlined,
                        color: constantValues.primaryColor),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: Text(
                          "${userInfo.read("cart").length}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: constantValues.successColor),
                        ))
                  ],
                ),
                onPressed: () {
                  context.goNamed("cartalog");
                },
              ),
            ),
          )
        : Card(
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: ProfilePicture(
                    image:
                        userInfo.read("userData")["profileimage"]["url"] != ""
                            ? userInfo.read("userData")["profileimage"]["url"]
                            : "assets/icons/user.png",
                    radius: 15,
                    onClicked: () {},
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello", style: fontstyle1b),
                      Text(
                        (userInfo.read("userData")["lastname"] as String)
                            .toTitleCase(),
                        style: fontstyle1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    tooltip: "Cartalog",
                    icon: Stack(
                      children: [
                        Icon(Icons.shopping_basket_outlined,
                            color: constantValues.primaryColor),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Text(
                              "${userInfo.read("cart").length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: constantValues.successColor),
                            ))
                      ],
                    ),
                    onPressed: () {
                      context.goNamed("cartalog");
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget desktopScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PackageData object = PackageData(context);
    final fontStyle1 = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w400));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                child: Stack(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          userInfo.read("isDarkTheme")
                              ? constantValues.greyColor2
                              : constantValues.primaryColor2,
                          BlendMode.modulate),
                      child: Container(
                        height: size.height * 0.4,
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(bgImages[randomIndex]))),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: size.height * 0.05),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: InputFieldA2(
                                controller: searchController,
                                width: size.width * 0.9,
                                title: "Search",
                                enabled: true,
                                hintIcon: IconButton(
                                  tooltip: "Search",
                                  icon: Icon(
                                    Icons.search_outlined,
                                    color: constantValues.primaryColor,
                                  ),
                                  onPressed: () async {
                                    await _search();
                                  },
                                )),
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.height * 0.02),
                          child: BestPackages(
                              object: userInfo.read("bestPacks"),
                              object2: object.packages,
                              isDesktop: true),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    AllPacks(
                      object: userInfo.read("normalPacks"),
                      isDesktop: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
            child: Column(
          children: [
            ListTile(
              title: Text("Cart", style: fontStyle1),
              trailing: IconButton(
                tooltip: "Info",
                icon: Icon(Icons.info_outline, color: constantValues.errorColor),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Swipe left to remove item from cart..")));
                },
              ),
            ),
            SizedBox(
              height: size.height,
              child: userInfo.read("cart").isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: userInfo.read("cart").length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01,
                              horizontal: size.width * 0.02),
                          child: Slidable(
                            key: ValueKey(index),
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _remove(index),
                                  backgroundColor: constantValues.errorColor,
                                  foregroundColor: constantValues.whiteColor,
                                  icon: Icons.delete,
                                  label: "remove",
                                ),
                              ],
                            ),
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                leading: ProfilePicture(
                                  radius: 20,
                                  image: userInfo.read("cart")[index]
                                      ["coverimage"]["url"],
                                  onClicked: () {},
                                ),
                                title: Text(
                                    (userInfo.read("cart")[index]["packagename"]
                                            as String)
                                        .toTitleCase(),
                                    style: fontStyle1),
                                subtitle: Text(
                                    "Qty: ${userInfo.read("cart")[index]["qty"]}"),
                                trailing: Text(
                                  "${currencyIcon(context).currencySymbol}${userInfo.read("cart")[index]["price"]}",
                                  style: fontStyle1,
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Text("Your cart is empty..", style: fontStyle1b)),
            )
          ],
        ))
      ]),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PackageData object = PackageData(context);
    return LayoutBuilder(builder: (BuildContext context, constraints) {
      return SizedBox(
        child: Column(
          children: [
            SizedBox(
              child: Stack(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        userInfo.read("isDarkTheme")
                            ? constantValues.greyColor2
                            : constantValues.primaryColor2,
                        BlendMode.modulate),
                    child: Container(
                      height: size.height * 0.4,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(bgImages[randomIndex]))),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: size.height * 0.05),
                      Form(
                        key: _formKey,
                        child: InputFieldA2(
                            controller: searchController,
                            width: size.width * 0.9,
                            title: "Search",
                            enabled: true,
                            hintIcon: IconButton(
                              tooltip: "Search",
                              icon: Icon(
                                Icons.search_outlined,
                                color: constantValues.primaryColor,
                              ),
                              onPressed: () async {
                                await _search();
                              },
                            )),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        child: BestPackages(
                            object: userInfo.read("bestPacks"),
                            object2: object.packages,
                            isDesktop: false),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  AllPacks(
                    object: userInfo.read("normalPacks"),
                    isDesktop: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  searchResults() {
    Size size = MediaQuery.of(context).size;
    final fontstyle1 = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontstyle1b = GoogleFonts.jost(
        textStyle: const TextStyle(fontWeight: FontWeight.w300));
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.05),
                child: ValueListenableBuilder(
                    valueListenable: results,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text("Search Results..", style: fontstyle1),
                          ),
                          SizedBox(height: size.height * 0.02),
                          userInfo.read("searchResult").isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.1),
                                  child: Center(
                                      child: Text("Nothing found...",
                                          style: fontstyle1b)),
                                )
                              : SizedBox(
                                  height: size.height * 0.3,
                                  width: size.width,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          userInfo.read("searchResult").length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.02,
                                              vertical: size.height * 0.01),
                                          child: Card(
                                            elevation: 4,
                                            child: ListTile(
                                              leading: ProfilePicture(
                                                radius: 20,
                                                image: userInfo.read(
                                                        "searchResult")[index]
                                                    ["coverimage"]["url"],
                                                onClicked: () {},
                                              ),
                                              title: Text(userInfo.read(
                                                      "searchResult")[index]
                                                  ["packagename"]),
                                              trailing:
                                                  const Icon(Icons.arrow_right),
                                              onTap: () async {
                                                if (userInfo.read(
                                                            "searchResult")[
                                                        index]["discount"] >
                                                    0) {
                                                  if (userInfo
                                                      .read("userData")
                                                      .isNotEmpty) {
                                                    try {
                                                      final email = userInfo
                                                              .read("userData")[
                                                          "email"];
                                                      var response = await dio.post(
                                                          "$backendUrl/check-for-package-eligibility",
                                                          data: {
                                                            "email": email,
                                                            "packagename": userInfo
                                                                        .read(
                                                                            "searchResult")[
                                                                    index]
                                                                ["packagename"],
                                                          });
                                                      if (response
                                                              .data["status"] ==
                                                          "eligible") {
                                                        setState(() {
                                                          userInfo.write(
                                                              "selectedPackage",
                                                              userInfo.read(
                                                                      "searchResult")[
                                                                  index]);
                                                        });
                                                        context.goNamed(
                                                          "package",
                                                          params: {
                                                            "name": (userInfo.read(
                                                                            "searchResult")[index]
                                                                        [
                                                                        "packagename"]
                                                                    as String)
                                                                .toLowerCase()
                                                          },
                                                        );
                                                      } else {
                                                        Navigator.of(context)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    response.data[
                                                                        "message"])));
                                                      }
                                                    } on DioError catch (error) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(error
                                                                      .response!
                                                                      .data[
                                                                  "message"])));
                                                    }
                                                  } else {
                                                    context.goNamed("signin");
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "You are required to be signed in to proceed to order this package!")));
                                                  }
                                                } else {
                                                  setState(() {
                                                    userInfo.write(
                                                        "selectedPackage",
                                                        userInfo.read(
                                                                "searchResult")[
                                                            index]);
                                                  });
                                                  context.goNamed(
                                                    "package",
                                                    params: {
                                                      "name": (userInfo.read(
                                                                          "searchResult")[
                                                                      index][
                                                                  "packagename"]
                                                              as String)
                                                          .toLowerCase()
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                        ],
                      );
                    }),
              ),
            ),
          );
        });
  }

  _search() {
    userInfo.read("searchResult").clear();
    final form = _formKey.currentState!;
    if (form.validate()) {
      for (var item in userInfo.read("allPackages")) {
        if (searchController.text.trim().toLowerCase() ==
            (item["packagename"] as String).toLowerCase()) {
          setState(() {
            userInfo.read("searchResult").add(item);
          });
        }
      }
      return searchResults();
    }
  }

  _remove(index) {
    for (var item in userInfo.read("cart")) {
      if (userInfo.read("cart")[index]["packagename"] == item["packagename"]) {
        setState(() {
          userInfo.read("cart").remove(item);
          _calculateTotal();
        });
      }
    }
  }

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
}
