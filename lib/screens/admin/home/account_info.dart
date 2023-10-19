// ignore_for_file:, prefer_typing_uninitialized_variables, must_be_immutable, use_build_context_synchronously 

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../controllers/route_controllers.dart';
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
  var userInfo = GetStorage();
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
              ? PopupMenuButton(
                  tooltip: "Menu",
                  onSelected: (value) async {
                    value.toLowerCase().contains("save")
                        ? await _save()
                        : value.toLowerCase().contains("convert")
                            ? await _convert()
                            : value.toLowerCase().contains("unsuspend") ||
                                    value.toLowerCase().contains("suspend")
                                ? await _suspend()
                                : showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog2b(
                                        title: const Text("Confirmation"),
                                        widget: Text(
                                            "Do you wish to delete ${widget.emailAddress} account?\nThis cannot be undone!"),
                                        buttons: [
                                          TextButton(
                                            child: const Text("No"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await _delete();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: "Save",
                        child: Text("Save"),
                      ),
                      PopupMenuItem(
                        value: widget.accountType == "user"
                            ? "Convert to dispatcher"
                            : "Convert to user",
                        child: Text(
                          widget.accountType == "user"
                              ? "Convert to dispatcher"
                              : "Convert to user",
                        ),
                      ),
                      PopupMenuItem(
                        value: widget.isSuspended
                            ? "Unsuspend account"
                            : "Suspend account",
                        child: Text(widget.isSuspended
                            ? "Unsuspend account"
                            : "Suspend account"),
                      ),
                      const PopupMenuItem(
                        value: "Delete account",
                        child: Text("Delete account"),
                      ),
                    ];
                  })
              : PopupMenuButton(
                  tooltip: "Menu",
                  onSelected: (value) async {
                    value.toLowerCase().contains("convert")
                        ? await _convert()
                        : value.toLowerCase().contains("unsuspend") ||
                                value.toLowerCase().contains("suspend")
                            ? await _suspend()
                            : showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Dialog2b(
                                    title: const Text("Confirmation"),
                                    widget: Text(
                                        "Do you wish to delete ${widget.emailAddress} account?\nThis cannot be undone!"),
                                    buttons: [
                                      TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await _delete();
                                        },
                                      ),
                                    ],
                                  );
                                });
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: widget.accountType == "user"
                            ? "Convert to dispatcher"
                            : "Convert to user",
                        child: Text(
                          widget.accountType == "user"
                              ? "Convert to dispatcher"
                              : "Convert to user",
                        ),
                      ),
                      PopupMenuItem(
                        value: widget.isSuspended
                            ? "Unsuspend account"
                            : "Suspend account",
                        child: Text(widget.isSuspended
                            ? "Unsuspend account"
                            : "Suspend account"),
                      ),
                      const PopupMenuItem(
                        value: "Delete account",
                        child: Text("Delete account"),
                      ),
                    ];
                  }),
        ),
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
    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        ProfilePicture(
          radius: 100,
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
            const SizedBox(width: 2),
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
            const SizedBox(width: 10),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: ListTile(
            title: const Text("Joined.."),
            subtitle: Text(widget.registrationDate),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        widget.accountType == "dispatcher"
            ? OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: constantValues.successColor),
                      Text(dispatcherRating.toStringAsFixed(1),
                          style: fontStyle1),
                      Text("Rating", style: fontStyle1b),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopify_outlined),
                      Text("${widget.deliveries}", style: fontStyle1),
                      Text("Delivery", style: fontStyle1b),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
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
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: colorController,
                        width: size.width * 0.8,
                        title: "Motorcycle color",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: plateNumberController,
                        width: size.width * 0.8,
                        title: "Motorcycle plate number",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              )
            : const SizedBox(),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }

  _convert() async {
    final email = widget.emailAddress;
    final adminEmail = userInfo.read("userData")["email"];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      var response = await dio.post("$backendUrl2/convert-account", data: {
        "email": email,
        "adminEmail": adminEmail,
        "accounttype": widget.accountType == "user" ? "dispatcher" : "user",
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

  _suspend() async {
    final email = widget.emailAddress;
    final adminEmail = userInfo.read("userData")["email"];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      var response = await dio.post("$backendUrl2/suspend-account", data: {
        "email": email,
        "adminEmail": adminEmail,
        "isSuspended": !widget.isSuspended,
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

  _delete() async {
    final email = widget.emailAddress;
    final adminEmail = userInfo.read("userData")["email"];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
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
    final adminEmail = userInfo.read("userData")["email"];
    final model = modelController.text.trim();
    final color = colorController.text.trim();
    final platenumber = plateNumberController.text.trim();
    final form = _formKey.currentState!;
    if (form.validate()) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
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
