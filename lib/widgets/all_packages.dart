// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/controller.dart';

class AllPacks extends StatefulWidget {
  AllPacks({super.key, required this.object, required this.isDesktop});
  var object;
  final bool isDesktop;

  @override
  State<AllPacks> createState() => _AllPacksState();
}

class _AllPacksState extends State<AllPacks> {
  final constantValues = Get.find<Constants>();

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
        textStyle: TextStyle(
            fontSize:
                widget.isDesktop ? size.width * 0.014 : size.width * 0.028,
            fontWeight: FontWeight.w600));
    final fontstyle2 = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor, fontSize: 12, fontWeight: FontWeight.w600));
    final fontstyle2b = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.whiteColor,
            fontSize: 10,
            fontWeight: FontWeight.w300));
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03, vertical: size.height * 0.05),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("All Packages", style: fontstyle1),
        SizedBox(height: size.height * 0.02),
        SizedBox(
            height: size.height * 0.4,
            width: size.width,
            child: widget.object.isNotEmpty
                ? GridView.count(
                    crossAxisCount: widget.isDesktop ? 3 : 2,
                    crossAxisSpacing: size.width * 0.04,
                    children: [
                        for (var item in widget.object)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.02),
                            child: Card(
                              elevation: 4,
                              child: InkWell(
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
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Card(
                                              color:
                                                  constantValues.primaryColor,
                                              child: Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                    item["packagename"]
                                                        .toUpperCase(),
                                                    style: fontstyle2),
                                              )),
                                          Card(
                                              color: constantValues
                                                  .transparentColor,
                                              child: Padding(
                                                padding: EdgeInsets.all(2),
                                                child: Text(
                                                    "${currencyIcon(context).currencySymbol}${item["price"]}",
                                                    style: fontstyle2b),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    constantValues.selectedPackage = item;
                                  });
                                  context.goNamed(
                                    "package",
                                    params: {
                                      "name": (constantValues.selectedPackage[
                                              "packagename"] as String)
                                          .toLowerCase()
                                    },
                                  );
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => PackageDetails(
                                  //           packageCoverImage: item.coverImage,
                                  //           packageImages: item.images,
                                  //           packageName: item.packageName,
                                  //           description: item.description,
                                  //           price: item.price,
                                  //           discount: item.discount,
                                  //           rating: item.ratings
                                  //                   .reduce((a, b) => ((a + b))) /
                                  //               item.ratings.length,
                                  //           reviews: item.reviews,
                                  //           availability: item.availability,
                                  //         )));
                                },
                              ),
                            ),
                          ),
                      ])
                : Center(child: CircularProgressIndicator())),
      ]),
    );
  }
}
