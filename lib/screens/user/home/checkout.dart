// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../screens/resolution.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../controllers/paystack_integration.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/input_fields.dart';

final globalBucket = PageStorageBucket();

class CheckOut extends StatefulWidget {
  const CheckOut({super.key, required this.subTotal});
  final int subTotal;

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  var currentTime = DateTime.now();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final apartmentController = TextEditingController();
  final landmarkController = TextEditingController();
  bool loading = false;
  bool podEligibility = false;
  int deliveryFee = 1500;
  int total = 0;

  var nameOfLocations = {
    "",
    "None",
    "Enter an address",
  };
  DropdownMenuItem<String> buildnameOfLocations(String loc) => DropdownMenuItem(
      value: loc,
      child: Text(
        loc,
      ));

  var modeOfPayments = {"", "Pay now", "Pay on delivery"};
  DropdownMenuItem<String> buildmodeOfPayments(String mop) => DropdownMenuItem(
      value: mop,
      child: Text(
        mop,
      ));

  String _generateRef() {
    final randomRef = Random().nextInt(999999);
    return "bbj-$randomRef";
  }

  _generateId() {
    return Random().nextInt(9999999);
  }

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  @override
  void initState() {
    setState(() {
      cityController.text = userInfo.read("city");
    });
    setState(() {
      total = widget.subTotal;
    });
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      constantValues.nameOfLocation = null;
      constantValues.modeOfPayment = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageStorage(
      bucket: globalBucket,
      child: Scaffold(
        appBar: secondaryAppBar(context, "Checkout", () {
          Navigator.of(context).pop();
        }),
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Resolution(
                    desktopScreen: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.15),
                        child: mixedScreen(context)),
                    mixedScreen: mixedScreen(context)))),
      ),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w300));
    return !loading
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Column(children: [
              SizedBox(height: size.height * 0.1),
              Image.asset(
                userInfo.read("isDarkTheme")
                    ? "assets/icons/logo3b.png"
                    : "assets/icons/logob.png",
                height: size.height * 0.07,
              ),
              SizedBox(height: size.height * 0.05),
              OverflowBar(
                children: [
                  OverflowBar(
                    children: [
                      IconButton(
                tooltip: "Info",
                        icon: Icon(Icons.info_outline,
                            color: constantValues.errorColor),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog1(
                                  title: Text(
                                      """MODE OF PAYMENT:\nPlease note that to be eligible for 'Pay on Delivery(PoD)' feature, you must have at least ten(10) successful orders made priviously.
                                                \n\nDELIVERY DESTINATION:\nPlease note that 'None' as a delivery destination simply means that you are currently in person at any of our respective shops when making this payment, and as such your order won't require delivery and will immediately be marked as 'delivered'. Please visit our 'Policy>>Payment Policy' in your profile to get more information about our policies.
                                                \n\nDELIVERY FEE:\nPlease, note that delivery fee for addresses within Alakahia and Choba is subsidized at ${currencyIcon(context).currencySymbol}500.00, while the delivery fee for addresses outside these two locations is fixed at ${currencyIcon(context).currencySymbol}1,500.00""",
                                      style: fontStyle1b)));
                        },
                      ),
                      OverflowBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: const Text("Mode of payment"),
                              subtitle: Card(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: constantValues.modeOfPayment,
                                        items: modeOfPayments
                                            .map(buildmodeOfPayments)
                                            .toList(),
                                        onChanged: (value) async {
                                          setState(() {
                                            constantValues.modeOfPayment =
                                                value!;
                                          });
                                          value == "Pay on delivery"
                                              ? await _checkForPod()
                                              : null;
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
                              title: const Text("Delivery destination"),
                              subtitle: Card(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: constantValues.nameOfLocation,
                                        items: nameOfLocations
                                            .map(buildnameOfLocations)
                                            .toList(),
                                        onChanged: (value) async {
                                          setState(() {
                                            constantValues.nameOfLocation =
                                                value!;
                                          });
                                          value != "" && value != "None"
                                              ? setState(() {
                                                  total = widget.subTotal +
                                                      deliveryFee;
                                                })
                                              : setState(() {
                                                  total = widget.subTotal;
                                                });
                                        }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              constantValues.nameOfLocation == "Enter an address"
                  ? Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.02),
                          Container(
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: const Text("Country"),
                              subtitle: Text(userInfo.read("country")),
                              trailing: const Icon(Icons.arrow_drop_down_outlined),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Container(
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: const Text("Province"),
                              subtitle: Text(userInfo.read("province")),
                              trailing: const Icon(Icons.arrow_drop_down_outlined),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          InputFieldA2(
                            controller: cityController,
                            width: size.width * 0.8,
                            title: "City",
                            enabled: false,
                            hintIcon: const Text(''),
                          ),
                          SizedBox(height: size.height * 0.02),
                          InputFieldA2(
                            controller: addressController,
                            width: size.width * 0.8,
                            title: "Address",
                            enabled: true,
                            hintIcon: const Text(''),
                          ),
                          SizedBox(height: size.height * 0.02),
                          InputFieldA2(
                            controller: landmarkController,
                            width: size.width * 0.8,
                            title: "Closet landmark",
                            enabled: true,
                            hintIcon: const Text(''),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: size.height * 0.02),
              constantValues.nameOfLocation == "Enter an address"
                  ? InputFieldA2(
                      controller: apartmentController,
                      width: size.width * 0.8,
                      title: "Apartment/Suite (optional)",
                      enabled: true,
                      hintIcon: const Text(''),
                    )
                  : const SizedBox(),
              SizedBox(height: size.height * 0.05),
              Container(
                decoration: BoxDecoration(
                  color: constantValues.greyColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Subtotal"),
                      trailing: Text(
                          "${currencyIcon(context).currencySymbol}${widget.subTotal}"),
                    ),
                    constantValues.nameOfLocation != null &&
                            constantValues.nameOfLocation != "" &&
                            constantValues.nameOfLocation != "None"
                        ? ListTile(
                            title: const Text("Delivery Fee"),
                            trailing: Text(
                                "${currencyIcon(context).currencySymbol}$deliveryFee"),
                          )
                        : const SizedBox(),
                    const Divider(),
                    ListTile(
                      title: Text("Total", style: fontStyle1),
                      trailing: Text(
                          "${currencyIcon(context).currencySymbol}$total",
                          style: fontStyle1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: OverflowBar(
                      children: const [
                        Icon(Icons.keyboard_backspace_outlined),
                        SizedBox(width: 5),
                        Text("Return to cart"),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ButtonC2(
                      width: size.width * 0.3,
                      text: "Pay",
                      onpress: () async {
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //         "We're sorry, but payments are suspended for now.\nWe'll rectify this as soon as we can.")));
                        podEligibility &&
                                constantValues.modeOfPayment ==
                                    "Pay on delivery"
                            ? await _pay3()
                            : constantValues.nameOfLocation != "None"
                                ? await _pay()
                                : await _pay2();
                      })
                ],
              ),
              SizedBox(height: size.height * 0.05),
            ]))
        : const Center(child: CircularProgressIndicator());
  }

  _checkForPod() async {
    final email = userInfo.read("userData")["email"];
    try {
      var response = await dio.post("$backendUrl/check-for-pod-eligibility",
          data: {"email": email});
      if (response.data["success"] == "true") {
        setState(() {
          podEligibility = true;
        });
        return Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      } else if (response.data["success"] == "not-eligible") {
        setState(() {
          podEligibility = false;
        });
        return Fluttertoast.showToast(
          msg: "You are not eligible for this feature!",
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
    } on DioError catch (error) {
      return Fluttertoast.showToast(
        msg: error.response!.data["message"],
        toastLength: Toast.LENGTH_LONG,
        webPosition: "center",
      );
    }
  }

  //Payment for clients whose order(s) are to be delivered and aren't eligible for PoD feature
  _pay() async {
    if (constantValues.modeOfPayment != null &&
        constantValues.modeOfPayment != "") {
      if (constantValues.modeOfPayment == "Pay on delivery" &&
          podEligibility == false) {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You're not eligible for PoD feature!")));
      } else {
        if (constantValues.nameOfLocation != null &&
            constantValues.nameOfLocation != "") {
          final form = _formKey.currentState!;
          if (form.validate()) {
            final email = userInfo.read("userData")["email"];
            final orderid = _generateId();
            final fullname =
                "${(userInfo.read("userData")["firstname"] as String).toTitleCase()} ${(userInfo.read("userData")["lastname"] as String).toTitleCase()}";
            final phone = userInfo.read("userData")["phonenumber"];
            final address = addressController.text.trim();
            final landmark = landmarkController.text.trim();
            final apartment = apartmentController.text.trim();
            final city = cityController.text.trim();
            final province = userInfo.read("province");
            final country = userInfo.read("country");
            if ((address.toLowerCase()).contains("choba") ||
                (address.toLowerCase()).contains("alakahia") ||
                (address.toLowerCase()).contains("uniport")) {
              setState(() {
                deliveryFee = 500;
                total = widget.subTotal + deliveryFee;
              });
            }
            var response1 =
                await dio.post("$backendUrl/validate-orderid", data: {
              "orderid": orderid,
            });
            if (int.parse(currentTime.toString().split(" ")[1].split(":")[0]) >
                13) {
              return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Invalid timing!\nSorry, but you aren't allowed to place an order after 13:59 (WAT)")));
            } else {
              if (response1.data["success"]) {
                await PaystackPopup.openPaystackPopup(
                    email: email,
                    amount: "${total}00",
                    ref: _generateRef(),
                    onClosed: () {
                      debugPrint("Error occured!");
                    },
                    onSuccess: () async {
                      userInfo.read("tempItemsOrdered").clear();
                      userInfo.read("cart").forEach((element) {
                        userInfo.read("tempItemsOrdered").add(element);
                      });
                      try {
                        var response2 =
                            await dio.post("$backendUrl/place-order", data: {
                          "email": email,
                          "orderid": orderid,
                          "status": "awaiting rider",
                          "owneremail": email,
                          "ownerfullname": fullname,
                          "ownerphonenumber": phone,
                          "deliveryaddress": address,
                          "closestlandmark": landmark,
                          "apartment": apartment,
                          "city": city,
                          "province": province,
                          "country": country,
                          "paid": podEligibility &&
                                  constantValues.modeOfPayment ==
                                      "Pay on delivery"
                              ? false
                              : true,
                          "items": userInfo.read("tempItemsOrdered"),
                          "total": total,
                        });
                        if (response2.data["success"]) {
                          Navigator.of(context).pop();
                          userInfo.read("cart").clear();
                          Fluttertoast.showToast(
                            msg: response2.data["message"],
                            toastLength: Toast.LENGTH_LONG,
                            webPosition: "center",
                          );
                          context.goNamed("home");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response2.data["message"])));
                        }
                      } on DioError catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(error.response!.data["message"])));
                      }
                    });
              } else {
                Navigator.of(context).pop();
                return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Please, try again!\n${response1.data["message"]}")));
              }
            }
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Select a destination!")));
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select a mode of payment!")));
    }
  }

  //Payment for clients who are present at any of our stores and won't require us to deliver their order
  _pay2() async {
    if (constantValues.modeOfPayment != null &&
        constantValues.modeOfPayment != "") {
      if (constantValues.modeOfPayment == "Pay on delivery" &&
          podEligibility == false) {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You're not eligible for PoD feature!")));
      } else {
        if (constantValues.nameOfLocation == "None") {
          if (constantValues.modeOfPayment == "Pay on delivery" &&
              constantValues.nameOfLocation == "None") {
            return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Invalid combination!\nYou must pay now if your delivery destination is 'None'.")));
          } else {
            final orderid = _generateId();
            final email = userInfo.read("userData")["email"];
            final fullname =
                "${(userInfo.read("userData")["firstname"] as String).toTitleCase()} ${(userInfo.read("userData")["lastname"] as String).toTitleCase()}";
            final phone = userInfo.read("userData")["phonenumber"];
            userInfo.read("tempItemsOrdered").clear();
            userInfo.read("cart").forEach((element) {
              userInfo.read("tempItemsOrdered").add(element);
            });
            var response1 =
                await dio.post("$backendUrl/validate-orderid", data: {
              "orderid": orderid,
            });
            if (int.parse(currentTime.toString().split(" ")[1].split(":")[0]) >
                13) {
              return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Invalid timing!\nSorry, but you aren't allowed to place an order after 13:59 (WAT)")));
            } else {
              if (response1.data["success"]) {
                await PaystackPopup.openPaystackPopup(
                    email: email,
                    amount: "${total}00",
                    ref: _generateRef(),
                    onClosed: () {
                      debugPrint("Error occured!");
                    },
                    onSuccess: () async {
                      try {
                        var response2 =
                            await dio.post("$backendUrl/place-order", data: {
                          "email": email,
                          "orderid": orderid,
                          "status": "delivered",
                          "owneremail": email,
                          "ownerfullname": fullname,
                          "ownerphonenumber": phone,
                          "deliveryaddress": "",
                          "closestlandmark": "",
                          "apartment": "",
                          "city": "",
                          "province": "",
                          "country": "",
                          "paid": podEligibility &&
                                  constantValues.modeOfPayment ==
                                      "Pay on delivery"
                              ? false
                              : true,
                          "items": userInfo.read("tempItemsOrdered"),
                          "total": total,
                        });
                        if (response2.data["success"]) {
                          Navigator.of(context).pop();
                          userInfo.read("cart").clear();
                          Fluttertoast.showToast(
                            msg: response2.data["message"],
                            toastLength: Toast.LENGTH_LONG,
                            webPosition: "center",
                          );
                          context.goNamed("home");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response2.data["message"])));
                          await _pay();
                        }
                      } on DioError catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(error.response!.data["message"])));
                      }
                    });
              } else {
                Navigator.of(context).pop();
                return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Please, try again!\n${response1.data["message"]}")));
              }
            }
          }
        } else {
          return ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Select a destination!")));
        }
      }
    } else {
      return ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select a mode of payment!")));
    }
  }

  //Payment for clients who are eligible and have chosen the PoD feature
  _pay3() async {
    if (constantValues.modeOfPayment != null &&
        constantValues.modeOfPayment != "") {
      if (constantValues.modeOfPayment == "Pay on delivery" &&
          podEligibility == false) {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You're not eligible for PoD feature!")));
      } else {
        if (constantValues.nameOfLocation != null &&
            constantValues.nameOfLocation != "") {
          final form = _formKey.currentState!;
          if (form.validate()) {
            final email = userInfo.read("userData")["email"];
            final orderid = _generateId();
            final fullname =
                "${(userInfo.read("userData")["firstname"] as String).toTitleCase()} ${(userInfo.read("userData")["lastname"] as String).toTitleCase()}";
            final phone = userInfo.read("userData")["phonenumber"];
            final address = addressController.text.trim();
            final landmark = landmarkController.text.trim();
            final apartment = apartmentController.text.trim();
            final city = cityController.text.trim();
            final province = userInfo.read("province");
            final country = userInfo.read("country");
            if ((address.toLowerCase()).contains("choba") ||
                (address.toLowerCase()).contains("alakahia") ||
                (address.toLowerCase()).contains("uniport")) {
              setState(() {
                deliveryFee = 500;
                total = widget.subTotal + deliveryFee;
              });
            }
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return const Center(child: CircularProgressIndicator());
                });
            var response1 =
                await dio.post("$backendUrl/validate-orderid", data: {
              "orderid": orderid,
            });
            if (int.parse(currentTime.toString().split(" ")[1].split(":")[0]) >
                13) {
              Navigator.of(context).pop();
              return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Invalid timing!\nSorry, but you aren't allowed to place an order after 13:59 (WAT)")));
            } else {
              if (response1.data["success"]) {
                userInfo.read("tempItemsOrdered").clear();
                userInfo.read("cart").forEach((element) {
                  userInfo.read("tempItemsOrdered").add(element);
                });
                try {
                  var response2 =
                      await dio.post("$backendUrl/place-order", data: {
                    "email": email,
                    "orderid": orderid,
                    "status": "awaiting rider",
                    "owneremail": email,
                    "ownerfullname": fullname,
                    "ownerphonenumber": phone,
                    "deliveryaddress": address,
                    "closestlandmark": landmark,
                    "apartment": apartment,
                    "city": city,
                    "province": province,
                    "country": country,
                    "paid": podEligibility &&
                            constantValues.modeOfPayment == "Pay on delivery"
                        ? false
                        : true,
                    "items": userInfo.read("tempItemsOrdered"),
                    "total": total,
                  });
                  if (response2.data["success"]) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    userInfo.read("cart").clear();
                    Fluttertoast.showToast(
                      msg: response2.data["message"],
                      toastLength: Toast.LENGTH_LONG,
                      webPosition: "center",
                    );
                    context.goNamed("home");
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response2.data["message"])));
                  }
                } on DioError catch (error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.response!.data["message"])));
                }
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Please, try again!\n${response1.data["message"]}")));
              }
            }
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Select a destination!")));
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select a mode of payment!")));
    }
  }
}
