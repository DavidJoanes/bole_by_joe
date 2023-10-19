import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
    final fontstyle1 =
        GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold));
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),
              Image.asset(
                userInfo.read("isDarkTheme")
                    ? "assets/icons/admin_white.png"
                    : "assets/icons/admin_black.png",
                height: size.height * 0.1,
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                width: size.width * 0.45,
                child: Text("Admin: ${userInfo.read("userData")["email"]}",
                    style: fontstyle1, overflow: TextOverflow.ellipsis),
              ),
              const Divider(),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: const Icon(Icons.shop_2_outlined),
                title: const Text("Packages"),
                onTap: () {
                  context.goNamed("all-packages");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: const Icon(Icons.people_alt_outlined),
                title: const Text("Accounts"),
                onTap: () {
                  context.goNamed("all-accounts");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: const Icon(Icons.shopping_cart_checkout_outlined),
                title: const Text("Orders"),
                onTap: () {
                  context.goNamed("all-orders");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: const Icon(Icons.receipt_long_sharp),
                title: const Text("Refunds"),
                onTap: () {
                  context.goNamed("all-refunds");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text("Complaints"),
                onTap: () {
                  context.goNamed("all-complaints");
                },
              ),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: const Icon(Icons.date_range_outlined),
                title: const Text("Logs"),
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
