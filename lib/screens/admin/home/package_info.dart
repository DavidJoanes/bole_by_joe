// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_constructors, use_build_context_synchronously, unused_field, avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/input_fields.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dialogs.dart';

class PackageInfo extends StatefulWidget {
  PackageInfo(
      {super.key,
      required this.packageCoverImage,
      required this.packageImages,
      required this.packageName,
      required this.description,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.price,
      required this.discount,
      required this.rating,
      required this.reviews,
      required this.availability});
  var packageCoverImage;
  var packageImages;
  var packageName;
  var description;
  var text1;
  var text2;
  var text3;
  var price;
  var discount;
  var rating;
  var reviews;
  var availability;

  @override
  State<PackageInfo> createState() => _PackageInfoState();
}

class _PackageInfoState extends State<PackageInfo> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  TextEditingController packageNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController text1Controller = TextEditingController();
  TextEditingController text2Controller = TextEditingController();
  TextEditingController text3Controller = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController reviewerController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  String? availability;
  double? rating_;
  late ValueNotifier availabilityValueNotifier = ValueNotifier(availability);
  int currentIndex = 0;
  late Uint8List? _bytesData;
  late List<int>? _selectedFile;
  late var _file;

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
    setState(() {
      packageNameController.text = widget.packageName;
      descriptionController.text = widget.description;
      text1Controller.text = widget.text1;
      text2Controller.text = widget.text2;
      text3Controller.text = widget.text3;
      priceController.text = widget.price.toString();
      discountController.text = widget.discount.toString();
      widget.availability
          ? availabilityValueNotifier.value = availabilityOptions[0]
          : availabilityValueNotifier.value = availabilityOptions[1];
    });
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
    reviewerController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryAppBar2(
            context,
            "Package Info",
            Row(
              children: [
                IconButton(
                    tooltip: "Delete",
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Dialog2b(
                                title: Text("Confirmation"),
                                widget: Text(
                                    "Do you wish to delete ${widget.packageName} package?"),
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
                                ]);
                          });
                    }),
                IconButton(
                    tooltip: "Save",
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      await _save();
                    }),
              ],
            )),
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
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w400));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.02, horizontal: size.width * 0.01),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.4,
                  child: CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 500),
                        height: size.height * 0.4,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        }),
                    items: widget.packageImages.map<Widget>((item) {
                      return GridTile(
                        child: Card(
                          child: Container(
                            height: size.height * 0.3,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(item), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < widget.packageImages.length; i++)
                      Container(
                        height: 12,
                        width: 12,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: currentIndex == i
                                ? constantValues.primaryColor
                                : constantValues.whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  offset: Offset(2, 2))
                            ]),
                      ),
                    SizedBox(width: 5),
                    IconButton(
                      tooltip: "Replace cover image",
                      icon: Icon(Icons.add_a_photo,
                          color: constantValues.primaryColor),
                      onPressed: () async {
                        await _addImage(true);
                      },
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      tooltip: "Add image",
                      icon: Icon(Icons.add_a_photo_outlined,
                          color: constantValues.primaryColor),
                      onPressed: () async {
                        await _addImage(false);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: size.height * 0.1),
          Form(
            key: _formKey,
            child: Column(
              children: [
                InputFieldA2(
                    controller: packageNameController,
                    width: size.width * 0.8,
                    title: "Package name",
                    enabled: false,
                    hintIcon: Text('')),
                SizedBox(height: size.height * 0.02),
                InputFieldC(
                    controller: descriptionController,
                    width: size.width * 0.8,
                    title: "Description",
                    enabled: true,
                    hintIcon: Text('')),
                SizedBox(height: size.height * 0.02),
                InputFieldA2(
                    controller: text1Controller,
                    width: size.width * 0.8,
                    title: "First text",
                    enabled: true,
                    hintIcon: Text('')),
                SizedBox(height: size.height * 0.02),
                InputFieldA2(
                    controller: text2Controller,
                    width: size.width * 0.8,
                    title: "Second text",
                    enabled: true,
                    hintIcon: Text('')),
                SizedBox(height: size.height * 0.02),
                InputFieldA2(
                    controller: text3Controller,
                    width: size.width * 0.8,
                    title: "Third text",
                    enabled: true,
                    hintIcon: Text('')),
                SizedBox(height: size.height * 0.02),
                InputFieldA2(
                    controller: priceController,
                    width: size.width * 0.8,
                    title: "Price",
                    enabled: true,
                    hintIcon: Text('')),
                SizedBox(height: size.height * 0.02),
                InputFieldA2(
                    controller: discountController,
                    width: size.width * 0.8,
                    title: "Discount",
                    enabled: true,
                    hintIcon: Text('')),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  width: size.width * 0.8,
                  child: Card(
                    child: Column(
                      children: [
                        Card(
                          child: RadioListTile(
                            title: Text(availabilityOptions[0],
                                style: fontStyle1b),
                            value: availabilityOptions[0],
                            groupValue: availabilityValueNotifier.value,
                            onChanged: (value) {
                              setState(() {
                                availabilityValueNotifier.value = value;
                              });
                            },
                          ),
                        ),
                        Card(
                          child: RadioListTile(
                            title: Text(availabilityOptions[1],
                                style: fontStyle1b),
                            value: availabilityOptions[1],
                            groupValue: availabilityValueNotifier.value,
                            onChanged: (value) {
                              setState(() {
                                availabilityValueNotifier.value = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.05),
          ListTile(
              title:
                  Text("Add a rating & review (Optional)", style: fontStyle1)),
          RatingBar.builder(
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: size.width * 0.1,
            itemPadding: EdgeInsets.symmetric(horizontal: size.width * 0.002),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.green,
            ),
            onRatingUpdate: (rating) {
              rating_ = rating;
            },
          ),
          SizedBox(height: size.height * 0.02),
          InputFieldA2(
              controller: reviewerController,
              width: size.width * 0.8,
              title: "Reviewer",
              enabled: true,
              hintIcon: Text('')),
          SizedBox(height: size.height * 0.02),
          InputFieldC(
              controller: reviewController,
              width: size.width * 0.8,
              title: "Review (optional)",
              enabled: true,
              hintIcon: Text('')),
          SizedBox(height: size.height * 0.05),
          ButtonA(
              width: size.width * 0.8,
              text1: "Add rating",
              text2: "Processing..",
              isLoading: false,
              authenticate: () async {
                await _addRating();
              }),
          SizedBox(height: size.height * 0.05),
        ],
      ),
    );
  }

  _addImage(bool isCoverImage) async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      setState(() {
        _bytesData = null;
        _selectedFile = null;
      });

      reader.onLoad.listen((event) async {
        setState(() {
          _bytesData =
              Base64Decoder().convert(reader.result.toString().split(",").last);
          _selectedFile = _bytesData;
          _file = file.name;
        });
        await uploadImage(_bytesData!, _file, isCoverImage);
      });
      reader.readAsDataUrl(file);
    });
  }

  uploadImage(List<int> file, String fileName, bool isCoverImage) async {
    final packagename = packageNameController.text.trim();
    final formData = FormData.fromMap({
      "packagename": packagename,
      "category": isCoverImage ? "coverimage" : "packageimage",
      "image": MultipartFile.fromBytes(file,
          filename: fileName,
          contentType: MediaType('image', fileName.split(".")[1])),
    });
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    try {
      var response = await dio.post(
          isCoverImage
              ? "$backendUrl2/upload-package-cover-image"
              : "$backendUrl2/upload-package-image",
          data: formData);
      if (response.data["success"]) {
        Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        return ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
      // ignore: unused_catch_clause
    } on DioError catch (error) {
      Navigator.of(context).pop();
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Maximum profile image size allowed: 5mb")));
    }
  }

  _addRating() async {
    final email = constantValues.userData["email"];
    final reviewer = reviewerController.text.trim();
    final review = reviewController.text.trim();
    final packagename = packageNameController.text.trim();
    if (rating_ != null) {
      try {
        var response = await dio.post("$backendUrl/rate-package", data: {
          "email": email,
          "packagename": packagename,
          "rating": rating_,
          "reviewer": reviewer,
          "review": review,
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
    } else {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Rating is required!")));
    }
  }

  _save() async {
    final form = _formKey.currentState!;
    final email = constantValues.userData["email"];
    final packagename = packageNameController.text.trim();
    final description = descriptionController.text.trim();
    final text1 = text1Controller.text.trim();
    final text2 = text2Controller.text.trim();
    final text3 = text3Controller.text.trim();
    final price = int.parse(priceController.text.trim());
    final discount = double.parse(discountController.text.trim());
    if (form.validate()) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      try {
        var response = await dio.post("$backendUrl2/update-package",
            data: {
              "adminEmail": email,
              "packagename": packagename,
              "description": description,
              "text1": text1,
              "text2": text2,
              "text3": text3,
              "price": price,
              "discount": discount,
              "available":
                  availabilityValueNotifier.value == "Available" ? true : false
            },
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.data["success"]) {
          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } on DioError catch (error) {
        Navigator.of(context).pop();
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    }
  }

  _delete() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    final email = constantValues.userData["email"];
    final packagename = packageNameController.text.trim();
    try {
      var response = await dio.post("$backendUrl2/delete-package",
          data: {
            "adminEmail": email,
            "packagename": packagename,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.data["success"]) {
        Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        return ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } on DioError catch (error) {
      Navigator.of(context).pop();
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }
}
