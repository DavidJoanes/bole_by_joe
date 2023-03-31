// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../screens/user/home/dispatcher.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/profile_picture.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../resolution.dart';

class Tracker extends StatefulWidget {
  const Tracker({super.key, required this.order});
  final order;

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  bool loading = false;
  String dispatcherImage = "";
  
  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  @override
  void initState() {
    _fetchDispatcherData();
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
      appBar: secondaryAppBar(context, "Tracker", () {
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
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.successColor, fontWeight: FontWeight.bold));
    return !loading
        ? Column(
            children: [
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
                child: ListTile(
                  title: Row(
                    children: [
                      Text("Order ID: "),
                      Text("${widget.order["orderid"]}", style: fontStyle1),
                    ],
                  ),
                  trailing: IconButton(
                    tooltip: "copy",
                    icon: Icon(Icons.copy_outlined,
                        color: constantValues.primaryColor),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                              text:
                                  "${constantValues.activeOrders[0]["orderid"]}"))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Order id copied to clipboard")));
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              timeline(context, widget.order),
              SizedBox(height: size.height * 0.02),
              bottomSection(
                context,
                widget.order,
                constantValues.dispatcherData,
              ),
              SizedBox(height: size.height * 0.02),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  Widget timeline(BuildContext context, var order) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold));
    final fontStyle2 = GoogleFonts.poppins(
        textStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 10));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Timeline (GMT+00:00)", style: fontStyle1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.bookmark_added_rounded,
                      color: constantValues.primaryColor),
                  title: Text("Order Placed", style: fontStyle1),
                  subtitle:
                      Text("Date: ${order["dateplaced"]}", style: fontStyle2),
                  trailing: Text(order["timeplaced"].split(".")[0]),
                ),
                SizedBox(height: size.height * 0.01),
                ListTile(
                  leading: Icon(Icons.more_vert_outlined,
                      color: constantValues.primaryColor),
                ),
                SizedBox(height: size.height * 0.01),
                ListTile(
                  leading: Icon(Icons.delivery_dining,
                      color: constantValues.primaryColor),
                  title: Text("Order Accepted", style: fontStyle1),
                  subtitle: order["dateaccepted"] != ""
                      ? Text("Date: ${order["dateaccepted"]}",
                          style: fontStyle2)
                      : Text("Date: --", style: fontStyle2),
                  trailing: order["timeaccepted"] != ""
                      ? Text(order["timeaccepted"].split(".")[0])
                      : Text("--"),
                ),
                SizedBox(height: size.height * 0.01),
                ListTile(
                  leading: Icon(Icons.more_vert_outlined,
                      color: constantValues.primaryColor),
                ),
                SizedBox(height: size.height * 0.01),
                ListTile(
                  leading: Icon(Icons.home_filled,
                      color: constantValues.primaryColor),
                  title: Text("Knock Knock", style: fontStyle1),
                  subtitle: order["estimateddate"] != ""
                      ? Text("Estimated Date: ${order["estimateddate"]}",
                          style: fontStyle2)
                      : Text("Estimated Date: --", style: fontStyle2),
                  trailing: order["estimatedtime"] != ""
                      ? Text(order["estimatedtime"])
                      : Text("--"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSection(BuildContext context, var order, var dispatcher) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle2 = GoogleFonts.poppins(
        textStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 10));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: constantValues.greyColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text(order["deliveryaddress"], style: fontStyle1),
                  subtitle: Text("Delivery Address", style: fontStyle2),
                ),
                ListTile(
                  leading: Icon(Icons.access_time_outlined),
                  title: order["estimatedduration"] != ""
                      ? Text("${order["estimatedduration"]} minutes",
                          style: fontStyle1)
                      : Text("--", style: fontStyle1),
                  subtitle: Text("Estimated Delivery Duration", style: fontStyle2),
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                order["dispatcher"] != ""
                    ? ListTile(
                        leading: ProfilePicture(
                          image: dispatcher["profileimage"]["url"] != ""
                              ? dispatcher["profileimage"]["url"]
                              : "assets/icons/user.png",
                          radius: 20,
                          onClicked: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Dispatcher(
                                    dispatcher: constantValues.dispatcherData,
                                    dispatcherRatings:
                                        constantValues.dispatcherData["ratings"]
                                            as List<dynamic>)));
                          },
                        ),
                        title: Text(
                            "${(dispatcher['firstname'] as String).toTitleCase()} ${(dispatcher['lastname'] as String).toTitleCase()}"),
                        subtitle: Text("Dispatcher", style: fontStyle2),
                      )
                    : SizedBox(),
                SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.04),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Packages ordered..", style: fontStyle1),
                SizedBox(height: 10),
                SizedBox(
                  height: size.height * 0.4,
                  child: ListView.builder(
                      itemCount: order["items"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01,
                              horizontal: size.width * 0.02),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              leading: ProfilePicture(
                                image: order["items"][index]
                                    ["coverimage"]["url"],
                                radius: 20,
                                onClicked: () {},
                              ),
                              title: Text(order["items"][index]
                                  ["packagename"]),
                              subtitle: Text(
                                  "Qty: ${order["items"][index]['qty']}"),
                              trailing: Text(
                                  "${currencyIcon(context).currencySymbol}${order["items"][index]['price']}"),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _fetchDispatcherData() async {
    setState(() {
      loading = true;
      constantValues.dispatcherData.clear();
    });
    final email = widget.order["dispatcher"];
    try {
      var response = await dio.post("$backendUrl/dispatcher-info",
          data: {"dispatcherEmail": email});
      if (response.data["success"]) {
        setState(() {
          constantValues.dispatcherData = response.data["data"];
          dispatcherImage =
              constantValues.dispatcherData["profileimage"]["url"];
          loading = false;
        });
      }
    } on DioError catch (error) {
      setState(() {
        loading = false;
      });
      return Fluttertoast.showToast(
        msg: error.response!.data["message"],
        toastLength: Toast.LENGTH_LONG,
        webPosition: "center",
      );
    }
  }
}
