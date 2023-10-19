// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/profile_picture.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/input_fields.dart';
import 'package_info.dart';

final globalBucket = PageStorageBucket();

class AllPackages extends StatefulWidget {
  const AllPackages({super.key});

  @override
  State<AllPackages> createState() => _AllPackagesState();
}

class _AllPackagesState extends State<AllPackages> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController packageNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController text1Controller = TextEditingController();
  TextEditingController text2Controller = TextEditingController();
  TextEditingController text3Controller = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  String? availability;
  late ValueNotifier availabilityValueNotifier = ValueNotifier(availability);

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  var availabilityOptions = [
    "Available",
    "Unavailable",
  ];

  @override
  void initState() {
    _fetchAllPacks();
    super.initState();
  }

  @override
  void dispose() {
    packageNameController.dispose();
    descriptionController.dispose();
    text1Controller.dispose();
    text2Controller.dispose();
    text3Controller.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageStorage(
      bucket: globalBucket,
      child: Scaffold(
          floatingActionButton: SpeedDial(
              backgroundColor: userInfo.read("isDarkTheme")
                  ? constantValues.blackColor
                  : constantValues.primaryColor,
              foregroundColor: constantValues.whiteColor,
              overlayColor: constantValues.blackColor,
              spacing: size.height * 0.02,
              spaceBetweenChildren: size.height * 0.01,
              overlayOpacity: 0.5,
              tooltip: "Add a new package",
              icon: Icons.add,
              onPress: () {
                _addNewPackage(size);
              }),
          appBar: primaryAppBar(context, "All Packages"),
          body: SafeArea(
              child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: mixedScreen(context)))),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w400));
    return SizedBox(
      height: size.height * 0.95,
      child: userInfo.read("allPackages").isNotEmpty
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                        key: const PageStorageKey<String>("allPackages"),
                itemCount: userInfo.read("allPackages").length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.005,
                        horizontal: size.width * 0.02),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: ProfilePicture(
                          radius: 30,
                          image: userInfo.read("allPackages")[index]["coverimage"]
                              ["url"],
                          onClicked: () {},
                        ),
                        title: Text(
                            userInfo.read("allPackages")[index]["packagename"],
                            style: fontStyle1),
                        subtitle: Row(
                          children: [
                            const Text("available: "),
                            userInfo.read("allPackages")[index]["available"]
                                ? Icon(Icons.check_circle_outline,
                                    size: 12,
                                    color: constantValues.successColor)
                                : Icon(Icons.cancel_outlined,
                                    size: 12, color: constantValues.errorColor)
                          ],
                        ),
                        trailing: Text(
                            "${currencyIcon(context).currencySymbol}${userInfo.read("allPackages")[index]["price"]}"),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PackageInfo(
                                    packageCoverImage:
                                        userInfo.read("allPackages")[index]
                                            ["coverimage"]["url"],
                                    packageImages: userInfo.read("allPackages")[index]["images"],
                                    packageName: userInfo.read("allPackages")[index]["packagename"],
                                    description: userInfo.read("allPackages")[index]["description"],
                                    text1: userInfo.read("allPackages")[index]
                                        ["text1"],
                                    text2: userInfo.read("allPackages")[index]
                                        ["text2"],
                                    text3: userInfo.read("allPackages")[index]
                                        ["text3"],
                                    price: userInfo.read("allPackages")[index]
                                        ["price"],
                                    discount: userInfo.read("allPackages")[index]
                                        ["discount"],
                                    rating: userInfo.read("allPackages")[index]
                                        ["ratings"],
                                    reviews: userInfo.read("allPackages")[index]
                                        ["reviews"],
                                    availability: userInfo.read("allPackages")[index]["available"],
                                  )));
                        },
                      ),
                    ),
                  ).animate().fade().slideX(curve: Curves.bounceIn);
                },
              ),
            )
          : Center(child: Text("No package found..", style: fontStyle1b)),
    );
  }

  _addNewPackage(size) {
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w300));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog2b(
            title: Text("Add Package", style: fontStyle1),
            widget: Column(children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputFieldA2(
                        controller: packageNameController,
                        width: size.width * 0.8,
                        title: "Package name",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldC(
                        controller: descriptionController,
                        width: size.width * 0.8,
                        title: "Description",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: text1Controller,
                        width: size.width * 0.8,
                        title: "First text",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: text2Controller,
                        width: size.width * 0.8,
                        title: "Second text",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: text3Controller,
                        width: size.width * 0.8,
                        title: "Third text",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: priceController,
                        width: size.width * 0.8,
                        title: "Price",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    InputFieldA2(
                        controller: discountController,
                        width: size.width * 0.8,
                        title: "Discount",
                        enabled: true,
                        hintIcon: const Text('')),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                      width: size.width * 0.8,
                      child: Card(
                        child: ValueListenableBuilder(
                            valueListenable: availabilityValueNotifier,
                            builder: (context, value, _) {
                              return Column(
                                children: [
                                  Card(
                                    child: RadioListTile(
                                      title: Text(availabilityOptions[0],
                                          style: fontStyle1b),
                                      value: availabilityOptions[0],
                                      groupValue:
                                          availabilityValueNotifier.value,
                                      onChanged: (value) {
                                        setState(() {
                                          availabilityValueNotifier.value =
                                              value;
                                        });
                                      },
                                    ),
                                  ),
                                  Card(
                                    child: RadioListTile(
                                      title: Text(availabilityOptions[1],
                                          style: fontStyle1b),
                                      value: availabilityOptions[1],
                                      groupValue:
                                          availabilityValueNotifier.value,
                                      onChanged: (value) {
                                        setState(() {
                                          availabilityValueNotifier.value =
                                              value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ]),
            buttons: [
              TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    setState(() {
                      packageNameController.text = "";
                      descriptionController.text = "";
                      text1Controller.text = "";
                      text2Controller.text = "";
                      text3Controller.text = "";
                      priceController.text = "";
                      discountController.text = "";
                      availabilityValueNotifier.value = null;
                    });
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: const Text("Save"),
                  onPressed: () async {
                    await _save();
                  }),
            ],
          );
        });
  }

  _save() async {
    final form = _formKey.currentState!;
    final email = userInfo.read("userData")["email"];
    final packagename = packageNameController.text.trim();
    final description = descriptionController.text.trim();
    final text1 = text1Controller.text.trim();
    final text2 = text2Controller.text.trim();
    final text3 = text3Controller.text.trim();
    if (form.validate()) {
      if (priceController.text.isNum && discountController.text.isNum) {
        if (availabilityValueNotifier.value != null) {
          final price = int.parse(priceController.text.trim());
          final discount = double.parse(discountController.text.trim());
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              });
          try {
            var response = await dio.post("$backendUrl2/add-package", data: {
              "adminEmail": email,
              "packagename": packagename,
              "description": description,
              "text1": text1,
              "text2": text2,
              "text3": text3,
              "price": price,
              "discount": discount,
              "available":
                  availabilityValueNotifier.value == "Available" ? true : false,
              "admin": email,
            });
            if (response.data["success"]) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              setState(() {
                packageNameController.text = "";
                descriptionController.text = "";
                text1Controller.text = "";
                text2Controller.text = "";
                text3Controller.text = "";
                priceController.text = "";
                discountController.text = "";
                availabilityValueNotifier.value = null;
              });
              Fluttertoast.showToast(
                msg: response.data["message"],
                toastLength: Toast.LENGTH_LONG,
                webPosition: "center",
              );
              _fetchAllPacks();
            }
          } on DioError catch (error) {
            Navigator.of(context).pop();
            return ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.response!.data["message"])));
          }
        } else {
          return ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Availability is required!")));
        }
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid price or discount!")));
      }
    }
  }

  Future<void> _refresh() async {
    await _fetchAllPacks();
  }

  _fetchAllPacks() async {
    try {
      var response = await dio.post("$backendUrl2/all-packages");
      if (response.data["success"]) {
        setState(() {
          userInfo.write("allPackages", response.data["data"]);
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
}
