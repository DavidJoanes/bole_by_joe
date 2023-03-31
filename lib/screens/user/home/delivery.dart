// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../screens/user/home/order_info.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/buttons.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();

  @override
  void initState() {
    setState(() {
      constantValues.activeDeliveryRequests.clear();
      constantValues.completedDeliveryRequests.clear();
    });
    _fetchActiveDeliveryRequests();
    _fetchCompletedDeliveryRequests();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(textStyle: TextStyle());
    final fontstyle2 = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w600, color: constantValues.successColor));
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
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
                    Tab(
                      text: "Active",
                    ),
                    SizedBox(width: 5),
                    Text("${constantValues.activeDeliveryRequests.length}",
                        style: fontstyle2)
                  ],
                ),
                Tab(
                  text: "History",
                ),
              ]),
        ),
        body: mixedScreen(context),
      ),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w300));
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
    return constantValues.userData.isNotEmpty
        ? TabBarView(children: [
            // Active
            constantValues.activeDeliveryRequests.isNotEmpty
                ? SizedBox(
                    child: RefreshIndicator(
                      onRefresh: _refreshActive,
                      child: ListView.builder(
                        itemCount: constantValues.activeDeliveryRequests.length,
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
                                            constantValues
                                                        .activeDeliveryRequests[
                                                    index]["ownerfullname"]
                                                as String,
                                            style: fontStyle1),
                                        Card(
                                            color: constantValues
                                                            .activeDeliveryRequests[
                                                        index]["status"] ==
                                                    "en-route"
                                                ? constantValues.tealColor
                                                : constantValues.errorColor,
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Text(
                                                  (constantValues.activeDeliveryRequests[
                                                              index]["status"]
                                                          as String)
                                                      .toUpperCase(),
                                                  style: fontStyle1c),
                                            )),
                                        constantValues.activeDeliveryRequests[
                                                index]["paid"]
                                            ? Card(
                                                color:
                                                    constantValues.successColor,
                                                child: Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Text("PAID",
                                                      style: fontStyle1c),
                                                ),
                                              )
                                            : Card(
                                                color:
                                                    constantValues.errorColor,
                                                child: Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Text("PoD",
                                                      style: fontStyle1c),
                                                ),
                                              ),
                                      ],
                                    ),
                                    trailing: Text(constantValues
                                            .activeDeliveryRequests[index]
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
            constantValues.completedDeliveryRequests.isNotEmpty
                ? SizedBox(
                    child: RefreshIndicator(
                      onRefresh: _refreshHistory,
                      child: ListView.builder(
                        itemCount:
                            constantValues.completedDeliveryRequests.length,
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
                                          constantValues
                                                  .completedDeliveryRequests[
                                              index]["ownerfullname"] as String,
                                          style: fontStyle1),
                                      Card(
                                          child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                            (constantValues
                                                        .completedDeliveryRequests[
                                                    index]["status"] as String)
                                                .toUpperCase(),
                                            style: fontStyle1d),
                                      )),
                                    ],
                                  ),
                                  subtitle: Text(
                                    "Order ID: ${constantValues.completedDeliveryRequests[index]['orderid'].toString()}",
                                    style: fontStyle1b,
                                  ),
                                  trailing: Text(constantValues
                                          .completedDeliveryRequests[index]
                                      ['dateplaced'] as String),
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
                  Text("Not signed in yet?"),
                  SizedBox(height: 10),
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
    await _fetchActiveDeliveryRequests();
    _fetchCompletedDeliveryRequests();
  }

  Future<void> _refreshHistory() async {
    await _fetchCompletedDeliveryRequests();
    _fetchActiveDeliveryRequests();
  }

  _fetchActiveDeliveryRequests() async {
    final email = constantValues.userData["email"];
    try {
      var response = await dio
          .post("$backendUrl/active-delivery-requests", data: {"email": email});
      if (response.data["success"]) {
        setState(() {
          constantValues.activeDeliveryRequests = response.data["data"];
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
    final email = constantValues.userData["email"];
    try {
      var response = await dio.post("$backendUrl/completed-delivery-requests",
          data: {"email": email});
      if (response.data["success"]) {
        setState(() {
          constantValues.completedDeliveryRequests = response.data["data"];
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
              status: constantValues.activeDeliveryRequests[index]["status"]
                  as String,
              orderId: constantValues.activeDeliveryRequests[index]["orderid"]
                  as int,
              ownerEmail: constantValues.activeDeliveryRequests[index]
                  ["owneremail"] as String,
              ownerFullName: constantValues.activeDeliveryRequests[index]
                  ["ownerfullname"] as String,
              ownerPhone: constantValues.activeDeliveryRequests[index]
                  ["ownerphonenumber"] as String,
              deliveryAddress: constantValues.activeDeliveryRequests[index]
                  ["deliveryaddress"] as String,
              closestLandmark: constantValues.activeDeliveryRequests[index]
                  ["closestlandmark"] as String,
              city: constantValues.activeDeliveryRequests[index]["city"]
                  as String,
              province: constantValues.activeDeliveryRequests[index]["province"]
                  as String,
              paid:
                  constantValues.activeDeliveryRequests[index]["paid"] as bool,
              datePlaced: constantValues.activeDeliveryRequests[index]
                  ["dateplaced"] as String,
              timePlaced: constantValues.activeDeliveryRequests[index]
                  ["timeplaced"] as String,
              estimatedTimeDuration: constantValues
                  .activeDeliveryRequests[index]["estimatedduration"] as String,
            )));
  }
}
