// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../screens/admin/home/order_info.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/profile_picture.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(constantValues.searchResult);

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  @override
  void initState() {
    _fetchAllOrders();
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
        appBar: primaryAppBar(context, "All Orders"),
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
    final fontStyle1c = GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600));
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        Form(
          key: _formKey,
          child: InputFieldA2(
              controller: searchController,
              width: size.width * 0.9,
              title: "Search by email or order id..",
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
          child: constantValues.allOrders.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: constantValues.allOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005,
                                horizontal: size.width * 0.02),
                            child: Card(
                                child: ListTile(
                              leading: ProfilePicture(
                                radius: 30,
                                image: (constantValues.allOrders[index]["items"]
                                    as List)[0]["coverimage"]["url"],
                                onClicked: () {},
                              ),
                              title: Text(
                                  "Order id: ${constantValues.allOrders[index]["orderid"]}",
                                  style: fontStyle1),
                              subtitle: OverflowBar(
                                alignment: MainAxisAlignment.start,
                                children: [
                                  Text("status: "),
                                  Card(
                                      color: constantValues.allOrders[index]
                                                  ["status"] ==
                                              "awaiting rider"
                                          ? constantValues.yellowColor
                                          : constantValues.allOrders[index]
                                                      ["status"] ==
                                                  "en-route"
                                              ? constantValues.tealColor
                                              : constantValues.allOrders[index]
                                                          ["status"] ==
                                                      "delivered"
                                                  ? constantValues.successColor
                                                  : constantValues.errorColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                            (constantValues.allOrders[index]
                                                    ["status"] as String)
                                                .toUpperCase(),
                                            style: fontStyle1c),
                                      )),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "${currencyIcon(context).currencySymbol}${constantValues.allOrders[index]["total"]}",
                                      style: fontStyle1),
                                  Text(
                                      "${(constantValues.allOrders[index]["items"] as List).length} items",
                                      style: fontStyle1b)
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OrderInfoAdmin(
                                          order:
                                              constantValues.allOrders[index],
                                        )));
                              },
                            )));
                      }))
              : Center(child: Text("No order found..", style: fontStyle1b)),
        ),
        SizedBox(height: size.height * 0.02),
      ],
    );
  }

  Future<void> _refresh() async {
    await _fetchAllOrders();
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
                                            child: ListTile(
                                              leading: ProfilePicture(
                                                radius: 20,
                                                image: (constantValues
                                                            .searchResult[index]
                                                        ["items"] as List)[0]
                                                    ["coverimage"]["url"],
                                                onClicked: () {},
                                              ),
                                              title: Text(
                                                  "Order id: ${constantValues.searchResult[index]["orderid"]}"),
                                              trailing: Icon(Icons.arrow_right),
                                              onTap: () {
                                                setState(() {
                                                  constantValues
                                                          .selectedPackage =
                                                      constantValues
                                                          .searchResult[index];
                                                });
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderInfoAdmin(
                                                              order: constantValues
                                                                      .searchResult[
                                                                  index],
                                                            )));
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
    constantValues.searchResult.clear();
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (searchController.text.isNum) {
        for (var item in constantValues.allOrders) {
          if (searchController.text.trim() == item["orderid"].toString()) {
            setState(() {
              constantValues.searchResult.add(item);
            });
          }
        }
        return searchResults();
      } else {
        for (var item in constantValues.allOrders) {
          if (searchController.text.trim().toLowerCase() ==
              (item["owneremail"] as String).toLowerCase()) {
            setState(() {
              constantValues.searchResult.add(item);
            });
          }
        }
      }
      return searchResults();
    }
  }

  _fetchAllOrders() async {
    try {
      var response = await dio.post("$backendUrl2/all-orders");
      if (response.data["success"]) {
        setState(() {
          constantValues.allOrders = response.data["data"];
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
