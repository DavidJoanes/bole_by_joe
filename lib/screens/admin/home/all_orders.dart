import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../screens/admin/home/order_info.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/profile_picture.dart';

final globalBucket = PageStorageBucket();

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(userInfo.read("searchResult"));

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  @override
  void initState() {
    _fetchAllOrders();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: globalBucket,
      child: Scaffold(
          appBar: primaryAppBar(context, "All Orders"),
          body: SafeArea(
              child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: mixedScreen(context)))),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w300));
    final fontStyle1c = GoogleFonts.poppins(
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600));
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        Form(
          key: _formKey,
          child: InputFieldA2(
              controller: searchController,
              width: size.width * 0.9,
              title: "Search by email or order id..",
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
        SizedBox(height: size.height * 0.02),
        SizedBox(
          height: size.height * 0.8,
          child: userInfo.read("allOrders").isNotEmpty
              ? RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                        key: const PageStorageKey<String>("allOrders"),
                      itemCount: userInfo.read("allOrders").length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005,
                                horizontal: size.width * 0.02),
                            child: Card(
                                child: ListTile(
                              leading: ProfilePicture(
                                radius: 30,
                                image: (userInfo.read("allOrders")[index]["items"]
                                    as List)[0]["coverimage"]["url"],
                                onClicked: () {},
                              ),
                              title: Text(
                                  "Order id: ${userInfo.read("allOrders")[index]["orderid"]}",
                                  style: fontStyle1),
                              subtitle: OverflowBar(
                                alignment: MainAxisAlignment.start,
                                children: [
                                  const Text("status: "),
                                  Card(
                                      color: userInfo.read("allOrders")[index]
                                                  ["status"] ==
                                              "awaiting rider"
                                          ? constantValues.amberColor
                                          : userInfo.read("allOrders")[index]
                                                      ["status"] ==
                                                  "en-route"
                                              ? constantValues.tealColor
                                              : userInfo.read("allOrders")[index]
                                                          ["status"] ==
                                                      "delivered"
                                                  ? constantValues.successColor
                                                  : constantValues.errorColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                            (userInfo.read("allOrders")[index]
                                                    ["status"] as String)
                                                .toUpperCase(),
                                            style: fontStyle1c),
                                      )),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "${currencyIcon(context).currencySymbol}${userInfo.read("allOrders")[index]["total"]}",
                                      style: fontStyle1),
                                  Text(
                                      "${(userInfo.read("allOrders")[index]["items"] as List).length} items",
                                      style: fontStyle1b)
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OrderInfoAdmin(
                                          order:
                                              userInfo.read("allOrders")[index],
                                        )));
                              },
                            ))).animate().fade().slideX(curve: Curves.bounceIn);
                      }))
              : Center(child: Text("No order found..", style: fontStyle1b)),
        ),
        SizedBox(height: size.height * 0.02),
      ],
    );
  }

  Future<void> _refresh() async {
    await _fetchAllOrders();
  }

  searchResults() {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.jost(textStyle: const TextStyle(fontWeight: FontWeight.w300));
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
                            title: Text("Search Results..", style: fontStyle1),
                          ),
                          userInfo.read("searchResult").isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.1),
                                  child: Center(
                                      child: Text("Nothing found...",
                                          style: fontStyle1b)),
                                )
                              : SizedBox(
                                  height: size.height * 0.45,
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
                                                image: (userInfo.read("searchResult")[index]
                                                        ["items"] as List)[0]
                                                    ["coverimage"]["url"],
                                                onClicked: () {},
                                              ),
                                              title: Text(
                                                  "Order id: ${userInfo.read("searchResult")[index]["orderid"]}"),
                                              trailing: const Icon(Icons.arrow_right),
                                              onTap: () {
                                                setState(() {
                                                  userInfo.write("selectedPackage",
                                                      userInfo.read("searchResult")[index]);
                                                });
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderInfoAdmin(
                                                              order: userInfo.read("searchResult")[
                                                                  index],
                                                            )));
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
      if (searchController.text.isNum) {
        for (var item in userInfo.read("allOrders")) {
          if (searchController.text.trim() == item["orderid"].toString()) {
            setState(() {
              userInfo.read("searchResult").add(item);
            });
          }
        }
        return searchResults();
      } else {
        for (var item in userInfo.read("allOrders")) {
          if (searchController.text.trim().toLowerCase() ==
              (item["owneremail"] as String).toLowerCase()) {
            setState(() {
              userInfo.read("searchResult").add(item);
            });
          }
        }
      }
      return searchResults();
    }
  }

  _fetchAllOrders() async {
    try {
      var response = await dio.post("$backendUrl2/all-orders");
      if (response.data["success"]) {
        setState(() {
          userInfo.write("allOrders", response.data["data"]);
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
