import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/profile_picture.dart';
import 'account_info.dart';

final globalBucket = PageStorageBucket();

class AllAccounts extends StatefulWidget {
  const AllAccounts({super.key});

  @override
  State<AllAccounts> createState() => _AllAccountsState();
}

class _AllAccountsState extends State<AllAccounts> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  var userInfo = GetStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  late ValueNotifier results = ValueNotifier(userInfo.read("searchResult"));

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
    return PageStorage(
      bucket: globalBucket,
      child: Scaffold(
          appBar: primaryAppBar(context, "All Accounts"),
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
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w300));
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
            child: userInfo.read("allAccounts").isNotEmpty
                ? RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                        key: const PageStorageKey<String>("allAccounts"),
                        itemCount: userInfo.read("allAccounts").length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.005,
                                      horizontal: size.width * 0.02),
                                  child: Card(
                                      child: ListTile(
                                    leading: ProfilePicture(
                                      radius: 30,
                                      image: userInfo.read("allAccounts")[index]
                                                  ["profileimage"]["url"] !=
                                              ""
                                          ? userInfo.read("allAccounts")[index]
                                              ["profileimage"]["url"]
                                          : "assets/icons/user.png",
                                      onClicked: () {},
                                    ),
                                    title: Text(
                                        "${(userInfo.read("allAccounts")[index]["firstname"] as String).toTitleCase()} ${(userInfo.read("allAccounts")[index]["lastname"] as String).toTitleCase()}",
                                        style: fontStyle1),
                                    subtitle: Text(
                                        userInfo.read("allAccounts")[index]
                                            ["email"],
                                        style: fontStyle1b),
                                    trailing: OverflowBar(
                                      children: [
                                        userInfo.read("allAccounts")[index]
                                                ["suspended"]
                                            ? Icon(Icons.cancel,
                                                color:
                                                    constantValues.errorColor)
                                            : Icon(Icons.verified_user,
                                                color: constantValues
                                                    .successColor),
                                        const SizedBox(width: 0.01),
                                        userInfo.read("allAccounts")[index]
                                                    ["accounttype"] ==
                                                "user"
                                            ? const Icon(Icons.person_pin)
                                            : const Icon(Icons.delivery_dining_sharp),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => AccountInfo(
                                                    accountType: userInfo.read(
                                                            "allAccounts")[
                                                        index]["accounttype"],
                                                    profileImage: userInfo.read(
                                                                "allAccounts")[
                                                            index]
                                                        ["profileimage"]["url"],
                                                    firstName: userInfo.read(
                                                            "allAccounts")[
                                                        index]["firstname"],
                                                    lastName: userInfo.read(
                                                            "allAccounts")[
                                                        index]["lastname"],
                                                    emailAddress: userInfo.read(
                                                            "allAccounts")[
                                                        index]["email"],
                                                    phoneNumber: userInfo.read(
                                                            "allAccounts")[
                                                        index]["phonenumber"],
                                                    ratings: userInfo.read(
                                                            "allAccounts")[
                                                        index]["ratings"],
                                                    deliveries: userInfo.read(
                                                            "allAccounts")[
                                                        index]["deliveries"],
                                                    motorcycleModel: userInfo
                                                            .read(
                                                                "allAccounts")[
                                                        index]["motorcyclemodel"],
                                                    motorcycleColor: userInfo
                                                            .read(
                                                                "allAccounts")[
                                                        index]["motorcyclecolor"],
                                                    motorcyclePlateNumber: userInfo
                                                                .read(
                                                                    "allAccounts")[
                                                            index][
                                                        "motorcycleplatenumber"],
                                                    isSuspended: userInfo.read(
                                                            "allAccounts")[
                                                        index]["suspended"],
                                                    registrationDate: userInfo
                                                            .read(
                                                                "allAccounts")[
                                                        index]["registrationdate"],
                                                  )));
                                    },
                                  )))
                              .animate()
                              .fade()
                              .slideX(curve: Curves.bounceIn);
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
                                              leading: ProfilePicture(
                                                radius: 20,
                                                image: userInfo.read("searchResult")[
                                                                    index]
                                                                ["profileimage"]
                                                            ["url"] !=
                                                        ""
                                                    ? userInfo.read(
                                                                "searchResult")[
                                                            index]
                                                        ["profileimage"]["url"]
                                                    : "assets/icons/user.png",
                                                onClicked: () {},
                                              ),
                                              title: Text(
                                                  "${(userInfo.read("searchResult")[index]["firstname"] as String).toTitleCase()} ${(userInfo.read("searchResult")[index]["lastname"] as String).toTitleCase()}"),
                                              trailing: const Icon(Icons.arrow_right),
                                              onTap: () {
                                                setState(() {
                                                  userInfo.write(
                                                      "selectedPackage",
                                                      userInfo.read(
                                                              "searchResult")[
                                                          index]);
                                                });
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                AccountInfo(
                                                                  accountType: userInfo
                                                                          .read(
                                                                              "allAccounts")[index]
                                                                      [
                                                                      "accounttype"],
                                                                  profileImage:
                                                                      userInfo.read("allAccounts")[index]
                                                                              [
                                                                              "profileimage"]
                                                                          [
                                                                          "url"],
                                                                  firstName: userInfo
                                                                          .read(
                                                                              "allAccounts")[index]
                                                                      [
                                                                      "firstname"],
                                                                  lastName: userInfo
                                                                          .read(
                                                                              "allAccounts")[index]
                                                                      [
                                                                      "lastname"],
                                                                  emailAddress:
                                                                      userInfo.read(
                                                                              "allAccounts")[index]
                                                                          [
                                                                          "email"],
                                                                  phoneNumber: userInfo
                                                                          .read(
                                                                              "allAccounts")[index]
                                                                      [
                                                                      "phonenumber"],
                                                                  ratings: userInfo
                                                                          .read(
                                                                              "allAccounts")[index]
                                                                      [
                                                                      "ratings"],
                                                                  deliveries: userInfo
                                                                          .read(
                                                                              "allAccounts")[index]
                                                                      [
                                                                      "deliveries"],
                                                                  motorcycleModel:
                                                                      userInfo.read(
                                                                              "allAccounts")[index]
                                                                          [
                                                                          "motorcyclemodel"],
                                                                  motorcycleColor:
                                                                      userInfo.read(
                                                                              "allAccounts")[index]
                                                                          [
                                                                          "motorcyclecolor"],
                                                                  motorcyclePlateNumber:
                                                                      userInfo.read(
                                                                              "allAccounts")[index]
                                                                          [
                                                                          "motorcycleplatenumber"],
                                                                  isSuspended: userInfo
                                                                          .read(
                                                                              "allAccounts")[index]
                                                                      [
                                                                      "suspended"],
                                                                  registrationDate:
                                                                      userInfo.read(
                                                                              "allAccounts")[index]
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
    userInfo.read("searchResult").clear();
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (searchController.text.toLowerCase().contains("@")) {
        for (var item in userInfo.read("allAccounts")) {
          if (searchController.text.trim().toLowerCase() ==
              (item["email"] as String).toLowerCase()) {
            setState(() {
              userInfo.read("searchResult").add(item);
            });
          }
        }
        return searchResults();
      }
      for (var item in userInfo.read("allAccounts")) {
        if (searchController.text.trim().toLowerCase() ==
            (item["lastname"] as String).toLowerCase()) {
          setState(() {
            userInfo.read("searchResult").add(item);
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
          userInfo.write("allAccounts", response.data["data"]);
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
