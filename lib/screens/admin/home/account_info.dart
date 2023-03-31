// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../controllers/route_controllers.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/display_image.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/overlay_builder.dart';
import '../../../widgets/profile_picture.dart';

class AccountInfo extends StatefulWidget {
  AccountInfo(
      {super.key,
      required this.accountType,
      required this.profileImage,
      required this.firstName,
      required this.lastName,
      required this.emailAddress,
      required this.phoneNumber,
      required this.ratings,
      required this.deliveries,
      required this.motorcycleModel,
      required this.motorcycleColor,
      required this.motorcyclePlateNumber,
      required this.isSuspended,
      required this.registrationDate});
  var accountType;
  var profileImage;
  var firstName;
  var lastName;
  var emailAddress;
  var phoneNumber;
  var ratings;
  var deliveries;
  var motorcycleModel;
  var motorcycleColor;
  var motorcyclePlateNumber;
  var isSuspended;
  var registrationDate;

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  TextEditingController modelController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  late List<dynamic> dispatcherRatings = widget.ratings as List<dynamic>;
  late double dispatcherRating =
      dispatcherRatings.reduce((a, b) => ((a + b))) / dispatcherRatings.length;

  @override
  void initState() {
    setState(() {
      modelController.text = widget.motorcycleModel;
      colorController.text = widget.motorcycleColor;
      plateNumberController.text = widget.motorcyclePlateNumber;
    });
    super.initState();
  }

  @override
  void dispose() {
    modelController.dispose();
    colorController.dispose();
    plateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryAppBar2(
            context,
            "Account Info",
            widget.accountType == "dispatcher"
                ? IconButton(
                    tooltip: "Save",
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      await _save();
                    })
                : SizedBox()),
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: mixedScreen(context))));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w300));
    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        ProfilePicture(
          radius: 60,
          image: widget.profileImage != ""
              ? widget.profileImage
              : "assets/icons/user.png",
          onClicked: () {
            Navigator.of(context).push(OverlayBuilder(
                builder: (context) => DisplayImage(
                    image: widget.profileImage.startsWith("a")
                        ? AssetImage(widget.profileImage)
                        : NetworkImage(widget.profileImage))));
          },
        ),
        SizedBox(height: size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "${(widget.firstName as String).toTitleCase()} ${(widget.lastName as String).toTitleCase()}",
                style: fontStyle1),
            SizedBox(width: 2),
            widget.isSuspended
                ? Icon(Icons.cancel, color: constantValues.errorColor, size: 12)
                : Icon(Icons.verified_user_rounded,
                    color: constantValues.successColor, size: 12)
          ],
        ),
        Text(widget.emailAddress, style: fontStyle1b),
        OverflowBar(
          children: [
            Text(widget.phoneNumber, style: fontStyle1b),
            SizedBox(width: 10),
            IconButton(
              tooltip: "Call",
              icon: Icon(Icons.call,
                  size: 14, color: constantValues.primaryColor),
              onPressed: () {
                RouteTo.openPhone(widget.phoneNumber);
              },
            )
          ],
        ),
        SizedBox(height: size.height * 0.02),
        widget.accountType == "dispatcher"
            ? OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: constantValues.primaryColor),
                      Text(dispatcherRating.toStringAsFixed(1),
                          style: fontStyle1),
                      Text("Rating", style: fontStyle1b),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.shopify_outlined),
                      Text("${widget.deliveries}", style: fontStyle1),
                      Text("Delivery", style: fontStyle1b),
                    ],
                  ),
                ],
              )
            : SizedBox(),
        SizedBox(height: size.height * 0.1),
        widget.accountType == "dispatcher"
            ? Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputFieldA2(
                        controller: modelController,
                        width: size.width * 0.8,
                        title: "Motorcycle model",
                        enabled: true,
                        hintIcon: Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: colorController,
                        width: size.width * 0.8,
                        title: "Motorcycle color",
                        enabled: true,
                        hintIcon: Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: plateNumberController,
                        width: size.width * 0.8,
                        title: "Motorcycle plate number",
                        enabled: true,
                        hintIcon: Text('')),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              )
            : SizedBox(),
        SizedBox(height: size.height * 0.05),
        ButtonA(
          width: size.width * 0.8,
          text1: widget.accountType == "user"
              ? "Convert to dispatcher"
              : "Convert to user",
          text2: "Processing..",
          isLoading: false,
          authenticate: () async {
            await _convert();
          },
        ),
        SizedBox(height: size.height * 0.03),
        ButtonA(
          width: size.width * 0.8,
          text1: widget.isSuspended ? "Unsuspend Account" : "Suspend Account",
          text2: "Processing..",
          isLoading: false,
          authenticate: () async {
            await _suspend();
          },
        ),
        SizedBox(height: size.height * 0.03),
        ButtonC2(
          width: size.width * 0.6,
          text: "Delete Account",
          onpress: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return Dialog2b(
                    title: Text("Confirmation"),
                    widget: Text(
                        "Do you wish to delete ${widget.emailAddress} account?\nThis cannot be undone!"),
                    buttons: [
                      TextButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _delete();
                        },
                      ),
                    ],
                  );
                });
          },
        ),
        SizedBox(height: size.height * 0.05),
      ],
    );
  }

  _convert() async {
    final email = widget.emailAddress;
    final adminEmail = constantValues.userData["email"];
    try {
      var response = await dio.post("$backendUrl2/convert-account", data: {
        "email": email,
        "adminEmail": adminEmail,
        "accounttype": widget.accountType == "user" ? "dispatcher" : "user",
      });
      if (response.data["success"]) {
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
    } on DioError catch (error) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }

  _suspend() async {
    final email = widget.emailAddress;
    final adminEmail = constantValues.userData["email"];
    try {
      var response = await dio.post("$backendUrl2/suspend-account", data: {
        "email": email,
        "adminEmail": adminEmail,
        "isSuspended": !widget.isSuspended,
      });
      if (response.data["success"]) {
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
    } on DioError catch (error) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }

  _delete() async {
    final email = widget.emailAddress;
    final adminEmail = constantValues.userData["email"];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    try {
      var response = await dio.post("$backendUrl2/delete-account", data: {
        "email": email,
        "adminEmail": adminEmail,
      });
      if (response.data["success"]) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
    } on DioError catch (error) {
      Navigator.of(context).pop();
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }

  _save() async {
    final email = widget.emailAddress;
    final adminEmail = constantValues.userData["email"];
    final model = modelController.text.trim();
    final color = colorController.text.trim();
    final platenumber = plateNumberController.text.trim();
    final form = _formKey.currentState!;
    if (form.validate()) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      try {
        var response = await dio.post("$backendUrl2/update-account", data: {
          "email": email,
          "adminEmail": adminEmail,
          "motorcyclemodel": model,
          "motorcyclecolor": color,
          "motorcycleplatenumber": platenumber,
        });
        if (response.data["success"]) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          return Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
        }
      } on DioError catch (error) {
        Navigator.of(context).pop();
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    }
  }
}
