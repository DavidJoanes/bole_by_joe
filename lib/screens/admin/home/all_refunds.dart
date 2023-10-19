// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/input_fields.dart';

final globalBucket = PageStorageBucket();

class AllRefunds extends StatefulWidget {
  const AllRefunds({super.key});

  @override
  State<AllRefunds> createState() => _AllRefundsState();
}

class _AllRefundsState extends State<AllRefunds> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(userInfo.read("searchResult"));

  @override
  void initState() {
    _fetchAllRefunds();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: globalBucket,
      child: Scaffold(
          appBar: primaryAppBar(context, "All Refund Applications"),
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
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        Form(
          key: _formKey,
          child: InputFieldA2(
              controller: searchController,
              width: size.width * 0.9,
              title: "Search by email..",
              enabled: true,
              hintIcon: IconButton(
                tooltip: "Search",
                icon: Icon(
                  Icons.search_outlined,
                  color: constantValues.primaryColor,
                ),
                onPressed: () async {
                  await _search();
                },
              )),
        ),
        SizedBox(height: size.height * 0.02),
        SizedBox(
          height: size.height * 0.8,
          width: size.width,
          child: userInfo.read("allRefunds").isNotEmpty
              ? RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                        key: const PageStorageKey<String>("allRefunds"),
                      scrollDirection: Axis.vertical,
                      itemCount: userInfo.read("allRefunds").length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.height * 0.005),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              leading: userInfo.read("allRefunds")[index]
                                          ["status"] ==
                                      "pending"
                                  ? Icon(Icons.donut_large_outlined,
                                      color: constantValues.primaryColor)
                                  : userInfo.read("allRefunds")[index]
                                              ["status"] ==
                                          "approved"
                                      ? Icon(Icons.done_all_outlined,
                                          color: constantValues.successColor)
                                      : Icon(Icons.cancel_outlined,
                                          color: constantValues.errorColor),
                              title: Text(
                                  "Refund Application for order-${userInfo.read("allRefunds")[index]["orderid"]}",
                                  style: fontStyle1),
                              subtitle: Text(
                                  "Owner: ${userInfo.read("allRefunds")[index]["email"]}",
                                  style: fontStyle1b),
                              trailing: OverflowBar(
                                children: [
                                  IconButton(
                                    tooltip: "Approve",
                                    icon: Icon(Icons.done,
                                        color: constantValues.successColor),
                                    onPressed: () async {
                                      await _approve(
                                          userInfo.read("allRefunds")[index]
                                              ["email"],
                                          userInfo.read("allRefunds")[index]
                                              ["orderid"],
                                          false);
                                    },
                                  ),
                                  IconButton(
                                    tooltip: "Reset",
                                    icon: Icon(Icons.remove,
                                        color: constantValues.yellowColor),
                                    onPressed: () async {
                                      await _reset(
                                          userInfo.read("allRefunds")[index]
                                              ["email"],
                                          userInfo.read("allRefunds")[index]
                                              ["orderid"],
                                          false);
                                    },
                                  ),
                                  IconButton(
                                    tooltip: "Deny",
                                    icon: Icon(Icons.cancel_outlined,
                                        color: constantValues.errorColor),
                                    onPressed: () async {
                                      await _deny(
                                          userInfo.read("allRefunds")[index]
                                              ["email"],
                                          userInfo.read("allRefunds")[index]
                                              ["orderid"],
                                          false);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fade().slideX(curve: Curves.bounceIn);
                      }),
                )
              : Center(
                  child: Text("No refund application found..",
                      style: fontStyle1b)),
        ),
      ],
    );
  }

  Future<void> _refresh() async {
    await _fetchAllRefunds();
  }

  _approve(email, orderid, isInSearchResults) async {
    final adminEmail = userInfo.read("userData")["email"];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      var response =
          await dio.post("$backendUrl2/approve-refund-application", data: {
        "adminEmail": adminEmail,
        "email": email,
        "orderid": orderid,
      });
      if (response.data["success"]) {
        Navigator.of(context).pop();
        isInSearchResults ? Navigator.of(context).pop() : null;
        _fetchAllRefunds();
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

  _deny(email, orderid, isInSearchResults) async {
    final adminEmail = userInfo.read("userData")["email"];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      var response =
          await dio.post("$backendUrl2/deny-refund-application", data: {
        "adminEmail": adminEmail,
        "email": email,
        "orderid": orderid,
      });
      if (response.data["success"]) {
        Navigator.of(context).pop();
        isInSearchResults ? Navigator.of(context).pop() : null;
        _fetchAllRefunds();
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

  _reset(email, orderid, isInSearchResults) async {
    final adminEmail = userInfo.read("userData")["email"];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      var response =
          await dio.post("$backendUrl2/reset-refund-application", data: {
        "adminEmail": adminEmail,
        "email": email,
        "orderid": orderid,
      });
      if (response.data["success"]) {
        Navigator.of(context).pop();
        isInSearchResults ? Navigator.of(context).pop() : null;
        _fetchAllRefunds();
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

  searchResults() {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.jost(textStyle: const TextStyle(fontWeight: FontWeight.w300));
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        shape: const RoundedRectangleBorder(
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
                    valueListenable: results,
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("Search Results..", style: fontStyle1),
                          ),
                          userInfo.read("searchResult").isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.1),
                                  child: Center(
                                      child: Text("Nothing found...",
                                          style: fontStyle1b)),
                                )
                              : SizedBox(
                                  height: size.height * 0.45,
                                  width: size.width,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          userInfo.read("searchResult").length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.02,
                                              vertical: size.height * 0.01),
                                          child: Card(
                                            elevation: 4,
                                            child: ListTile(
                                              leading: userInfo.read("searchResult")[index]
                                                          ["status"] ==
                                                      "pending"
                                                  ? Icon(Icons.donut_large_outlined,
                                                      color: constantValues
                                                          .primaryColor)
                                                  : userInfo.read("searchResult")[
                                                                  index]
                                                              ["status"] ==
                                                          "approved"
                                                      ? Icon(
                                                          Icons
                                                              .done_all_outlined,
                                                          color: constantValues
                                                              .successColor)
                                                      : Icon(
                                                          Icons.cancel_outlined,
                                                          color: constantValues
                                                              .errorColor),
                                              title: Text(
                                                  "Refund Application for order-${userInfo.read("searchResult")[index]["orderid"]}",
                                                  style: fontStyle1),
                                              subtitle: Text(
                                                  "Owner: ${userInfo.read("searchResult")[index]["email"]}",
                                                  style: fontStyle1b),
                                              trailing: OverflowBar(
                                                children: [
                                                  IconButton(
                                                    tooltip: "Approve",
                                                    icon: Icon(Icons.done,
                                                        color: constantValues
                                                            .successColor),
                                                    onPressed: () async {
                                                      await _approve(
                                                          userInfo.read("searchResult")[
                                                              index]["email"],
                                                          userInfo.read("searchResult")[
                                                              index]["orderid"],
                                                          true);
                                                    },
                                                  ),
                                                  IconButton(
                                                    tooltip: "Reset",
                                                    icon: Icon(Icons.remove,
                                                        color: constantValues
                                                            .yellowColor),
                                                    onPressed: () async {
                                                      await _reset(
                                                          userInfo.read("allRefunds")[
                                                              index]["email"],
                                                          userInfo.read("searchResult")[
                                                              index]["orderid"],
                                                          true);
                                                    },
                                                  ),
                                                  IconButton(
                                                    tooltip: "Deny",
                                                    icon: Icon(
                                                        Icons.cancel_outlined,
                                                        color: constantValues
                                                            .errorColor),
                                                    onPressed: () async {
                                                      await _deny(
                                                          userInfo.read("searchResult")[
                                                              index]["email"],
                                                          userInfo.read("searchResult")[
                                                              index]["orderid"],
                                                          true);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
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

  _search() {
    userInfo.read("searchResult").clear();
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (searchController.text.contains("@")) {
        for (var item in userInfo.read("allRefunds")) {
          if (searchController.text.trim().toLowerCase() ==
              (item["email"] as String).toLowerCase()) {
            setState(() {
              userInfo.read("searchResult").add(item);
            });
          }
        }
        return searchResults();
      }
    }
  }

  _fetchAllRefunds() async {
    try {
      var response = await dio.post("$backendUrl2/all-refunds");
      if (response.data["success"]) {
        setState(() {
          userInfo.write("allRefunds", response.data["data"]);
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
