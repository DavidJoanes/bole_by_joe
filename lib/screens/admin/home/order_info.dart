// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../widgets/app_bar.dart';
import '../../../controllers/controller.dart';
import '../../../controllers/route_controllers.dart';
import '../../../widgets/profile_picture.dart';

class OrderInfoAdmin extends StatefulWidget {
  OrderInfoAdmin({super.key, required this.order});
  var order;

  @override
  State<OrderInfoAdmin> createState() => _OrderInfoAdminState();
}

class _OrderInfoAdminState extends State<OrderInfoAdmin> {
  final constantValues = Get.find<Constants>();

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryAppBar(context, "Order Info", () {
          Navigator.of(context).pop();
        }),
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: mixedScreen(context))));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w300));
    final fontStyle1c = GoogleFonts.poppins(
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300));
    return Column(children: [
      SizedBox(height: size.height * 0.02),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: ListTile(
          title: Text("Order Id:", style: fontStyle1),
          subtitle: widget.order["paid"]
              ? Text("Mode of payment: PAID", style: fontStyle1b)
              : Text("Mode of payment: PoD", style: fontStyle1b),
          trailing:
              Text(widget.order["orderid"].toString(), style: fontStyle1b),
        ),
      ),
      SizedBox(height: size.height * 0.02),
      ListTile(
        leading: Text("STATUS OF ORDER", style: fontStyle1),
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Container(
              decoration: BoxDecoration(
                color: constantValues.greyColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(children: [
                ListTile(
                  title: Text("Status:", style: fontStyle1),
                  trailing: Card(
                      color: widget.order["status"] == "awaiting rider"
                          ? constantValues.yellowColor
                          : widget.order["status"] == "en-route"
                              ? constantValues.tealColor
                              : widget.order["status"] == "delivered"
                                  ? constantValues.successColor
                                  : constantValues.errorColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                            (widget.order["status"] as String).toUpperCase(),
                            style: fontStyle1c),
                      )),
                ),
                widget.order["reasonforcancellation"] != ""
                    ? ListTile(
                        title: Text(widget.order["reasonforcancellation"],
                            style: fontStyle1),
                        subtitle:
                            Text("Reason for cancellation", style: fontStyle1b),
                      )
                    : const SizedBox(),
              ]))),
      SizedBox(height: size.height * 0.02),
      ListTile(
        leading: Text("OWNER DETAILS", style: fontStyle1),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: constantValues.greyColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(children: [
            ListTile(
              title: Text(widget.order["ownerfullname"], style: fontStyle1),
              subtitle: Text(widget.order["owneremail"], style: fontStyle1b),
              trailing: IconButton(
                tooltip: "Call",
                icon: Icon(Icons.call,
                    size: 14, color: constantValues.primaryColor),
                onPressed: () {
                  RouteTo.openPhone(widget.order["ownerphonenumber"]);
                },
              ),
            ),
            ListTile(
              title: Text("Delivery address",
                  style: fontStyle1),
              subtitle: Text(
                  widget.order["deliveryaddress"] != ""
                      ? widget.order["deliveryaddress"]
                      : "None (Most likely on-site)", style: fontStyle1b),
            ),
            ListTile(
              title: Text("Closest landmark", style: fontStyle1),
              subtitle: Text(
                  widget.order["closestlandmark"] != ""
                      ? widget.order["closestlandmark"]
                      : "--",
                  style: fontStyle1b),
            ),
            ListTile(
              title: Text("Apartment", style: fontStyle1),
              subtitle: Text(
                  widget.order["apartment"] != ""
                      ? widget.order["apartment"]
                      : "--",
                  style: fontStyle1b),
            ),
            ListTile(
              title: Text("City", style: fontStyle1),
              subtitle: Text(
                  widget.order["city"] != "" ? widget.order["city"] : "--",
                  style: fontStyle1b),
            ),
            ListTile(
              title: Text("Province", style: fontStyle1),
              subtitle: Text(
                  widget.order["province"] != ""
                      ? widget.order["province"]
                      : "--",
                  style: fontStyle1b),
            ),
            ListTile(
              title: Text("Country", style: fontStyle1),
              subtitle: Text(
                  widget.order["city"] != "" ? widget.order["country"] : "--",
                  style: fontStyle1b),
            ),
          ]),
        ),
      ),
      SizedBox(height: size.height * 0.02),
      ListTile(
        leading: Text("ORDER TIMELINE", style: fontStyle1),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: constantValues.greyColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(children: [
            ListTile(
              title: Text("Date placed", style: fontStyle1),
              subtitle: Text(
                  "Time: ${widget.order["timeplaced"].split(".")[0]}",
                  style: fontStyle1b),
              trailing:
                  Text("${widget.order["dateplaced"]}", style: fontStyle1b),
            ),
            ListTile(
              title: Text("Date accepted", style: fontStyle1),
              subtitle: Text(
                  "Time: ${widget.order["timeaccepted"].split(".")[0]}",
                  style: fontStyle1b),
              trailing:
                  Text("${widget.order["dateaccepted"]}", style: fontStyle1b),
            ),
            ListTile(
              title: Text("Date delivered", style: fontStyle1),
              subtitle: Text("Time: ${widget.order["estimatedtime"]}",
                  style: fontStyle1b),
              trailing:
                  Text("${widget.order["estimateddate"]}", style: fontStyle1b),
            ),
            ListTile(
              title: Text("Dispatcher", style: fontStyle1),
              subtitle: Text(
                  widget.order["dispatcher"] != ""
                      ? widget.order["dispatcher"]
                      : "--",
                  style: fontStyle1b),
              trailing: IconButton(
                tooltip: "Copy",
                icon: Icon(Icons.copy,
                    size: 14, color: constantValues.primaryColor),
                onPressed: () async {
                  await Clipboard.setData(
                          ClipboardData(text: "${widget.order["dispatcher"]}"))
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Dispatcher email copied to clipboard")));
                  });
                },
              ),
            ),
          ]),
        ),
      ),
      SizedBox(height: size.height * 0.02),
      ListTile(
        leading: Text("PACKAGES ORDERED", style: fontStyle1),
        trailing: OverflowBar(
          children: [
            const Text("Total: "),
            Text(
                "${currencyIcon(context).currencySymbol}${widget.order["total"]}"),
          ],
        ),
      ),
      SizedBox(
        height: size.height * 0.4,
        child: ListView.builder(
            itemCount: widget.order["items"].length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.01,
                    horizontal: size.width * 0.04),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    leading: ProfilePicture(
                      image: widget.order["items"][index]["coverimage"]["url"],
                      radius: 20,
                      onClicked: () {},
                    ),
                    title: Text(widget.order["items"][index]["packagename"]),
                    subtitle:
                        Text("Qty: ${widget.order["items"][index]['qty']}"),
                    trailing: Text(
                        "${currencyIcon(context).currencySymbol}${widget.order["items"][index]['price']}"),
                  ),
                ),
              );
            }),
      ),
    ]);
  }
}
