import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/input_fields.dart';

final globalBucket = PageStorageBucket();

class AllComplaints extends StatefulWidget {
  const AllComplaints({super.key});

  @override
  State<AllComplaints> createState() => _AllComplaintsState();
}

class _AllComplaintsState extends State<AllComplaints> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(userInfo.read("searchResult"));

  @override
  void initState() {
    _fetchAllComplaints();
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
          appBar: primaryAppBar(context, "All Complaints"),
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
          child: userInfo.read("allComplaints").isNotEmpty
              ? RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      key: const PageStorageKey<String>("allComplaints"),
                      scrollDirection: Axis.vertical,
                      itemCount: userInfo.read("allComplaints").length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.height * 0.005),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                  userInfo.read("allComplaints")[index]
                                      ["subject"],
                                  style: fontStyle1),
                              subtitle: Text(
                                  "Owner: ${userInfo.read("allComplaints")[index]["email"]}",
                                  style: fontStyle1b),
                              trailing: Text(
                                  "Date: ${userInfo.read("allComplaints")[index]["date"]}",
                                  style: fontStyle1b),
                              onTap: () {
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog1b(
                                        title: Text(userInfo.read(
                                            "allComplaints")[index]["subject"]),
                                        message: userInfo.read(
                                            "allComplaints")[index]["body"],
                                      );
                                    });
                              },
                            ),
                          ),
                        ).animate().fade().slideX(curve: Curves.bounceIn);
                      }),
                )
              : Center(child: Text("No complaint found..", style: fontStyle1b)),
        ),
      ],
    );
  }

  Future<void> _refresh() async {
    await _fetchAllComplaints();
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
                                              title: Text(
                                                  userInfo.read(
                                                          "allComplaints")[
                                                      index]["subject"],
                                                  style: fontStyle1),
                                              subtitle: Text(
                                                  "Owner: ${userInfo.read("allComplaints")[index]["email"]}",
                                                  style: fontStyle1b),
                                              trailing: Text(
                                                  "Date: ${userInfo.read("allComplaints")[index]["date"]}",
                                                  style: fontStyle1b),
                                              onTap: () {
                                                showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog1b(
                                                        title: Text(userInfo.read(
                                                                "allComplaints")[
                                                            index]["subject"]),
                                                        message: userInfo.read(
                                                                "allComplaints")[
                                                            index]["body"],
                                                      );
                                                    });
                                              },
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
        for (var item in userInfo.read("allComplaints")) {
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

  _fetchAllComplaints() async {
    try {
      var response = await dio.post("$backendUrl2/all-complaints");
      if (response.data["success"]) {
        setState(() {
          userInfo.write("allComplaints", response.data["data"]);
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
