// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/dialogs.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';

class Refund extends StatefulWidget {
  const Refund({super.key});

  @override
  State<Refund> createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  late var order = ValueNotifier(constantValues.tempSelectCancelledOrder);

  var cancelled = {
    "",
  };
  DropdownMenuItem<String> buildCancelledOrders(String order) =>
      DropdownMenuItem(
          value: order,
          child: Text(
            order,
          ));

  resetLocations() {
    constantValues.toRemove.clear();
    if (constantValues.refundHistory.isNotEmpty) {
      for (var element in cancelled) {
        for (var element2 in constantValues.refundHistory) {
          if (element.split("-")[0].trim() == element2["orderid"].toString()) {
            constantValues.toRemove.add(element);
          }
        }
      }
      cancelled.removeWhere((e) => constantValues.toRemove.contains(e));
    }
  }

  @override
  void initState() {
    setState(() {
      constantValues.refundHistory.clear();
    });
    _fetchMyRefunds();
    super.initState();
  }

  @override
  void dispose() {
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
            tooltip: "Apply for refund",
            icon: Icons.add,
            onPress: () {
              _applyForRefund(size);
            }),
        appBar: primaryAppBar(context, "Refund History"),
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
    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(Icons.done_all_outlined,
                      color: constantValues.successColor),
                  Text("approved"),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.donut_large_outlined,
                      color: constantValues.primaryColor),
                  Text("pending"),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.cancel_outlined, color: constantValues.errorColor),
                  Text("denied"),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          trailing: IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialog1(
                      title: Text(
                          """Note: You cannot apply for refund more than once on a particular failed order.""",
                          style: fontStyle1b)));
            },
          ),
        ),
        SizedBox(
            height: size.height,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  itemCount: constantValues.refundHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.005,
                          horizontal: size.width * 0.02),
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                            title: Text(
                                "Refund Application for order-${constantValues.refundHistory[index]["orderid"]}",
                                style: fontStyle1),
                            subtitle: Text(
                                "Application date: ${constantValues.refundHistory[index]["date"]}",
                                style: fontStyle1b),
                            trailing: constantValues.refundHistory[index]
                                        ["status"] ==
                                    "pending"
                                ? Icon(Icons.donut_large_outlined,
                                    color: constantValues.primaryColor)
                                : constantValues.refundHistory[index]
                                            ["status"] ==
                                        "approved"
                                    ? Icon(Icons.done_all_outlined,
                                        color: constantValues.successColor)
                                    : Icon(Icons.cancel_outlined,
                                        color: constantValues.errorColor)),
                      ),
                    );
                  }),
            )),
      ],
    );
  }

  Future<void> _refresh() async {
    await _fetchMyRefunds();
  }

  _fetchMyRefunds() async {
    final email = constantValues.userData["email"];
    try {
      var response =
          await dio.post("$backendUrl/my-refunds", data: {"email": email});
      if (response.data["success"]) {
        setState(() {
          constantValues.refundHistory = response.data["data"];
        });
      }
    } on DioError catch (error) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }

  _applyForRefund(size) {
    for (var item in constantValues.cancelledOrders) {
      cancelled.add("${item["orderid"]} - ${item["dateplaced"]}");
    }
    resetLocations();
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog2b(
            title: Text("Apply for refund", style: fontStyle1),
            widget: Column(
              children: [
                Container(
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ValueListenableBuilder(
                      valueListenable: order,
                      builder: (context, value, _) {
                        return ListTile(
                          title: Text("Select a cancelled order"),
                          subtitle: Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    hint: Text(""),
                                    isExpanded: true,
                                    value: order.value,
                                    items: cancelled
                                        .map(buildCancelledOrders)
                                        .toList(),
                                    onChanged: (value) async {
                                      setState(() {
                                        order.value = value!;
                                      });
                                      // print(temp.value);
                                    }),
                              ),
                            ),
                          ),
                        );
                      }),
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
                  child: Text("Apply"),
                  onPressed: () async {
                    await _apply(order.value);
                  }),
            ],
          );
        });
  }

  _apply(orderid) async {
    if (order.value != null && order.value != "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      final email = constantValues.userData["email"];
      try {
        var response = await dio.post("$backendUrl/apply-for-refund", data: {
          "email": email,
          "orderid": int.parse(orderid.split("-")[0]),
        });
        if (response.data["success"]) {
          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          await _fetchMyRefunds();
        }
      } on DioError catch (error) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Please, select an unsuccessful order you wish to apply for a refund!")));
    }
  }
}
