// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/data_controller.dart';
import '../../../controllers/theme_modifier.dart';
import '../../../widgets/bestpackages.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/all_packages.dart';
import '../../../widgets/profile_picture.dart';
import '../../resolution.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(constantValues.searchResult);
  Dio dio = Dio();

  _fetchDiscountedPacks() async {
    try {
      var response = await dio.post("$backendUrl/discounted-packages");
      if (response.data["success"]) {
        setState(() {
          constantValues.bestPacks = response.data["data"];
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

  _fetchNormalPacks() async {
    try {
      var response = await dio.post("$backendUrl/normal-packages");
      if (response.data["success"]) {
        setState(() {
          constantValues.normalPacks = response.data["data"];
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
    _fetchDiscountedPacks();
    _fetchNormalPacks();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    constantValues.searchResult.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    final fontstyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontstyle1b = GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400));
    return Scaffold(
      appBar: constantValues.userData.isEmpty
          ? AppBar(
              title: Container(
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(constantValues.isDarkTheme
                              ? "assets/icons/logo3b.png"
                              : "assets/icons/logob.png")))),
              centerTitle: true,
              actions: [
                  IconButton(
                    tooltip: "Cart",
                    icon: Stack(
                      children: [
                        Icon(Icons.shopping_basket_outlined),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Text(
                              "${constantValues.cart.length}",
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
                  SizedBox(width: 5),
                ])
          : AppBar(
              leading: Padding(
                padding: EdgeInsets.all(10),
                child: ProfilePicture(
                  image: constantValues.userData["profileimage"]["url"] != ""
                      ? constantValues.userData["profileimage"]["url"]
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
                    (constantValues.userData["lastname"] as String)
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
                        Icon(Icons.shopping_basket_outlined),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Text(
                              "${constantValues.cart.length}",
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
                  SizedBox(width: 15),
                ]),
      floatingActionButton: CircleAvatar(
        radius: 20,
        backgroundColor: constantValues.blackColor,
        child: IconButton(
          icon: Icon(
            constantValues.isDarkTheme
                ? Icons.lightbulb_circle
                : Icons.lightbulb_circle_outlined,
          ),
          onPressed: () {
            setState(() {
              constantValues.isDarkTheme = !constantValues.isDarkTheme;
            });
            themeChanger.setTheme(constantValues.isDarkTheme
                ? ThemeData.dark()
                : ThemeData(
                    primarySwatch:
                        MaterialColor(0xFFFFA726, constantValues.defaultColor),
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
    );
  }

  Widget customAppBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontstyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontstyle1b = GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w300));
    return constantValues.userData.isEmpty
        ? Card(
            elevation: 2,
            child: ListTile(
              title: Container(
                  height: size.height * 0.03,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(constantValues.isDarkTheme
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
                          "${constantValues.cart.length}",
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
                    image: constantValues.userData["profileimage"]["url"] != ""
                        ? constantValues.userData["profileimage"]["url"]
                        : "assets/icons/user.png",
                    radius: 15,
                    onClicked: () {},
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello", style: fontstyle1b),
                      Text(
                        (constantValues.userData["lastname"] as String)
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
                              "${constantValues.cart.length}",
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
    return Column(
      children: [
        // customAppBar(context),
        SizedBox(height: size.height * 0.02),
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
        SizedBox(height: size.height * 0.01),
        BestPackages(
            object: constantValues.bestPacks,
            object2: object.packages,
            isDesktop: true),
        AllPacks(
          object: constantValues.normalPacks,
          isDesktop: true,
        )
      ],
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PackageData object = PackageData(context);
    return Column(
      children: [
        // customAppBar(context),
        SizedBox(height: size.height * 0.02),
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
        SizedBox(height: size.height * 0.01),
        BestPackages(
            object: constantValues.bestPacks,
            object2: object.packages,
            isDesktop: false),
        AllPacks(
          object: constantValues.normalPacks,
          isDesktop: false,
        )
      ],
    );
  }

  searchResults() {
    Size size = MediaQuery.of(context).size;
    final fontstyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontstyle1b =
        GoogleFonts.jost(textStyle: TextStyle(fontWeight: FontWeight.w300));
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        shape: RoundedRectangleBorder(
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
                          constantValues.searchResult.isEmpty
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
                                          constantValues.searchResult.length,
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
                                                image: constantValues
                                                        .searchResult[index]
                                                    ["coverimage"]["url"],
                                                onClicked: () {},
                                              ),
                                              title: Text(constantValues
                                                      .searchResult[index]
                                                  ["packagename"]),
                                              trailing: Icon(Icons.arrow_right),
                                              onTap: () {
                                                setState(() {
                                                  constantValues
                                                          .selectedPackage =
                                                      constantValues
                                                          .searchResult[index];
                                                });
                                                context.goNamed(
                                                  "package",
                                                  params: {
                                                    "name": (constantValues
                                                                        .searchResult[
                                                                    index]
                                                                ["packagename"]
                                                            as String)
                                                        .toLowerCase()
                                                  },
                                                );
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
    constantValues.searchResult.clear();
    final form = _formKey.currentState!;
    if (form.validate()) {
      for (var item in constantValues.allPackages) {
        if (searchController.text.trim().toLowerCase() ==
            (item["packagename"] as String).toLowerCase()) {
          setState(() {
            constantValues.searchResult.add(item);
          });
        }
      }
      return searchResults();
    }
  }
}
