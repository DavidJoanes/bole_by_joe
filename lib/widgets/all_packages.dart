// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/controller.dart';

final globalBucket = PageStorageBucket();

class AllPacks extends StatefulWidget {
  AllPacks({super.key, required this.object, required this.isDesktop});
  var object;
  final bool isDesktop;

  @override
  State<AllPacks> createState() => _AllPacksState();
}

class _AllPacksState extends State<AllPacks> {
  final constantValues = Get.find<Constants>();
  var userInfo = GetStorage();

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

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
        textStyle: const TextStyle(
            // fontSize:
            //     widget.isDesktop ? size.width * 0.02 : size.width * 0.034,
            fontWeight: FontWeight.w600));
    final fontstyle2 = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor,
            fontSize: 12,
            fontWeight: FontWeight.w600));
    final fontstyle2b = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor,
            fontSize: 10,
            fontWeight: FontWeight.w300));
    return PageStorage(
      bucket: globalBucket,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.01, vertical: size.height * 0.03),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
            child: Text("Popular Packages", style: fontstyle1),
          ),
          SizedBox(height: size.height * 0.02),
          SizedBox(
              height: size.height * 0.4,
              width: size.width,
              child: widget.object.isNotEmpty
                  ? GridView.count(
                      key: const PageStorageKey<String>("normalPacks"),
                      crossAxisCount: widget.isDesktop ? 4 : 2,
                      crossAxisSpacing: size.width * 0.02,
                      children: [
                          for (var item in widget.object)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01),
                              child: Card(
                                elevation: 4,
                                child: InkWell(
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        userInfo.read("isDarkTheme")
                                            ? constantValues.greyColor2
                                            : constantValues.whiteColor,
                                        BlendMode.modulate),
                                    child: Container(
                                      height: widget.isDesktop
                                          ? size.height * 0.15
                                          : size.height * 0.3,
                                      width: widget.isDesktop
                                          ? size.width * 0.2
                                          : size.width * 0.4,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                item["coverimage"]["url"]),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Stack(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Card(
                                                  color: constantValues
                                                      .primaryColor,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4),
                                                    child: Text(
                                                        item["packagename"]
                                                            .toUpperCase(),
                                                        style: fontstyle2),
                                                  )),
                                              Card(
                                                  color: constantValues
                                                      .transparentColor,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2),
                                                    child: Text(
                                                        "${currencyIcon(context).currencySymbol}${item["price"]}",
                                                        style: fontstyle2b),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      userInfo.write("selectedPackage", item);
                                    });
                                    context.goNamed(
                                      "package",
                                      params: {
                                        "name":
                                            (userInfo.read("selectedPackage")[
                                                    "packagename"] as String)
                                                .toLowerCase()
                                      },
                                    );
                                  },
                                ),
                              ),
                            ).animate().fadeIn().slideY(curve: Curves.bounceIn),
                        ])
                  : const Center(child: CircularProgressIndicator())),
        ]),
      ),
    );
  }
}
