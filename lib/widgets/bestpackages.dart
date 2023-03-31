// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/controller.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/profile_picture.dart';

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
            fontSize:
                widget.isDesktop ? size.width * 0.014 : size.width * 0.028,
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
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03, vertical: size.height * 0.01),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Best Packages For You", style: fontstyle1),
            SizedBox(height: size.height * 0.02),
            SizedBox(
                height: size.height * 0.25,
                width: double.infinity,
                child: widget.object.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.object.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: widget.isDesktop
                                ? size.height * 0.12
                                : size.height * 0.28,
                            width: widget.isDesktop
                                ? size.width * 0.35
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
                                  top: size.height * 0.03,
                                  right: size.width * 0.03,
                                  child: ProfilePicture(
                                    radius: 50,
                                    image: widget.object[index]["coverimage"]
                                        ["url"],
                                    onClicked: () {},
                                  ),
                                ),
                                Positioned(
                                    top: size.height * 0.05,
                                    left: size.width * 0.03,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.object[index]["text1"],
                                            style: fontstyle1c),
                                        SizedBox(height: 5),
                                        Text(widget.object[index]["text2"],
                                            style: fontstyle1b),
                                        SizedBox(height: 5),
                                        SizedBox(
                                          width: size.width*0.23,
                                          child: Text(
                                            widget.object[index]["text3"],
                                            style: fontstyle1d,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ButtonB(
                                            width: widget.isDesktop
                                                ? size.width * 0.12
                                                : size.width * 0.26,
                                            buttoncolor:
                                                constantValues.whiteColor,
                                            textcolor:
                                                constantValues.blackColor,
                                            text: "Order Now",
                                            onpress: () async {
                                              if (constantValues
                                                  .userData.isNotEmpty) {
                                                try {
                                                  final email = constantValues
                                                      .userData["email"];
                                                  var response = await dio.post(
                                                      "$backendUrl/check-for-package-eligibility",
                                                      data: {
                                                        "email": email,
                                                        "packagename":
                                                            widget.object[index]
                                                                ["packagename"],
                                                      });
                                                  if (response.data["status"] ==
                                                      "eligible") {
                                                    setState(() {
                                                      constantValues
                                                              .selectedPackage =
                                                          widget.object[index];
                                                    });
                                                    context.goNamed(
                                                      "package",
                                                      params: {
                                                        "name": (widget.object[
                                                                        index][
                                                                    "packagename"]
                                                                as String)
                                                            .toLowerCase()
                                                      },
                                                    );
                                                  } else {
                                                    return ScaffoldMessenger.of(
                                                            context)
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
                                                return ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "You are required to be signed in to proceed to order this package!")));
                                              }
                                            })
                                      ],
                                    )),
                              ],
                            ),
                          );
                        })
                    : Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
