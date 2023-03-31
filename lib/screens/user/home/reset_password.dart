// ignore_for_file: prefer_const_constructors, file_names, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/password_fields.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/buttons.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(context, "Reset Password"),
      body: SafeArea(
          child: SingleChildScrollView(
        child: mixedScreen(context),
      )),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.05, horizontal: size.width * 0.1),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PasswordFieldA(
                controller: currentPasswordController,
                width: size.width * 0.8,
                title: "Current password"),
            SizedBox(height: size.height * 0.02),
            PasswordFieldB(
                controller: newPasswordController,
                width: size.width * 0.8,
                height: size.width * 0.2,
                hintText: "New password"),
            SizedBox(height: size.height * 0.1),
            ListTile(
              leading: ButtonA(
                  width: size.width * 0.65,
                  text1: "Save",
                  text2: "Verifying..",
                  isLoading: false,
                  authenticate: () async {
                    await _save();
                  }),
              trailing: null,
            ),
          ],
        ),
      ),
    );
  }

  _save() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      final email = constantValues.userData["email"];
      final currentPassword = currentPasswordController.text.trim();
      final newPassword = newPasswordController.text.trim();
      try {
        var response1 = await dio.post("$backendUrl/verify-password", data: {
          "email": email,
          "password": currentPassword,
        });
        if (response1.data["success"] == "true") {
          var response2 = await dio.post("$backendUrl/update-password", data: {
            "email": email,
            "password": newPassword,
          });
          if (response2.data["success"]) {
            Fluttertoast.showToast(
              msg: response2.data["message"],
              toastLength: Toast.LENGTH_LONG,
              webPosition: "center",
            );
            context.goNamed("home");
          }
        } else {
          return ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response1.data["message"])));
        }
      } on DioError catch (error) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    }
  }
}
