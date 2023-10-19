import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../screens/user/home/order_info.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/buttons.dart';

final globalBucket = PageStorageBucket();

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  Timer defaultTime = Timer.periodic(const Duration(seconds: 1), (timer) { });

  @override
  void initState() {
    setState(() {
      userInfo.writeIfNull("activeDeliveryRequests", []);
      userInfo.writeIfNull("completedDeliveryRequests", []);
      userInfo.read("activeDeliveryRequests").clear();
      userInfo.read("completedDeliveryRequests").clear();
    });
    _fetchActiveDeliveryRequests(defaultTime);
    _fetchCompletedDeliveryRequests();
    Timer.periodic(const Duration(seconds: 30), _fetchActiveDeliveryRequests);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(textStyle: const TextStyle());
    final fontstyle2 = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w600, color: constantValues.errorColor));
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: PageStorage(
        bucket: globalBucket,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
                labelStyle: fontStyle1,
                indicatorColor: constantValues.whiteColor,
                unselectedLabelStyle: fontStyle1b,
                tabs: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Tab(
                        text: "Active",
                      ),
                      const SizedBox(width: 5),
                      Text("${userInfo.read("activeDeliveryRequests").length}",
                          style: fontstyle2)
                    ],
                  ),
                  const Tab(
                    text: "History",
                  ),
                ]),
          ),
          body: mixedScreen(context),
        ),
      ),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w300));
    final fontStyle1c = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 10,
            color: constantValues.whiteColor));
    final fontStyle1d = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: constantValues.errorColor));
    return userInfo.read("userData").isNotEmpty
        ? TabBarView(children: [
            // Active
            userInfo.read("activeDeliveryRequests").isNotEmpty
                ? SizedBox(
                    child: RefreshIndicator(
                      onRefresh: _refreshActive,
                      child: ListView.builder(
                        key: const PageStorageKey<String>("active"),
                        itemCount:
                            userInfo.read("activeDeliveryRequests").length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005,
                                horizontal: size.width * 0.02),
                            child: Card(
                                elevation: 4,
                                child: InkWell(
                                  child: ListTile(
                                    leading: Icon(Icons.shopify_outlined,
                                        color: constantValues.primaryColor),
                                    title: OverflowBar(
                                      alignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            userInfo.read(
                                                    "activeDeliveryRequests")[
                                                index]["ownerfullname"] as String,
                                            style: fontStyle1),
                                        Card(
                                            color: userInfo.read(
                                                            "activeDeliveryRequests")[
                                                        index]["status"] ==
                                                    "en-route"
                                                ? constantValues.tealColor
                                                : constantValues.errorColor,
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Text(
                                                  (userInfo.read("activeDeliveryRequests")[
                                                              index]["status"]
                                                          as String)
                                                      .toUpperCase(),
                                                  style: fontStyle1c),
                                            )),
                                        userInfo.read("activeDeliveryRequests")[
                                                index]["paid"]
                                            ? Card(
                                                color:
                                                    constantValues.successColor,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: Text("PAID",
                                                      style: fontStyle1c),
                                                ),
                                              )
                                            : Card(
                                                color:
                                                    constantValues.errorColor,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: Text("PoD",
                                                      style: fontStyle1c),
                                                ),
                                              ),
                                      ],
                                    ),
                                    trailing: Text(userInfo.read(
                                            "activeDeliveryRequests")[index]
                                        ['dateplaced'] as String),
                                  ),
                                  onTap: () {
                                    _view(index);
                                  },
                                )),
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Image.asset("assets/icons/empty.png",
                        height: size.height * 0.1)),
            // History
            userInfo.read("completedDeliveryRequests").isNotEmpty
                ? SizedBox(
                    child: RefreshIndicator(
                      onRefresh: _refreshHistory,
                      child: ListView.builder(
                        key: const PageStorageKey<String>("completed"),
                        itemCount:
                            userInfo.read("completedDeliveryRequests").length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005,
                                horizontal: size.width * 0.02),
                            child: Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: Icon(Icons.shopify_outlined,
                                      color: constantValues.primaryColor),
                                  title: OverflowBar(
                                    alignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          userInfo.read(
                                                  "completedDeliveryRequests")[
                                              index]["ownerfullname"],
                                          style: fontStyle1),
                                      Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                            (userInfo.read(
                                                        "completedDeliveryRequests")[
                                                    index]["status"])
                                                .toUpperCase(),
                                            style: fontStyle1d),
                                      )),
                                    ],
                                  ),
                                  subtitle: TextSelectionTheme(
                                    data: const TextSelectionThemeData(),
                                    child: SelectableText(
                                      "Order ID: ${userInfo.read("completedDeliveryRequests")[index]['orderid'].toString()}",
                                      style: fontStyle1b,
                                      onSelectionChanged: (selection, cause) {
                                        setState(() {
                                          "Order ID: ${userInfo.read("completedDeliveryRequests")[index]['orderid'].toString()}"
                                              .substring(selection.start,
                                                  selection.end);
                                        });
                                      },
                                    ),
                                  ),
                                  trailing: Text(userInfo.read(
                                          "completedDeliveryRequests")[index]
                                      ['dateplaced']),
                                )),
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Image.asset("assets/icons/empty.png",
                        height: size.height * 0.1)),
          ])
        : Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.3),
            child: Center(
              child: Column(
                children: [
                  const Text("Not signed in yet?"),
                  const SizedBox(height: 10),
                  ButtonC2(
                    width: size.width * 0.2,
                    text: "Signin",
                    onpress: () {
                      context.goNamed("signin");
                    },
                  )
                ],
              ),
            ),
          );
  }

  Future<void> _refreshActive() async {
    await _fetchActiveDeliveryRequests(defaultTime);
    _fetchCompletedDeliveryRequests();
  }

  Future<void> _refreshHistory() async {
    await _fetchCompletedDeliveryRequests();
    _fetchActiveDeliveryRequests(defaultTime);
  }

  Future _fetchActiveDeliveryRequests(Timer timer) async {
    final email = userInfo.read("userData")["email"];
    try {
      var response = await dio
          .post("$backendUrl/active-delivery-requests", data: {"email": email});
      if (response.data["success"]) {
        setState(() {
          userInfo.write("activeDeliveryRequests", response.data["data"]);
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

  _fetchCompletedDeliveryRequests() async {
    final email = userInfo.read("userData")["email"];
    try {
      var response = await dio.post("$backendUrl/completed-delivery-requests",
          data: {"email": email});
      if (response.data["success"]) {
        setState(() {
          userInfo.write("completedDeliveryRequests", response.data["data"]);
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

  _view(index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OrderInfo(
              status: userInfo.read("activeDeliveryRequests")[index]["status"]
                  as String,
              orderId: userInfo.read("activeDeliveryRequests")[index]["orderid"]
                  as int,
              ownerEmail: userInfo.read("activeDeliveryRequests")[index]
                  ["owneremail"] as String,
              ownerFullName: userInfo.read("activeDeliveryRequests")[index]
                  ["ownerfullname"] as String,
              ownerPhone: userInfo.read("activeDeliveryRequests")[index]
                  ["ownerphonenumber"] as String,
              deliveryAddress: userInfo.read("activeDeliveryRequests")[index]
                  ["deliveryaddress"] as String,
              closestLandmark: userInfo.read("activeDeliveryRequests")[index]
                  ["closestlandmark"] as String,
              city: userInfo.read("activeDeliveryRequests")[index]["city"]
                  as String,
              province: userInfo.read("activeDeliveryRequests")[index]
                  ["province"] as String,
              paid: userInfo.read("activeDeliveryRequests")[index]["paid"]
                  as bool,
              datePlaced: userInfo.read("activeDeliveryRequests")[index]
                  ["dateplaced"] as String,
              timePlaced: userInfo.read("activeDeliveryRequests")[index]
                  ["timeplaced"] as String,
              estimatedTimeDuration:
                  userInfo.read("activeDeliveryRequests")[index]
                      ["estimatedduration"] as String,
            )));
  }
}
