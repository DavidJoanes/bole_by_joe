// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/input_fields.dart';
// import '../../../widgets/countries.dart' as fetchcountries;

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final apartmentController = TextEditingController();
  final landmarkController = TextEditingController();
  final latlang = TextEditingController();
  Location location = Location();
  late var temp = ValueNotifier(constantValues.nameOfLocation);
  late var temp2 = ValueNotifier(constantValues.province);

  var nameOfLocations = {
    "",
    "Home",
    "Work",
    "Other",
  };
  DropdownMenuItem<String> buildnameOfLocations(String loc) => DropdownMenuItem(
      value: loc,
      child: Text(
        loc,
      ));

  resetLocations() {
    constantValues.toRemove.clear();
    if (constantValues.myLocations.isNotEmpty) {
      for (var element in nameOfLocations) {
        for (var element2 in constantValues.myLocations) {
          if (element.toLowerCase() ==
              (element2["nameoflocation"] as String).toLowerCase()) {
            constantValues.toRemove.add(element);
          }
        }
      }
      nameOfLocations.removeWhere((e) => constantValues.toRemove.contains(e));
    }
  }

  @override
  void initState() {
    setState(() {
      constantValues.myLocations.clear();
      cityController.text = constantValues.city;
    });
    _fetchMyLocations();
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      constantValues.nameOfLocation = null;
    });
    cityController.dispose();
    addressController.dispose();
    apartmentController.dispose();
    landmarkController.dispose();
    latlang.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: SpeedDial(
          backgroundColor: constantValues.isDarkTheme
              ? constantValues.blackColor
              : constantValues.primaryColor,
          foregroundColor: constantValues.whiteColor,
          overlayColor: constantValues.blackColor,
          spacing: size.height * 0.02,
          spaceBetweenChildren: size.height * 0.01,
          overlayOpacity: 0.5,
          tooltip: "Add/Update location",
          child: Icon(Icons.add),
          onPress: () {
            _addLocation(size);
          },
        ),
        appBar: primaryAppBar(context, "Locations"),
        body: SafeArea(
          child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: mixedScreen(context)),
        ));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w400));
    return SizedBox(
      height: size.height,
      child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: constantValues.myLocations.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.005,
                      horizontal: size.width * 0.02),
                  child: Slidable(
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: BehindMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => _delete(index),
                          backgroundColor: constantValues.errorColor,
                          foregroundColor: constantValues.whiteColor,
                          icon: Icons.delete,
                          label: "delete",
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                            (constantValues.myLocations[index]['nameoflocation']
                                    as String)
                                .toUpperCase(),
                            style: fontStyle1),
                        subtitle: Text(
                            "${constantValues.myLocations[index]['address']}",
                            style: fontStyle1b),
                        trailing: Text(
                            "${constantValues.myLocations[index]['city']}",
                            style: fontStyle1b),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  Future<void> _refresh() async {
    await _fetchMyLocations();
  }

  _addLocation(size) {
    resetLocations();
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog2b(
            title: Text("Add Location", style: fontStyle1),
            widget: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ValueListenableBuilder(
                            valueListenable: temp,
                            builder: (context, value, _) {
                              return ListTile(
                                title: Text('Name of location'),
                                subtitle: Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.02),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                          hint: Text(""),
                                          isExpanded: true,
                                          value: temp.value,
                                          items: nameOfLocations
                                              .map(buildnameOfLocations)
                                              .toList(),
                                          onChanged: (value) async {
                                            setState(() {
                                              temp.value = value!;
                                            });
                                          }),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text("Country"),
                          subtitle: Text(constantValues.country),
                          trailing: Icon(Icons.arrow_drop_down_outlined),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text("Province"),
                          subtitle: Text(constantValues.province),
                          trailing: Icon(Icons.arrow_drop_down_outlined),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      InputFieldA2(
                        controller: cityController,
                        width: size.width * 0.8,
                        title: "City",
                        enabled: false,
                        hintIcon: Text(''),
                      ),
                      SizedBox(height: size.height * 0.02),
                      InputFieldA2(
                        controller: addressController,
                        width: size.width * 0.8,
                        title: "Address",
                        enabled: true,
                        hintIcon: Text(''),
                      ),
                      SizedBox(height: size.height * 0.02),
                      InputFieldA2(
                        controller: landmarkController,
                        width: size.width * 0.8,
                        title: "Closet landmark",
                        enabled: true,
                        hintIcon: Text(''),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                InputFieldA2(
                  controller: apartmentController,
                  width: size.width * 0.8,
                  title: "Apartment/Suite (optional)",
                  enabled: true,
                  hintIcon: Text(''),
                ),
              ],
            ),
            buttons: [
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: Text("Save"),
                  onPressed: () async {
                    await _save();
                  }),
            ],
          );
        });
  }

  _deleteLocation(email, nameOfLoc) async {
    try {
      var response = await dio.post(
        "$backendUrl/delete-location",
        data: {"email": email, "nameoflocation": nameOfLoc},
      );
      if (response.data["success"]) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
        context.goNamed("home");
      }
    } on DioError catch (error) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }

  void _delete(index) {
    final email = constantValues.userData["email"];
    final nameOfLoc = constantValues.myLocations[index]["nameoflocation"];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog2b(
              title: Text("Confirmation"),
              widget: Text("Do you wish to delete your $nameOfLoc location?"),
              buttons: [
                TextButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                  child: Text("Yes"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Center(child: CircularProgressIndicator());
                        });
                    await _deleteLocation(email, nameOfLoc);
                    for (var item in constantValues.myLocations) {
                      if (nameOfLoc == item["nameoflocation"]) {
                        setState(() {
                          constantValues.toRemove.remove(nameOfLoc);
                          constantValues.myLocations.remove(item);
                        });
                      }
                    }
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  _save() async {
    final form = _formKey.currentState!;
    final email = constantValues.userData["email"];
    final address = addressController.text.trim();
    final landmark = landmarkController.text.trim();
    final apartment = apartmentController.text.trim();
    if (temp.value != null && temp.value != "") {
      if (form.validate()) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(child: CircularProgressIndicator());
            });
        try {
          var response = await dio.post("$backendUrl/add-location", data: {
            "email": email,
            "nameoflocation": temp.value,
            "address": address,
            "closestlandmark": landmark,
            "apartment": apartment,
          });
          if (response.data["success"]) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: "${temp.value} location saved..",
              toastLength: Toast.LENGTH_LONG,
              webPosition: "center",
            );
            await _fetchMyLocations();
          }
        } on DioError catch (error) {
          Navigator.of(context).pop();
          return ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.response!.data["message"])));
        }
      }
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Select a name for your location!")));
    }
  }

  _fetchMyLocations() async {
    final email = constantValues.userData["email"];
    try {
      var response =
          await dio.post("$backendUrl/my-locations", data: {"email": email});
      if (response.data["success"]) {
        setState(() {
          constantValues.myLocations = response.data["data"];
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
