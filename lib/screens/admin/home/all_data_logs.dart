// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/input_fields.dart';

class AllDataLogs extends StatefulWidget {
  const AllDataLogs({super.key});

  @override
  State<AllDataLogs> createState() => _AllDataLogsState();
}

class _AllDataLogsState extends State<AllDataLogs> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(constantValues.searchResult);

  @override
  void initState() {
    _fetchAllDataLogs();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context, "All Data Logs"),
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
    return Column(children: [
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
          child: constantValues.allDataLogs.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: constantValues.allDataLogs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005,
                                horizontal: size.width * 0.02),
                            child: Card(
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                                SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.03),
                                    child: Text(
                                        "Email: ${constantValues.allDataLogs[index]["email"] ?? "--"}",
                                        style: fontStyle1),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading:
                                        Icon(Icons.data_exploration_outlined),
                                    title: Text(
                                        constantValues.allDataLogs[index]
                                            ["logtype"],
                                        style: fontStyle1),
                                    subtitle: Text(
                                        "Date: ${constantValues.allDataLogs[index]["date"]}",
                                        style: fontStyle1b),
                                    trailing: Text(
                                        constantValues.allDataLogs[index]
                                            ["time"].split(".")[0],
                                        style: fontStyle1b),
                                  ),
                                ],
                              ),
                            ));
                      }))
              : Center(child: Text("No data log found..", style: fontStyle1b))),
    ]);
  }

  Future<void> _refresh() async {
    await _fetchAllDataLogs();
  }

  searchResults() {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.jost(textStyle: TextStyle(fontWeight: FontWeight.w300));
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
                    valueListenable: results,
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("Search Results..", style: fontStyle1),
                          ),
                          constantValues.searchResult.isEmpty
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
                                          constantValues.searchResult.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.02,
                                              vertical: size.height * 0.01),
                                          child: Card(
                                            elevation: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 5),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          size.width * 0.03),
                                                  child: Text(
                                                      "Email: ${constantValues.searchResult[index]["email"] ?? "--"}",
                                                      style: fontStyle1),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  leading: Icon(Icons
                                                      .data_exploration_outlined),
                                                  title: Text(
                                                      constantValues
                                                              .searchResult[
                                                          index]["logtype"],
                                                      style: fontStyle1),
                                                  subtitle: Text(
                                                      "Date: ${constantValues.searchResult[index]["date"]}",
                                                      style: fontStyle1b),
                                                  trailing: Text(
                                                      constantValues
                                                              .searchResult[
                                                          index]["time"].split(".")[0],
                                                      style: fontStyle1b),
                                                ),
                                              ],
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
    constantValues.searchResult.clear();
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (searchController.text.contains("@")) {
        for (var item in constantValues.allDataLogs) {
          if (item["email"] != null) {
            if (searchController.text.trim().toLowerCase() ==
                (item["email"] as String).toLowerCase()) {
              setState(() {
                constantValues.searchResult.add(item);
              });
            }
          }
        }
        return searchResults();
      }
    }
  }

  _fetchAllDataLogs() async {
    try {
      var response = await dio.post("$backendUrl2/all-data-logs");
      if (response.data["success"]) {
        setState(() {
          constantValues.allDataLogs = response.data["data"];
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
