// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../screens/user/home/checkout.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/profile_picture.dart';
import '../../../widgets/title_case.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/dialogs.dart';

class Cartalog extends StatefulWidget {
  const Cartalog({super.key});

  @override
  State<Cartalog> createState() => _CartalogState();
}

class _CartalogState extends State<Cartalog> {
  final constantValues = Get.find<Constants>();
  int subTotal = 0;

  _calculateTotal() {
    subTotal = 0;
    if (constantValues.cart.isNotEmpty) {
      for (var item in constantValues.cart) {
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
    _calculateTotal();
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
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    return Scaffold(
        appBar: secondaryAppBar2(
          context,
          "Cart",
          IconButton(
            tooltip: "Clear cart",
            icon: Icon(Icons.delete),
            onPressed: () {
              _clearCart();
            },
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: mixedScreen(context))),
        bottomNavigationBar: bottomAppBar(
          context,
          Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
              title: Text("${currencyIcon(context).currencySymbol}$subTotal",
                  style: fontStyle1),
              subtitle: Text("Subtotal"),
              trailing: ButtonC(
                  width: size.width * 0.28,
                  text: "Checkout",
                  onpress: () {
                    _checkout();
                  }),
            ),
          ),
        ));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w400));
    return Column(
      children: [
        ListTile(
          trailing: IconButton(
            icon: Icon(Icons.info_outline, color: constantValues.errorColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Swipe left to remove item from cart..")));
            },
          ),
        ),
        SizedBox(
          height: size.height * 0.7,
          child: constantValues.cart.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: constantValues.cart.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.02),
                      child: Slidable(
                        key: ValueKey(index),
                        endActionPane: ActionPane(
                          motion: BehindMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => _remove(index),
                              backgroundColor: constantValues.errorColor,
                              foregroundColor: constantValues.whiteColor,
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
                              image: constantValues.cart[index]["coverimage"]
                                  ["url"],
                              onClicked: () {},
                            ),
                            title: Text(
                                (constantValues.cart[index]["packagename"] as String).toTitleCase(),
                                style: fontStyle1),
                            subtitle: Text(
                                "Qty: ${constantValues.cart[index]["qty"]}"),
                            trailing: Text(
                              "${currencyIcon(context).currencySymbol}${constantValues.cart[index]["price"]}",
                              style: fontStyle1,
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Center(child: Text("Your cart is empty..", style: fontStyle1b)),
        ),
      ],
    );
  }

  _clearCart() {
    constantValues.cart.isNotEmpty
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Dialog2b(
                title: Text("Confirmation"),
                widget: Text("Do you wish to clear your cartalog?"),
                buttons: [
                  TextButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      setState(() {
                        constantValues.cart.clear();
                        _calculateTotal();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            })
        : ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Cartalog is empty!")));
  }

  _remove(index) {
    for (var item in constantValues.cart) {
      if (constantValues.cart[index]["packagename"] == item["packagename"]) {
        setState(() {
          constantValues.cart.remove(item);
          _calculateTotal();
        });
      }
    }
  }

  _checkout() {
    if (constantValues.userData.isNotEmpty) {
      if (constantValues.cart.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => CheckOut(subTotal: subTotal)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Your cart is empty!")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("You are required to be signed in to proceed!")));
    }
  }
}
