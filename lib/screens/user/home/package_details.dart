// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../widgets/buttons.dart';
import '../../../widgets/profile_picture.dart';
import '../../../widgets/reviews.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../resolution.dart';

class PackageDetails extends StatefulWidget {
  PackageDetails(
      {super.key,
      required this.packageCoverImage,
      required this.packageImages,
      required this.packageName,
      required this.description,
      required this.price,
      required this.discount,
      required this.rating,
      required this.reviews,
      required this.availability});
  var packageCoverImage;
  var packageImages;
  var packageName;
  var description;
  var price;
  var discount;
  var rating;
  var reviews;
  var availability;

  @override
  State<PackageDetails> createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  final constantValues = Get.find<Constants>();
  var userInfo = GetStorage();
  int currentIndex = 0;
  int qty = 1;
  late int price = widget.price;
  late int discounted = widget.discount * widget.price;
  int subTotal = 0;

  _calculateTotal() {
    subTotal = 0;
    if (userInfo.read("cart").isNotEmpty) {
      for (var item in userInfo.read("cart")) {
        setState(() {
          subTotal += item["price"] as int;
        });
      }
    } else {
      setState(() {
        subTotal = 0;
      });
    }
  }

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
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(
        textStyle: const TextStyle(decoration: TextDecoration.lineThrough));
    final fontStyle1c = GoogleFonts.poppins(
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300));
    return Scaffold(
        appBar: secondaryAppBar2(
            context,
            "Details",
            IconButton(
              tooltip: "Cart",
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_basket_outlined),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: Text(
                        "${userInfo.read("cart").length}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: constantValues.errorColor),
                      ))
                ],
              ),
              onPressed: () {
                context.goNamed("cartalog");
              },
            )),
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Resolution(
                    desktopScreen: desktopScreen(context),
                    mixedScreen: mixedScreen(context)))),
        bottomNavigationBar: bottomAppBar(
          context,
          widget.discount > 0
              ? Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                            "${currencyIcon(context).currencySymbol}$discounted",
                            style: fontStyle1),
                        Row(
                          children: [
                            IconButton(
                              tooltip: "decrease qty",
                                icon: const Icon(Icons.remove, size: 12),
                                onPressed: () {
                                  if (qty > 1) {
                                    setState(() {
                                      discounted =
                                          widget.discount * widget.price;
                                      qty--;
                                      discounted = discounted * qty;
                                    });
                                  }
                                }),
                            Text("$qty", style: fontStyle1c),
                            IconButton(
                              tooltip: "increase qty",
                                icon: const Icon(Icons.add, size: 12),
                                onPressed: () {
                                  setState(() {
                                    discounted = widget.discount * widget.price;
                                    qty++;
                                    discounted = discounted * qty;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Text(
                        "${currencyIcon(context).currencySymbol}${widget.price}",
                        style: fontStyle1b),
                    trailing: ButtonC(
                        width: size.width * 0.3,
                        text: "Add to cart",
                        onpress: () {
                          _addToCart(true);
                        }),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text("${currencyIcon(context).currencySymbol}$price",
                            style: fontStyle1),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.remove, size: 12),
                                onPressed: () {
                                  if (qty > 1) {
                                    setState(() {
                                      qty--;
                                      price = widget.price * qty;
                                    });
                                  }
                                }),
                            Text("$qty", style: fontStyle1c),
                            IconButton(
                                icon: const Icon(Icons.add, size: 12),
                                onPressed: () {
                                  setState(() {
                                    qty++;
                                    price = widget.price * qty;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                    trailing: ButtonC(
                        width: size.width * 0.3,
                        text: "Add to cart",
                        onpress: () {
                          _addToCart(false);
                        }),
                  ),
                ),
        ));
  }

  Widget desktopScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w400));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                      horizontal: size.width * 0.05),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.6,
                        child: CarouselSlider(
                          options: CarouselOptions(
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 500),
                              height: size.height * 0.6,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              }),
                          items: widget.packageImages.map<Widget>((item) {
                            return GridTile(
                              child: Card(
                                child: Container(
                                  height: size.height * 0.5,
                                  width: size.width * 0.5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(item),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < widget.packageImages.length; i++)
                            Container(
                              height: 12,
                              width: 12,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: currentIndex == i
                                      ? constantValues.primaryColor
                                      : constantValues.whiteColor,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                        offset: Offset(2, 2))
                                  ]),
                            )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: ListTile(
                    title: Text(widget.packageName, style: fontStyle1),
                    subtitle:
                        Text(widget.availability ? "available" : "unavailable"),
                    trailing: widget.availability
                        ? Icon(Icons.gpp_good_outlined,
                            color: constantValues.successColor)
                        : Icon(Icons.gpp_bad_outlined,
                            color: constantValues.errorColor),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.star, color: constantValues.primaryColor),
                      const SizedBox(width: 5),
                      Text("${widget.rating.toStringAsFixed(1)}",
                          style: fontStyle1b),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: description("Description", widget.description),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Reviews(reviews: widget.reviews),
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Cart", style: fontStyle1),
                    trailing: IconButton(
                tooltip: "Info",
                      icon: Icon(Icons.info_outline,
                          color: constantValues.errorColor),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content:
                                Text("Swipe left to remove item from cart..")));
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height,
                    child: userInfo.read("cart").isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: userInfo.read("cart").length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01,
                                    horizontal: size.width * 0.02),
                                child: Slidable(
                                  key: ValueKey(index),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) => _remove(index),
                                        backgroundColor:
                                            constantValues.errorColor,
                                        foregroundColor:
                                            constantValues.whiteColor,
                                        icon: Icons.delete,
                                        label: "remove",
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    elevation: 4,
                                    child: ListTile(
                                      leading: ProfilePicture(
                                        radius: 20,
                                        image: userInfo.read("cart")[index]
                                            ["coverimage"]["url"],
                                        onClicked: () {},
                                      ),
                                      title: Text(
                                          (userInfo.read("cart")[index]
                                                  ["packagename"] as String)
                                              .toTitleCase(),
                                          style: fontStyle1),
                                      subtitle: Text(
                                          "Qty: ${userInfo.read("cart")[index]["qty"]}"),
                                      trailing: Text(
                                        "${currencyIcon(context).currencySymbol}${userInfo.read("cart")[index]["price"]}",
                                        style: fontStyle1,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child:
                                Text("Your cart is empty..", style: fontStyle1b)),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w400));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.02, horizontal: size.width * 0.01),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.4,
                  child: CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 500),
                        height: size.height * 0.4,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        }),
                    items: widget.packageImages.map<Widget>((item) {
                      return GridTile(
                        child: Card(
                          child: Container(
                            height: size.height * 0.3,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(item), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < widget.packageImages.length; i++)
                      Container(
                        height: 12,
                        width: 12,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: currentIndex == i
                                ? constantValues.primaryColor
                                : constantValues.whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  offset: Offset(2, 2))
                            ]),
                      )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          ListTile(
            title: Text((widget.packageName as String).toTitleCase(),
                style: fontStyle1),
            subtitle: Text(widget.availability ? "available" : "unavailable"),
            trailing: widget.availability
                ? Icon(Icons.gpp_good_outlined,
                    color: constantValues.successColor)
                : Icon(Icons.gpp_bad_outlined,
                    color: constantValues.errorColor),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.star, color: constantValues.primaryColor),
              const SizedBox(width: 5),
              Text("${widget.rating.toStringAsFixed(1)}", style: fontStyle1b),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          description("Description", widget.description),
          SizedBox(height: size.height * 0.01),
          Reviews(reviews: widget.reviews),
          SizedBox(height: size.height * 0.05),
        ],
      ),
    );
  }

  Widget description(String title, info) {
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold));
    final fontStyle1b = GoogleFonts.poppins(
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: fontStyle1),
      const SizedBox(height: 5),
      OverflowBar(
        children: [Text(info, style: fontStyle1b)],
      )
    ]);
  }

  _addToCart(bool isDiscounted) {
    // var toRemove = [];
    if (widget.availability) {
      if (userInfo.read("cart").isEmpty) {
        setState(() {
          userInfo.read("cart").add({
            "coverimage": widget.packageCoverImage,
            "packagename": widget.packageName,
            "qty": qty,
            "price": isDiscounted ? discounted : price
          });
        });
        Fluttertoast.showToast(
          msg: "${widget.packageName} added to cart..",
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      } else {
        for (var item in userInfo.read("cart")) {
          if (widget.packageName == item["packagename"]) {
            return Fluttertoast.showToast(
              msg: "${widget.packageName} is already in cart!",
              toastLength: Toast.LENGTH_LONG,
              webPosition: "center",
            );
          }
        }
        setState(() {
          userInfo.read("cart").add({
            "coverimage": widget.packageCoverImage,
            "packagename": widget.packageName,
            "qty": qty,
            "price": isDiscounted ? discounted : price
          });
        });
        Fluttertoast.showToast(
          msg: "${widget.packageName} added to cart.",
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      }
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${widget.packageName} is out of stock!")));
    }
  }

  _remove(index) {
    for (var item in userInfo.read("cart")) {
      if (userInfo.read("cart")[index]["packagename"] == item["packagename"]) {
        setState(() {
          userInfo.read("cart").remove(item);
          _calculateTotal();
        });
      }
    }
  }
}
