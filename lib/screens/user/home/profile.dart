import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/profile_picture.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/display_image.dart';
import '../../../widgets/overlay_builder.dart';
import '../../resolution.dart';

final globalBucket = PageStorageBucket();

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final constantValues = Get.find<Constants>();
  var userInfo = GetStorage();
  late List<dynamic> dispatcherRatings =
      userInfo.read("userData")['ratings']! as List<dynamic>;
  late double dispatcherRating =
      dispatcherRatings.reduce((a, b) => ((a + b))) / dispatcherRatings.length;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: globalBucket,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Resolution(
                  desktopScreen: desktopScreen(context),
                  mixedScreen: mixedScreen(context))),
        ),
      ),
    );
  }

  Widget desktopScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(textStyle: const TextStyle());
    return userInfo.read("userData").isNotEmpty
        ? Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                topSection(
                    context,
                    userInfo.read("userData")["profileimage"]["url"] != ""
                        ? userInfo.read("userData")["profileimage"]["url"]
                        : "assets/icons/user.png",
                    true),
                SizedBox(height: size.height * 0.05),
                ListTile(
                  title: Text("PERSONAL", style: fontStyle1),
                  tileColor: constantValues.greyColor,
                ),
                ListTile(
                  leading: Icon(Icons.info_outline_rounded,
                      color: constantValues.primaryColor),
                  title: Text("Complaint", style: fontStyle1),
                  trailing: const Icon(Icons.arrow_right_outlined),
                  onTap: () {
                    _complaint();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.attach_money_outlined,
                      color: constantValues.primaryColor),
                  title: Text("Refund", style: fontStyle1),
                  trailing: const Icon(Icons.arrow_right_outlined),
                  onTap: () {
                    _refund();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.password_outlined,
                      color: constantValues.primaryColor),
                  title: Text("Reset password", style: fontStyle1),
                  trailing: const Icon(Icons.arrow_right_outlined),
                  onTap: () {
                    _resetPassword();
                  },
                ),
                ListTile(
                  title: Text("ABOUT US", style: fontStyle1),
                  tileColor: constantValues.greyColor,
                ),
                ListTile(
                  leading: Icon(Icons.policy_outlined,
                      color: constantValues.primaryColor),
                  title: Text("Policy", style: fontStyle1),
                  trailing: const Icon(Icons.arrow_right_outlined),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.info_outlined,
                      color: constantValues.primaryColor),
                  title: Text("Terms & Condition", style: fontStyle1),
                  trailing: const Icon(Icons.arrow_right_outlined),
                  onTap: () {},
                ),
                SizedBox(height: size.height * 0.01),
              ],
            ),
        )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.4),
            child: Center(
              child: Column(
                children: [
                  const Text("Not signed in yet?"),
                  const SizedBox(height: 10),
                  ButtonC2(
                    width: size.width * 0.2,
                    text: "Signin",
                    onpress: () {
                      context.goNamed("signin");
                    },
                  )
                ],
              ),
            ),
          );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(textStyle: const TextStyle());
    return userInfo.read("userData").isNotEmpty
        ? Column(
            children: [
              SizedBox(height: size.height * 0.05),
              topSection(
                  context,
                  userInfo.read("userData")["profileimage"]["url"] != ""
                      ? userInfo.read("userData")["profileimage"]["url"]
                      : "assets/icons/user.png",
                  false),
              SizedBox(height: size.height * 0.05),
              ListTile(
                title: Text("PERSONAL", style: fontStyle1),
                tileColor: constantValues.greyColor,
              ),
              ListTile(
                leading: Icon(Icons.info_outline_rounded,
                    color: constantValues.primaryColor),
                title: Text("Complaint", style: fontStyle1),
                trailing: const Icon(Icons.arrow_right_outlined),
                onTap: () {
                  _complaint();
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_money_outlined,
                    color: constantValues.primaryColor),
                title: Text("Refund", style: fontStyle1),
                trailing: const Icon(Icons.arrow_right_outlined),
                onTap: () {
                  _refund();
                },
              ),
              ListTile(
                leading: Icon(Icons.password_outlined,
                    color: constantValues.primaryColor),
                title: Text("Reset password", style: fontStyle1),
                trailing: const Icon(Icons.arrow_right_outlined),
                onTap: () {
                  _resetPassword();
                },
              ),
              ListTile(
                title: Text("ABOUT US", style: fontStyle1),
                tileColor: constantValues.greyColor,
              ),
              ListTile(
                leading: Icon(Icons.policy_outlined,
                    color: constantValues.primaryColor),
                title: Text("Policy", style: fontStyle1),
                trailing: const Icon(Icons.arrow_right_outlined),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.info_outlined,
                    color: constantValues.primaryColor),
                title: Text("Terms & Condition", style: fontStyle1),
                trailing: const Icon(Icons.arrow_right_outlined),
                onTap: () {},
              ),
              SizedBox(height: size.height * 0.01),
            ],
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.4),
            child: Center(
              child: Column(
                children: [
                  const Text("Not signed in yet?"),
                  const SizedBox(height: 10),
                  ButtonC2(
                    width: size.width * 0.2,
                    text: "Signin",
                    onpress: () {
                      context.goNamed("signin");
                    },
                  )
                ],
              ),
            ),
          );
  }

  Widget topSection(BuildContext context, String image, bool isDesktop) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? size.width * 0.02 : size.width * 0.04));
    final fontStyle1b = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontSize: isDesktop ? size.width * 0.01 : size.width * 0.03,
            fontWeight: FontWeight.w300));
    final fontStyle2 = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? size.width * 0.03 : size.width * 0.05));
    final fontStyle2b = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontSize: isDesktop ? size.width * 0.02 : size.width * 0.04,
            fontWeight: FontWeight.w300));
    final fontStyle3 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold));
    final fontStyle3b = GoogleFonts.poppins(
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400));
    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: isDesktop ? size.width * 0.08 : size.width * 0.13,
                backgroundColor: constantValues.primaryColor,
                child: ProfilePicture(
                  image: image,
                  radius: isDesktop ? size.width * 0.07 : size.width * 0.12,
                  onClicked: () {
                    Navigator.of(context).push(OverlayBuilder(
                        builder: (context) => DisplayImage(
                            image: image.startsWith("a")
                                ? AssetImage(image)
                                : NetworkImage(image))));
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Joined", style: fontStyle1b),
                  SizedBox(
                      width: isDesktop ? size.width * 0.01 : size.width * 0.02),
                  Text(
                      "${userInfo.read("userData")["registrationdate"].split("-")[1]}, ${userInfo.read("userData")["registrationdate"].split("-")[0]}",
                      style: fontStyle1),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      (userInfo.read("userData")["firstname"] as String)
                          .toTitleCase(),
                      style: fontStyle2b),
                  Text(
                      (userInfo.read("userData")["lastname"] as String)
                          .toTitleCase(),
                      style: fontStyle2),
                ],
              ),
              ButtonC2b(
                  width: isDesktop ? size.width * 0.22 : size.width * 0.32,
                  text: "Edit Profile",
                  onpress: () {
                    _editProfile();
                  })
            ],
          ),
          SizedBox(height: size.height * 0.02),
          userInfo.read("userData")["accounttype"] == "dispatcher"
              ? OverflowBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: constantValues.primaryColor),
                        Text(dispatcherRating.toStringAsFixed(1),
                            style: fontStyle3),
                        Text("Rating", style: fontStyle3b),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopify_outlined),
                        Text("${userInfo.read("userData")['deliveries']}",
                            style: fontStyle3),
                        Text("Delivery", style: fontStyle3b),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  _editProfile() {
    context.goNamed("edit-profile");
  }

  _complaint() {
    context.goNamed("complaint-history");
  }

  _refund() {
    context.goNamed("refund-history");
  }

  _resetPassword() {
    context.goNamed("reset-password");
  }

  // _policy() {
  //   context.goNamed("policy");
  // }

  // _termsAndCondition() {
  //   context.goNamed("t&c");
  // }
}
