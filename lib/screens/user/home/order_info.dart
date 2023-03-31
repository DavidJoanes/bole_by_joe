// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/profile_picture.dart';
import '../../../controllers/controller.dart';
import '../../../controllers/route_controllers.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/display_image.dart';
import '../../../widgets/overlay_builder.dart';
import '../../resolution.dart';

class OrderInfo extends StatefulWidget {
  const OrderInfo(
      {super.key,
      required this.status,
      required this.orderId,
      required this.ownerEmail,
      required this.ownerFullName,
      required this.ownerPhone,
      required this.deliveryAddress,
      required this.closestLandmark,
      required this.city,
      required this.province,
      required this.paid,
      required this.datePlaced,
      required this.timePlaced,
      required this.estimatedTimeDuration});
  final String status;
  final int orderId;
  final String ownerEmail;
  final String ownerFullName;
  final String ownerPhone;
  final String deliveryAddress;
  final String closestLandmark;
  final String city;
  final String province;
  final bool paid;
  final String datePlaced;
  final String timePlaced;
  final String estimatedTimeDuration;

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  String userImage = "";

  var estimatedTimeDurations = {
    "",
    "10",
    "20",
    "30",
    "45",
    "60",
    "90",
    "120",
    "150",
    "180",
  };
  DropdownMenuItem<String> buildestimatedTimeDurations(String dur) =>
      DropdownMenuItem(
          value: dur,
          child: Text(
            dur,
          ));

  var estimatedDayDurations = {
    "0",
    "1",
    "2",
    "3",
    "4",
    "6",
    "7",
  };
  DropdownMenuItem<String> buildestimatedDayDurations(String dur) =>
      DropdownMenuItem(
          value: dur,
          child: Text(
            dur,
          ));

  fetchItemsOrdered() {
    constantValues.itemsOrdered.clear();
    setState(() {
      for (var item in constantValues.activeDeliveryRequests) {
        for (var item2 in item["items"] as List) {
          if (widget.orderId == item["orderid"]) {
            constantValues.itemsOrdered.add(item2);
          }
        }
      }
      // print("items ordered = ${constantValues.itemsOrdered}");
    });
  }

  @override
  void initState() {
    _fetchOrderOwnerData();
    setState(() {
      constantValues.estimatedDeliveryTime = widget.estimatedTimeDuration;
    });
    fetchItemsOrdered();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: secondaryAppBar(context, "Order Info", () {
          Navigator.of(context).pop();
        }),
        body: SafeArea(
          child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Resolution(
                  desktopScreen: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: mixedScreen(context),
                  ),
                  mixedScreen: mixedScreen(context))),
        ),
        bottomNavigationBar: bottomAppBar(
          context,
          ListTile(
            trailing: ButtonA(
                width: size.width * 0.45,
                text1: widget.status == 'awaiting rider'
                    ? "Accept"
                    : "Mark as delivered",
                text2: "Loading..",
                isLoading: false,
                authenticate: () async {
                  widget.status == 'awaiting rider'
                      ? await _acceptDelivery()
                      : await _markAsDelivered();
                }),
          ),
        ));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500));
    final fontStyle2b = GoogleFonts.poppins(
        textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.08),
          ProfilePicture(
              image: userImage != "" ? userImage : "assets/icons/user.png",
              radius: 60,
              onClicked: () {
                Navigator.of(context).push(OverlayBuilder(
                    builder: (context) => DisplayImage(
                        image: userImage != ""
                            ? NetworkImage(userImage)
                            : AssetImage("assets/icons/user.png"))));
              }),
          SizedBox(height: size.height * 0.02),
          Column(
            children: [
              Text(widget.ownerFullName, style: fontStyle1),
              SizedBox(height: 5),
              OverflowBar(
                children: [
                  Text(widget.ownerPhone, style: fontStyle2b),
                  SizedBox(width: 10),
                  IconButton(
                    tooltip: "Call",
                    icon: Icon(Icons.call,
                        size: 14, color: constantValues.primaryColor),
                    onPressed: () {
                      RouteTo.openPhone(widget.ownerPhone);
                    },
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
            child: ListTile(
              title: OverflowBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order ID:", style: fontStyle1b),
                  Text("${widget.orderId}"),
                ],
              ),
              trailing: IconButton(
                tooltip: "Copy",
                icon: Icon(Icons.copy,
                    size: 12, color: constantValues.primaryColor),
                onPressed: () async {
                  await Clipboard.setData(
                          ClipboardData(text: "${widget.orderId}"))
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Order id copied to clipboard")));
                  });
                },
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            decoration: BoxDecoration(
              color: constantValues.greyColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("Address:", style: fontStyle1b),
                  subtitle: Text(widget.deliveryAddress),
                  trailing: ButtonC(
                    width: size.width * 0.2,
                    text: "View",
                    onpress: () {
                      RouteTo.openMap2(
                          "${widget.deliveryAddress}, ${widget.city}");
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text("Closet Landmark:", style: fontStyle1b),
                  subtitle: Text(widget.closestLandmark),
                ),
                Divider(),
                ListTile(
                  title: Text("City:", style: fontStyle1b),
                  subtitle: Text(widget.city),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.05),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Packages ordered..", style: fontStyle1b),
                SizedBox(height: 10),
                SizedBox(
                  height: size.height * 0.4,
                  child: ListView.builder(
                      itemCount: constantValues.itemsOrdered.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01,
                              horizontal: size.width * 0.02),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              leading: ProfilePicture(
                                image: constantValues.itemsOrdered[index]
                                    ["coverimage"]["url"],
                                radius: 20,
                                onClicked: () {},
                              ),
                              title: Text(constantValues.itemsOrdered[index]
                                  ["packagename"]),
                              subtitle: Text(
                                  "Qty: ${constantValues.itemsOrdered[index]['qty']}"),
                              trailing: Text(
                                  "${currencyIcon(context).currencySymbol}${constantValues.itemsOrdered[index]['price']}"),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          OverflowBar(
            children: [
              Container(
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text("Estimated delivery duration (in days)"),
                  subtitle: Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            hint: Text(""),
                            isExpanded: true,
                            disabledHint:
                                Text(constantValues.estimatedDeliveryDay!),
                            value: constantValues.estimatedDeliveryDay,
                            items: widget.estimatedTimeDuration != ""
                                ? null
                                : estimatedDayDurations
                                    .map(buildestimatedDayDurations)
                                    .toList(),
                            onChanged: (value) async {
                              setState(() {
                                constantValues.estimatedDeliveryDay = value!;
                              });
                            }),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text("Estimated delivery duration (in minutes)"),
                  subtitle: Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            hint: Text(""),
                            isExpanded: true,
                            disabledHint: Text(widget.estimatedTimeDuration),
                            value: constantValues.estimatedDeliveryTime,
                            items: widget.estimatedTimeDuration != ""
                                ? null
                                : estimatedTimeDurations
                                    .map(buildestimatedTimeDurations)
                                    .toList(),
                            onChanged: (value) async {
                              setState(() {
                                constantValues.estimatedDeliveryTime = value!;
                              });
                            }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.05),
        ],
      ),
    );
  }

  _fetchOrderOwnerData() async {
    setState(() {
      constantValues.orderOwnerData.clear();
    });
    final email = widget.ownerEmail;
    try {
      var response =
          await dio.post("$backendUrl/user-info", data: {"userEmail": email});
      if (response.data["success"]) {
        setState(() {
          constantValues.orderOwnerData = response.data["data"];
          userImage = constantValues.orderOwnerData["profileimage"]["url"];
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

  _acceptDelivery() async {
    if (constantValues.estimatedDeliveryDay != "") {
      if (constantValues.estimatedDeliveryTime != "") {
        final email = constantValues.userData["email"];
        final orderid = widget.orderId;
        final estimatedday = constantValues.estimatedDeliveryDay;
        final estimatedtime = constantValues.estimatedDeliveryTime;
        try {
          var response = await dio.post("$backendUrl/accept-order", data: {
            "email": email,
            "orderid": orderid,
            "estimatedDate": int.parse(estimatedday!),
            "estimatedTime": int.parse(estimatedtime!),
          });
          if (response.data["success"] == "existing-accepted-order") {
            return ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response.data["message"])));
          } else if (response.data["success"] == "true") {
            Fluttertoast.showToast(
              msg: response.data["message"],
              toastLength: Toast.LENGTH_LONG,
              webPosition: "center",
            );
            Navigator.of(context).pop();
          }
        } on DioError catch (error) {
          return ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.response!.data["message"])));
        }
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Please, select an estimated time duration!")));
      }
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please, select an estimated day duration!")));
    }
  }

  _markAsDelivered() async {
    final email = constantValues.userData["email"];
    final orderid = widget.orderId;
    try {
      var response = await dio.post("$backendUrl/mark-as-delivered", data: {
        "email": email,
        "orderid": orderid,
      });
      if (response.data["success"]) {
        Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
        Navigator.of(context).pop();
      }
    } on DioError catch (error) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }
}
