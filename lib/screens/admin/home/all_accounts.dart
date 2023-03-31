// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/profile_picture.dart';
import 'account_info.dart';

class AllAccounts extends StatefulWidget {
  const AllAccounts({super.key});

  @override
  State<AllAccounts> createState() => _AllAccountsState();
}

class _AllAccountsState extends State<AllAccounts> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(constantValues.searchResult);

  @override
  void initState() {
    _fetchAllAccounts();
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
        appBar: primaryAppBar(context, "All Accounts"),
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
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        Form(
          key: _formKey,
          child: InputFieldA2(
              controller: searchController,
              width: size.width * 0.9,
              title: "Search by last name or email..",
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
            child: constantValues.allAccounts.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                        itemCount: constantValues.allAccounts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.005,
                                  horizontal: size.width * 0.02),
                              child: Card(
                                  child: ListTile(
                                leading: ProfilePicture(
                                  radius: 30,
                                  image: constantValues.allAccounts[index]
                                              ["profileimage"]["url"] !=
                                          ""
                                      ? constantValues.allAccounts[index]
                                          ["profileimage"]["url"]
                                      : "assets/icons/user.png",
                                  onClicked: () {},
                                ),
                                title: Text(
                                    "${(constantValues.allAccounts[index]["firstname"] as String).toTitleCase()} ${(constantValues.allAccounts[index]["lastname"] as String).toTitleCase()}",
                                    style: fontStyle1),
                                subtitle: Text(
                                    constantValues.allAccounts[index]["email"],
                                    style: fontStyle1b),
                                trailing: constantValues.allAccounts[index]
                                            ["accounttype"] ==
                                        "user"
                                    ? Icon(Icons.person_pin)
                                    : Icon(Icons.delivery_dining_sharp),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AccountInfo(
                                            accountType: constantValues
                                                    .allAccounts[index]
                                                ["accounttype"],
                                            profileImage: constantValues
                                                    .allAccounts[index]
                                                ["profileimage"]["url"],
                                            firstName: constantValues
                                                    .allAccounts[index]
                                                ["firstname"],
                                            lastName: constantValues
                                                .allAccounts[index]["lastname"],
                                            emailAddress: constantValues
                                                .allAccounts[index]["email"],
                                            phoneNumber: constantValues
                                                    .allAccounts[index]
                                                ["phonenumber"],
                                            ratings: constantValues
                                                .allAccounts[index]["ratings"],
                                            deliveries: constantValues
                                                    .allAccounts[index]
                                                ["deliveries"],
                                            motorcycleModel: constantValues
                                                    .allAccounts[index]
                                                ["motorcyclemodel"],
                                            motorcycleColor: constantValues
                                                    .allAccounts[index]
                                                ["motorcyclecolor"],
                                            motorcyclePlateNumber:
                                                constantValues
                                                        .allAccounts[index]
                                                    ["motorcycleplatenumber"],
                                            isSuspended: constantValues
                                                    .allAccounts[index]
                                                ["suspended"],
                                            registrationDate: constantValues
                                                    .allAccounts[index]
                                                ["registrationdate"],
                                          )));
                                },
                              )));
                        }))
                : Center(
                    child: Text("No Account found..", style: fontStyle1b))),
      ],
    );
  }

  Future<void> _refresh() async {
    await _fetchAllAccounts();
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
                                                image: constantValues.searchResult[
                                                                    index]
                                                                ["profileimage"]
                                                            ["url"] !=
                                                        ""
                                                    ? constantValues
                                                            .searchResult[index]
                                                        ["profileimage"]["url"]
                                                    : "assets/icons/user.png",
                                                onClicked: () {},
                                              ),
                                              title: Text(
                                                  "${(constantValues.searchResult[index]["firstname"] as String).toTitleCase()} ${(constantValues.searchResult[index]["lastname"] as String).toTitleCase()}"),
                                              trailing: Icon(Icons.arrow_right),
                                              onTap: () {
                                                setState(() {
                                                  constantValues
                                                          .selectedPackage =
                                                      constantValues
                                                          .searchResult[index];
                                                });
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                AccountInfo(
                                                                  accountType: constantValues
                                                                              .allAccounts[
                                                                          index]
                                                                      [
                                                                      "accounttype"],
                                                                  profileImage:
                                                                      constantValues.allAccounts[index]
                                                                              [
                                                                              "profileimage"]
                                                                          [
                                                                          "url"],
                                                                  firstName: constantValues
                                                                              .allAccounts[
                                                                          index]
                                                                      [
                                                                      "firstname"],
                                                                  lastName: constantValues
                                                                              .allAccounts[
                                                                          index]
                                                                      [
                                                                      "lastname"],
                                                                  emailAddress:
                                                                      constantValues
                                                                              .allAccounts[index]
                                                                          [
                                                                          "email"],
                                                                  phoneNumber: constantValues
                                                                              .allAccounts[
                                                                          index]
                                                                      [
                                                                      "phonenumber"],
                                                                  ratings: constantValues
                                                                              .allAccounts[
                                                                          index]
                                                                      [
                                                                      "ratings"],
                                                                  deliveries: constantValues
                                                                              .allAccounts[
                                                                          index]
                                                                      [
                                                                      "deliveries"],
                                                                  motorcycleModel:
                                                                      constantValues
                                                                              .allAccounts[index]
                                                                          [
                                                                          "motorcyclemodel"],
                                                                  motorcycleColor:
                                                                      constantValues
                                                                              .allAccounts[index]
                                                                          [
                                                                          "motorcyclecolor"],
                                                                  motorcyclePlateNumber:
                                                                      constantValues
                                                                              .allAccounts[index]
                                                                          [
                                                                          "motorcycleplatenumber"],
                                                                  isSuspended: constantValues
                                                                              .allAccounts[
                                                                          index]
                                                                      [
                                                                      "suspended"],
                                                                  registrationDate:
                                                                      constantValues
                                                                              .allAccounts[index]
                                                                          [
                                                                          "registrationdate"],
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
      if (searchController.text.toLowerCase().contains("@")) {
        for (var item in constantValues.allAccounts) {
          if (searchController.text.trim().toLowerCase() ==
              (item["email"] as String).toLowerCase()) {
            setState(() {
              constantValues.searchResult.add(item);
            });
          }
        }
        return searchResults();
      }
      for (var item in constantValues.allAccounts) {
        if (searchController.text.trim().toLowerCase() ==
            (item["lastname"] as String).toLowerCase()) {
          setState(() {
            constantValues.searchResult.add(item);
          });
        }
      }
      return searchResults();
    }
  }

  _fetchAllAccounts() async {
    try {
      var response = await dio.post("$backendUrl2/all-accounts");
      if (response.data["success"]) {
        setState(() {
          constantValues.allAccounts = response.data["data"];
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
