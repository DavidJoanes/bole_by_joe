// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/controller.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/profile_picture.dart';

final globalBucket = PageStorageBucket();

class BestPackages extends StatefulWidget {
  BestPackages(
      {super.key,
      required this.object,
      required this.object2,
      required this.isDesktop});
  var object;
  var object2;
  bool isDesktop;

  @override
  State<BestPackages> createState() => _BestPackagesState();
}

class _BestPackagesState extends State<BestPackages> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  var userInfo = GetStorage();

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
    Size size = MediaQuery.of(context).size;
    final fontstyle1 = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor,
            // fontSize: widget.isDesktop ? size.width * 0.02 : size.width * 0.034,
            fontWeight: FontWeight.w600));
    final fontstyle1b = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor, fontWeight: FontWeight.bold));
    final fontstyle1c = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor, fontWeight: FontWeight.w400));
    final fontstyle1d = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor,
            fontSize: 10,
            fontWeight: FontWeight.w300));
    return PageStorage(
      bucket: globalBucket,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.001, vertical: size.height * 0.01),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                child: Text("Best Packages For You", style: fontstyle1),
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                  height:
                      widget.isDesktop ? 182 : size.height * 0.25,
                  width: double.infinity,
                  child: widget.object.isNotEmpty
                      ? ListView.builder(
                          key: const PageStorageKey<String>("bestPacks"),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.object.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              height: widget.isDesktop
                                  ? 94 //size.height * 0.12
                                  : size.height * 0.28,
                              width: widget.isDesktop
                                  ? 350 //size.width * 0.25
                                  : size.width * 0.55,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    widget.object2[index].color1,
                                    widget.object2[index].color2,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Positioned(
                                    right: widget.isDesktop
                                  ? 20 : size.width * 0.03,
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          userInfo.read("isDarkTheme")
                                              ? constantValues.greyColor2
                                              : constantValues.whiteColor,
                                          BlendMode.modulate),
                                      child: ProfilePicture(
                                        radius: 50,
                                        image: widget.object[index]
                                            ["coverimage"]["url"],
                                        onClicked: () {},
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: widget.isDesktop
                                  ? 25 : size.height * 0.05,
                                      left: widget.isDesktop
                                  ? 20 : size.width * 0.03,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.object[index]["text1"],
                                              style: fontstyle1c),
                                          const SizedBox(height: 5),
                                          Text(widget.object[index]["text2"],
                                              style: fontstyle1b),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: widget.isDesktop
                                                ? size.width * 0.15
                                                : size.width * 0.23,
                                            child: Text(
                                              widget.object[index]["text3"],
                                              style: fontstyle1d,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          ButtonB(
                                              width: widget.isDesktop
                                                  ? 160 //size.width * 0.1
                                                  : size.width * 0.26,
                                              buttoncolor:
                                                  constantValues.whiteColor,
                                              textcolor:
                                                  constantValues.blackColor,
                                              text: "Order Now",
                                              onpress: () async {
                                                if (userInfo
                                                    .read("userData")
                                                    .isNotEmpty) {
                                                  try {
                                                    final email = userInfo.read(
                                                        "userData")["email"];
                                                    var response = await dio.post(
                                                        "$backendUrl/check-for-package-eligibility",
                                                        data: {
                                                          "email": email,
                                                          "packagename": widget
                                                                  .object[index]
                                                              ["packagename"],
                                                        });
                                                    if (response
                                                            .data["status"] ==
                                                        "eligible") {
                                                      setState(() {
                                                        userInfo.write(
                                                            "selectedPackage",
                                                            widget
                                                                .object[index]);
                                                      });
                                                      context.goNamed(
                                                        "package",
                                                        params: {
                                                          "name": (widget.object[
                                                                          index]
                                                                      [
                                                                      "packagename"]
                                                                  as String)
                                                              .toLowerCase()
                                                        },
                                                      );
                                                    } else {
                                                      return ScaffoldMessenger
                                                              .of(context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  response.data[
                                                                      "message"])));
                                                    }
                                                  } on DioError catch (error) {
                                                    return ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(error
                                                                    .response!
                                                                    .data[
                                                                "message"])));
                                                  }
                                                } else {
                                                  context.goNamed("signin");
                                                  return ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "You are required to be signed in to proceed to order this package!")));
                                                }
                                              })
                                        ],
                                      )),
                                ],
                              ),
                            ).animate().fadeIn().slideX(curve: Curves.easeIn);
                          })
                      : const Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    );
  }
}
