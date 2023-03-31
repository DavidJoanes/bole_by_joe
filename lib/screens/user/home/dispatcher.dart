// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../controllers/route_controllers.dart';
import '../../../widgets/display_image.dart';
import '../../../widgets/overlay_builder.dart';
import '../../../widgets/profile_picture.dart';
import '../../resolution.dart';

class Dispatcher extends StatefulWidget {
  Dispatcher(
      {super.key, required this.dispatcher, required this.dispatcherRatings});
  final dispatcher;
  late List<dynamic> dispatcherRatings;

  @override
  State<Dispatcher> createState() => _DispatcherState();
}

class _DispatcherState extends State<Dispatcher> {
  final constantValues = Get.find<Constants>();
  late double dispatcherRating =
      widget.dispatcherRatings.reduce((a, b) => ((a + b))) /
          widget.dispatcherRatings.length;

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: secondaryAppBar(context, "Dispatcher Information", () {
        Navigator.of(context).pop();
      }),
      body: SafeArea(
        child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Resolution(
                desktopScreen: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: mixedScreen(context),
                ),
                mixedScreen: mixedScreen(context))),
      ),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontstyle1 = GoogleFonts.poppins(
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
    final fontstyle1b = GoogleFonts.poppins(
        textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12));
    return Column(
      children: [
        SizedBox(height: size.height * 0.08),
        ProfilePicture(
            image: widget.dispatcher["profileimage"]["url"] != ""
                ? widget.dispatcher["profileimage"]["url"]
                : "assets/icons/user.png",
            radius: 80,
            onClicked: () {
              Navigator.of(context).push(OverlayBuilder(
                  builder: (context) => DisplayImage(
                      image: widget.dispatcher["profileimage"]["url"] != ""
                          ? NetworkImage(
                              widget.dispatcher["profileimage"]["url"])
                          : AssetImage("assets/icons/user.png"))));
            }),
        SizedBox(height: size.height * 0.02),
        Column(
          children: [
            Text(
                "${(widget.dispatcher["firstname"] as String).toTitleCase()}  ${(widget.dispatcher["lastname"] as String).toTitleCase()}",
                style: fontstyle1),
            SizedBox(height: 5),
            OverflowBar(
              children: [
                Text(widget.dispatcher["phonenumber"], style: fontstyle1b),
                SizedBox(width: 10),
                IconButton(
                  tooltip: "Copy",
                  icon: Icon(Icons.copy,
                      size: 12, color: constantValues.primaryColor),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                            text: widget.dispatcher["phonenumber"]))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Phone number copied to clipboard")));
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: size.height * 0.04),
        midSection(context, widget.dispatcher)
      ],
    );
  }

  Widget midSection(BuildContext context, var dispatcher) {
    Size size = MediaQuery.of(context).size;
    final fontstyle2 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold));
    final fontstyle2b =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w300));
    final fontstyle2c =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500));
    return Column(
      children: [
        OverflowBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: constantValues.primaryColor,
                  child: Icon(Icons.star, color: constantValues.whiteColor),
                ),
                SizedBox(height: 2),
                Text(dispatcherRating.toStringAsFixed(1), style: fontstyle2),
                SizedBox(height: 2),
                Text("Rating", style: fontstyle2b),
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: constantValues.primaryColor,
                  child: Icon(Icons.shopify_outlined,
                      color: constantValues.whiteColor),
                ),
                SizedBox(height: 2),
                Text("${dispatcher["deliveries"]}", style: fontstyle2),
                SizedBox(height: 2),
                Text("Delivery", style: fontstyle2b),
              ],
            ),
          ],
        ),
        SizedBox(height: size.height * 0.1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Container(
            decoration: BoxDecoration(
              color: constantValues.greyColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text("Motorcycle Model", style: fontstyle2c),
                  trailing: Text(dispatcher["motorcyclemodel"]),
                ),
                Divider(),
                ListTile(
                  title: Text("Motorcycle Color", style: fontstyle2c),
                  trailing: Text(dispatcher["motorcyclecolor"]),
                ),
                Divider(),
                ListTile(
                  title: Text("Plate Number", style: fontstyle2c),
                  trailing: Text(dispatcher["motorcycleplatenumber"]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Column(
          children: [
            Text("Contact", style: fontstyle2),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 25,
              backgroundColor: constantValues.primaryColor,
              child: IconButton(
                tooltip: "Call",
                icon: Icon(Icons.call, color: constantValues.whiteColor),
                onPressed: () {
                  RouteTo.openPhone(dispatcher["phonenumber"]);
                },
              ),
            ),
            SizedBox(height: 10),
            Text("Call rider", style: fontstyle2b),
          ],
        ),
        SizedBox(height: size.height * 0.05),
      ],
    );
  }
}
