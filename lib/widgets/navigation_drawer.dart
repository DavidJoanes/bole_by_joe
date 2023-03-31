// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controllers/data_controller.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
    final fontstyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold));
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),
              Image.asset(
                "assets/icons/admin.png",
                height: size.height * 0.1,
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                  width: size.width * 0.5,
                  child: Text(
                    "Admin: ${constantValues.userData["email"]}",
                    style: fontstyle1,
                    overflow: TextOverflow.ellipsis
                  )),
              Divider(),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: Icon(Icons.shop_2_outlined),
                title: Text("Packages"),
                onTap: () {
                  context.goNamed("all-packages");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: Icon(Icons.people_alt_outlined),
                title: Text("Accounts"),
                onTap: () {
                  context.goNamed("all-accounts");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: Icon(Icons.shopping_cart_checkout_outlined),
                title: Text("Orders"),
                onTap: () {
                  context.goNamed("all-orders");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: Icon(Icons.receipt_long_sharp),
                title: Text("Refunds"),
                onTap: () {
                  context.goNamed("all-refunds");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: Icon(Icons.date_range_outlined),
                title: Text("Logs"),
                onTap: () {
                  context.goNamed("all-data-logs");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
