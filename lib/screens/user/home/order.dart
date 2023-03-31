// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../screens/user/home/tracker.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/profile_picture.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/display_image.dart';
import '../../../widgets/overlay_builder.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  String? reason;
  double? rating_;
  late ValueNotifier reasonValueNotifier = ValueNotifier(reason);

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  var reasonsForCancellation = [
    "I ordered a wrong package",
    "My order wasn't accepted for a long time",
    "No reason"
  ];
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    setState(() {
      constantValues.activeOrders.clear();
      constantValues.completedOrders.clear();
      constantValues.cancelledOrders.clear();
    });
    _fetchMyOrders();
    super.initState();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(textStyle: TextStyle());
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              labelStyle: fontStyle1,
              indicatorColor: constantValues.whiteColor,
              unselectedLabelStyle: fontStyle1b,
              tabs: [
                Tab(
                  text: "Active",
                ),
                Tab(
                  text: "Completed",
                ),
                Tab(
                  text: "Cancelled",
                )
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
    final fontStyle2 = GoogleFonts.poppins(
        textStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 10));
    final fontStyle3 = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor,
            fontWeight: FontWeight.w300,
            fontSize: 10));
    final fontStyle3b = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: constantValues.errorColor));
    return constantValues.userData.isNotEmpty
        ? TabBarView(children: [
            // Active
            constantValues.activeOrders.isNotEmpty
                ? SizedBox(
                    child: RefreshIndicator(
                      onRefresh: _refreshActive,
                      child: ListView.builder(
                        itemCount: constantValues.activeOrders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005,
                                horizontal: size.width * 0.02),
                            child: Card(
                                elevation: 4,
                                child: Column(
                                  children: [
                                    SizedBox(height: size.height * 0.01),
                                    ListTile(
                                      leading: ProfilePicture(
                                        image: (constantValues
                                                .activeOrders[index]["items"]
                                            as List)[0]["coverimage"]["url"],
                                        radius: 30,
                                        onClicked: () {},
                                      ),
                                      title: OverflowBar(
                                        alignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Order ID: ${constantValues.activeOrders[index]["orderid"]}",
                                              style: fontStyle1),
                                          constantValues.activeOrders[index]
                                                  ["paid"]
                                              ? Card(
                                                  color: constantValues
                                                      .successColor,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text("PAID",
                                                        style: fontStyle3),
                                                  ),
                                                )
                                              : Card(
                                                  color:
                                                      constantValues.errorColor,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text("PoD",
                                                        style: fontStyle3),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      subtitle: OverflowBar(
                                        alignment: MainAxisAlignment.start,
                                        children: [
                                          Text("status: "),
                                          Card(
                                              color: constantValues
                                                              .activeOrders[
                                                          index]["status"] ==
                                                      "en-route"
                                                  ? constantValues.tealColor
                                                  : constantValues.errorColor,
                                              child: Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                    (constantValues.activeOrders[
                                                                index]["status"]
                                                            as String)
                                                        .toUpperCase(),
                                                    style: fontStyle3),
                                              )),
                                        ],
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              "${currencyIcon(context).currencySymbol}${constantValues.activeOrders[index]["total"]}",
                                              style: fontStyle1),
                                          Text(
                                              "${(constantValues.activeOrders[index]["items"] as List).length} items",
                                              style: fontStyle2)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1),
                                      child: Divider(),
                                    ),
                                    constantValues.activeOrders[index]
                                                ["status"] !=
                                            "en-route"
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.02),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ButtonC2(
                                                    width: size.width * 0.2,
                                                    text: "Track",
                                                    onpress: () {
                                                      _track(index);
                                                    }),
                                                ButtonC(
                                                    width: size.width * 0.2,
                                                    text: "Cancel",
                                                    onpress: () {
                                                      cancelConfirmation(
                                                          context, index);
                                                    })
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.02),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "ETA: ${constantValues.activeOrders[index]["estimatedduration"]} minutes",
                                                    style: fontStyle2),
                                                ButtonC2(
                                                    width: size.width * 0.2,
                                                    text: "Track",
                                                    onpress: () {
                                                      _track(index);
                                                    }),
                                              ],
                                            ),
                                          ),
                                    SizedBox(height: size.height * 0.01),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Image.asset("assets/icons/empty.png",
                        height: size.height * 0.1)),
            // Completed
            constantValues.completedOrders.isNotEmpty
                ? SizedBox(
                    child: RefreshIndicator(
                      onRefresh: _refreshCompleted,
                      child: ListView.builder(
                        itemCount: constantValues.completedOrders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005,
                                horizontal: size.width * 0.02),
                            child: Card(
                                elevation: 4,
                                child: Column(
                                  children: [
                                    SizedBox(height: size.height * 0.01),
                                    ListTile(
                                      leading: ProfilePicture(
                                        image: (constantValues
                                                .completedOrders[index]["items"]
                                            as List)[0]["coverimage"]["url"],
                                        radius: 30,
                                        onClicked: () {},
                                      ),
                                      title: Text(
                                          "Order ID: ${constantValues.completedOrders[index]["orderid"]}",
                                          style: fontStyle1),
                                      subtitle: OverflowBar(
                                        alignment: MainAxisAlignment.start,
                                        children: [
                                          Text("status: "),
                                          Card(
                                              color:
                                                  constantValues.successColor,
                                              child: Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                    (constantValues.completedOrders[
                                                                index]["status"]
                                                            as String)
                                                        .toUpperCase(),
                                                    style: fontStyle3),
                                              )),
                                        ],
                                      ),
                                      trailing: Text(
                                          "${constantValues.completedOrders[index]["dateplaced"]}",
                                          style: fontStyle2),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.02),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ButtonC(
                                              width: size.width * 0.2,
                                              text: "Rate",
                                              onpress: () {
                                                ratingConfirmation(
                                                    context, index);
                                              }),
                                          ButtonC2(
                                              width: size.width * 0.25,
                                              text: "Re-order",
                                              onpress: () async {
                                                await _reOrder(index);
                                              }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Image.asset("assets/icons/empty.png",
                        height: size.height * 0.1)),
            // Cancelled
            constantValues.cancelledOrders.isNotEmpty
                ? SizedBox(
                    child: RefreshIndicator(
                      onRefresh: _refreshCancelled,
                      child: ListView.builder(
                        itemCount: constantValues.cancelledOrders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005,
                                horizontal: size.width * 0.02),
                            child: Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: ProfilePicture(
                                    image: (constantValues
                                            .cancelledOrders[index]["items"]
                                        as List)[0]["coverimage"]["url"],
                                    radius: 30,
                                    onClicked: () {},
                                  ),
                                  title: Text(
                                      "Order ID: ${constantValues.cancelledOrders[index]["orderid"]}",
                                      style: fontStyle1),
                                  subtitle: OverflowBar(
                                    alignment: MainAxisAlignment.start,
                                    children: [
                                      Text("status: "),
                                      Card(
                                          child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                            (constantValues
                                                        .cancelledOrders[index]
                                                    ["status"] as String)
                                                .toUpperCase(),
                                            style: fontStyle3b),
                                      )),
                                    ],
                                  ),
                                  trailing: Text(
                                      "${constantValues.cancelledOrders[index]["dateplaced"]}",
                                      style: fontStyle2),
                                )),
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Image.asset("assets/icons/empty.png",
                        height: size.height * 0.1))
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
    await _fetchMyOrders();
  }

  Future<void> _refreshCompleted() async {
    await _fetchMyOrders();
  }

  Future<void> _refreshCancelled() async {
    await _fetchMyOrders();
  }

  _track(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => Tracker(
              order: constantValues.activeOrders[index],
            )));
  }

  cancelConfirmation(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(textStyle: TextStyle());
    final fontStyle1c =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w300));
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
                    valueListenable: reasonValueNotifier,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                                "Hey Boss,\nWhy do you wish to cancel this order?",
                                style: fontStyle1),
                            trailing: IconButton(
                              icon: Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog1(
                                        title: Text(
                                            "It is important to note that not all cancelled orders will eventually result in a refund.\nFor more info, please visit our 'Policy>>Refund Policy' in your Profile.",
                                            style: fontStyle1c)));
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Card(
                            child: RadioListTile(
                              title: Text(reasonsForCancellation[0],
                                  style: fontStyle1b),
                              value: reasonsForCancellation[0],
                              groupValue: reasonValueNotifier.value,
                              onChanged: (value) {
                                setState(() {
                                  reasonValueNotifier.value = value;
                                });
                              },
                            ),
                          ),
                          Card(
                            child: RadioListTile(
                              title: Text(reasonsForCancellation[1],
                                  style: fontStyle1b),
                              value: reasonsForCancellation[1],
                              groupValue: reasonValueNotifier.value,
                              onChanged: (value) {
                                setState(() {
                                  reasonValueNotifier.value = value;
                                });
                              },
                            ),
                          ),
                          Card(
                            child: RadioListTile(
                              title: Text(reasonsForCancellation[2],
                                  style: fontStyle1b),
                              value: reasonsForCancellation[2],
                              groupValue: reasonValueNotifier.value,
                              onChanged: (value) {
                                setState(() {
                                  reasonValueNotifier.value = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          ListTile(
                            trailing: ButtonC2(
                                width: size.width * 0.22,
                                text: "Confirm",
                                onpress: () async {
                                  await _cancel(index);
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

  _cancel(index) async {
    if (reasonValueNotifier.value != null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      final email = constantValues.userData["email"];
      final orderid = constantValues.activeOrders[index]["orderid"];
      final reason = reasonValueNotifier.value;
      try {
        var response = await dio.post("$backendUrl/cancel-order", data: {
          "email": email,
          "orderid": orderid,
          "reason": reason,
        });
        if (response.data["success"]) {
          setState(() {
            reasonValueNotifier.value = null;
          });
          _fetchMyOrders();
          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } on DioError catch (error) {
        setState(() {
          reasonValueNotifier.value = null;
        });
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
          msg: error.response!.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
    } else {
      return Fluttertoast.showToast(
        msg: "Please select a reason for cancellation!",
        toastLength: Toast.LENGTH_LONG,
        webPosition: "center",
      );
    }
  }

  ratingConfirmation(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
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
                    valueListenable: reasonValueNotifier,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                                "Hey Boss,\nGuess you enjoyed your package..",
                                style: fontStyle1),
                          ),
                          SizedBox(height: size.height * 0.02),
                          RatingBar.builder(
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: size.width * 0.12,
                            itemPadding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.002),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              rating_ = rating;
                            },
                          ),
                          SizedBox(height: size.height * 0.02),
                          InputFieldB(
                            controller: reviewController,
                            width: size.width * 0.8,
                            title: "Write a review (optional)",
                            enabled: true,
                          ),
                          SizedBox(height: size.height * 0.02),
                          ListTile(
                            leading: ButtonC(
                                width: size.width * 0.22,
                                text: "Cancel",
                                onpress: () {
                                  setState(() {
                                    rating_ = null;
                                    reviewController.text = "";
                                  });
                                  Navigator.of(context).pop();
                                }),
                            trailing: ButtonC2(
                                width: size.width * 0.22,
                                text: "Confirm",
                                onpress: () async {
                                  await _rate(index, rating_);
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

  _rate(index, rating) async {
    if (rating_ != null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      for (var pack in constantValues.completedOrders[index]["items"]) {
        final email = constantValues.userData["email"];
        final packagename = pack["packagename"];
        final reviewer =
            "${(constantValues.userData["firstname"] as String).toTitleCase()} ${(constantValues.userData["lastname"] as String).toTitleCase()}";
        final review = reviewController.text.trim();
        try {
          var response = await dio.post("$backendUrl/rate-package", data: {
            "email": email,
            "packagename": packagename,
            "rating": rating,
            "reviewer": reviewer,
            "review": review,
          });
          if (response.data["success"]) {
            Fluttertoast.showToast(
              msg: response.data["message"],
              toastLength: Toast.LENGTH_LONG,
              webPosition: "center",
            );
          }
        } on DioError catch (error) {
          Navigator.of(context).pop();
          return Fluttertoast.showToast(
            msg: error.response!.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
        }
      }
      setState(() {
        rating_ = null;
        reviewController.text = "";
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      return Fluttertoast.showToast(
        msg: "Rating is required!",
        toastLength: Toast.LENGTH_LONG,
        webPosition: "center",
      );
    }
  }

  rateDispatcherConfirmation(BuildContext context, orderid) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    return showModalBottomSheet(
        isDismissible: false,
        context: context,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (context) {
          return SizedBox(
              height: size.height * 0.9,
              child: Column(
                children: [
                  ListTile(
                    title: Text("We're sure you've received your package..",
                        style: fontStyle1b),
                    trailing: IconButton(
                      tooltip: "close",
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _notNow(orderid);
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ProfilePicture(
                    radius: 40,
                    image: constantValues.dispatcherData["profileimage"]
                                ["url"] !=
                            ""
                        ? constantValues.dispatcherData["profileimage"]["url"]
                        : "assets/icons/user.png",
                    onClicked: () {
                      Navigator.of(context).push(OverlayBuilder(
                          builder: (context) => DisplayImage(
                              image: constantValues
                                              .dispatcherData["profileimage"]
                                          ["url"] !=
                                      ""
                                  ? NetworkImage(constantValues
                                      .dispatcherData["profileimage"]["url"])
                                  : AssetImage("assets/icons/user.png"))));
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                      "${(constantValues.dispatcherData["firstname"] as String).toTitleCase()} ${(constantValues.dispatcherData["lastname"] as String).toTitleCase()}",
                      style: fontStyle1b),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.5),
                    child: Divider(),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Text("Rate your  Dispatcher", style: fontStyle1),
                  SizedBox(height: size.height * 0.02),
                  RatingBar.builder(
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: size.width * 0.1,
                    itemPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.002),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: constantValues.successColor,
                    ),
                    onRatingUpdate: (rating) {
                      _rateDispatcher(rating, orderid);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
        });
  }

  _findDispatcher(email) async {
    try {
      var response = await dio.post("$backendUrl/dispatcher-info",
          data: {"dispatcherEmail": email});
      if (response.data["success"]) {
        setState(() {
          constantValues.dispatcherData = response.data["data"];
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

  _notNow(orderid) async {
    try {
      var response = await dio.post("$backendUrl/dont-rate-dispatcher", data: {
        "orderid": orderid,
      });
      if (response.data["success"]) {
        setState(() {
          constantValues.dispatcherData.clear();
        });
        return Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
    } on DioError catch (error) {
      return error;
    }
  }

  _rateDispatcher(rating, orderid) async {
    final dispatcher = constantValues.dispatcherData["email"];
    final email = constantValues.userData["email"];
    try {
      var response = await dio.post("$backendUrl/rate-dispatcher", data: {
        "dispatcherEmail": dispatcher,
        "email": email,
        "rating": rating,
        "orderid": orderid,
      });
      if (response.data["success"]) {
        setState(() {
          constantValues.dispatcherData.clear();
        });
        return Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
    } on DioError catch (error) {
      return error;
    }
  }

  _reOrder(int index) {
    setState(() {
      constantValues.cart.clear();
    });
    for (var pack in constantValues.completedOrders[index]["items"]) {
      if (pack["packagename"] == "Valentine" ||
          pack["packagename"] == "Newbie" ||
          pack["packagename"] == "Easter" ||
          pack["packagename"] == "Ramadan" ||
          pack["packagename"] == "Christmas") {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "The packages in this order cannot be re-ordered.\nThis is most likely because there is a discounted package that cannot be ordered more than once by a user.")));
      } else {
        setState(() {
          constantValues.cart.add(pack);
        });
        context.goNamed("cartalog");
      }
    }
  }

  _fetchMyOrders() async {
    final email = constantValues.userData["email"];
    try {
      var response =
          await dio.post("$backendUrl/my-orders", data: {"email": email});
      if (response.data["success"]) {
        setState(() {
          constantValues.activeOrders = response.data["dataActive"];
          constantValues.completedOrders = response.data["dataCompleted"];
          constantValues.cancelledOrders = response.data["dataCancelled"];
        });
        if (constantValues.completedOrders.isNotEmpty) {
          for (var order in constantValues.completedOrders) {
            if (order["deliveryreceipt"]) {
              await _findDispatcher(order["dispatcher"]);
              rateDispatcherConfirmation(context, order["orderid"]);
            }
          }
        }
      }
    } on DioError catch (error) {
      return error;
    }
  }
}
