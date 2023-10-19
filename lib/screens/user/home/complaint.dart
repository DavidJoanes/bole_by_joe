import 'package:bolebyjoanes/screens/resolution.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/input_fields.dart';

final globalBucket = PageStorageBucket();

class Complaint extends StatefulWidget {
  const Complaint({super.key});

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final complaintSubjectController = TextEditingController();
  final complaintBodyController = TextEditingController();

  @override
  void initState() {
    setState(() {
      userInfo.writeIfNull("complaintHistory", []);
      userInfo.read("complaintHistory").clear();
    });
    _fetchMyComplaints();
    super.initState();
  }

  @override
  void dispose() {
    complaintSubjectController.dispose();
    complaintBodyController.dispose();
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
              tooltip: "Log a complaint",
              icon: Icons.add,
              onPress: () {
                _logComplaint(size);
              }),
          appBar: primaryAppBar(context, "Complaint History"),
          body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Resolution(
                    desktopScreen: desktopScreen(context),
                    mixedScreen: mixedScreen(context))),
          )),
    );
  }

  Widget desktopScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w300));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(children: [
        ListTile(
          trailing: IconButton(
            tooltip: "Info",
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialog1(
                      title: Text(
                          """Note: Your complaint will be reviewed within 24 hours and we will get back to you via email.""",
                          style: fontStyle1b)));
            },
          ),
        ),
        SizedBox(
            height: size.height * 0.9,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  key: const PageStorageKey<String>("complaintHistory"),
                  itemCount: userInfo.read("complaintHistory").length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.005,
                          horizontal: size.width * 0.02),
                      child: Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                                userInfo.read("complaintHistory")[index]
                                    ["subject"],
                                style: fontStyle1),
                            subtitle: Text(
                                "Date: ${userInfo.read("complaintHistory")[index]["date"]}",
                                style: fontStyle1b),
                            onTap: () {
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog1b(
                                      title: Text(userInfo
                                              .read("complaintHistory")[index]
                                          ["subject"]),
                                      message: userInfo.read(
                                          "complaintHistory")[index]["body"],
                                    );
                                  });
                            },
                          )),
                    ).animate().fadeIn().slideX(curve: Curves.easeInToLinear);
                  }),
            ))
      ]),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.w300));
    return Column(children: [
      ListTile(
        trailing: IconButton(
          tooltip: "Info",
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => Dialog1(
                    title: Text(
                        """Note: Your complaint will be reviewed within 24 hours and we will get back to you via email.""",
                        style: fontStyle1b)));
          },
        ),
      ),
      SizedBox(
          height: size.height * 0.9,
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                key: const PageStorageKey<String>("complaintHistory"),
                itemCount: userInfo.read("complaintHistory").length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.005,
                        horizontal: size.width * 0.02),
                    child: Card(
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                              userInfo.read("complaintHistory")[index]
                                  ["subject"],
                              style: fontStyle1),
                          subtitle: Text(
                              "Date: ${userInfo.read("complaintHistory")[index]["date"]}",
                              style: fontStyle1b),
                          onTap: () {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog1b(
                                    title: Text(
                                        userInfo.read("complaintHistory")[index]
                                            ["subject"]),
                                    message:
                                        userInfo.read("complaintHistory")[index]
                                            ["body"],
                                  );
                                });
                          },
                        )),
                  ).animate().fadeIn().slideX(curve: Curves.easeInToLinear);
                }),
          ))
    ]);
  }

  Future<void> _refresh() async {
    await _fetchMyComplaints();
  }

  _fetchMyComplaints() async {
    final email = userInfo.read("userData")["email"];
    try {
      var response =
          await dio.post("$backendUrl/my-complaints", data: {"email": email});
      if (response.data["success"]) {
        setState(() {
          userInfo.write("complaintHistory", response.data["data"]);
        });
      }
    } on DioError catch (error) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }

  _logComplaint(size) {
    final fontStyle1 = GoogleFonts.poppins(
        textStyle: const TextStyle(fontWeight: FontWeight.bold));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog2b(
            title: Text("Log a Complaint", style: fontStyle1),
            widget: Form(
              key: _formKey,
              child: Column(children: [
                InputFieldA2(
                  controller: complaintSubjectController,
                  width: size.width * 0.8,
                  title: "Subject",
                  enabled: true,
                  hintIcon: const Text(""),
                ),
                SizedBox(height: size.height * 0.02),
                InputFieldC(
                  controller: complaintBodyController,
                  width: size.width * 0.8,
                  title: "Write your complaint here",
                  enabled: true,
                  hintIcon: const Text(""),
                ),
              ]),
            ),
            buttons: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  setState(() {
                    complaintSubjectController.text = "";
                    complaintBodyController.text = "";
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Send"),
                onPressed: () async {
                  await _log(context);
                  setState(() {
                    complaintSubjectController.text = "";
                    complaintBodyController.text = "";
                  });
                },
              )
            ],
          );
        });
  }

  _log(context) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      final email = userInfo.read("userData")["email"];
      final subject = complaintSubjectController.text.trim();
      final body = complaintBodyController.text.trim();
      try {
        var response = await dio.post("$backendUrl/log-complaint", data: {
          "email": email,
          "subject": subject,
          "body": body,
        });
        if (response.data["success"]) {
          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          await _fetchMyComplaints();
        }
      } on DioError catch (error) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    }
  }
}
