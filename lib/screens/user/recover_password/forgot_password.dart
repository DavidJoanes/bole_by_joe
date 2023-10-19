// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/buttons.dart';
import '../../../controllers/controller.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/password_fields.dart';
import '../../background.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  final emailController = TextEditingController();
  final authCodeController = TextEditingController();
  final newPasswordController = TextEditingController();
  int stage = 1;

  _generateAuthCode() {
    return Random().nextInt(999999);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    authCodeController.dispose();
    newPasswordController.dispose();
    constantValues.authCode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Background(
                    height: size.height, child: mixedScreen(context)))));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontstyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    return stage == 1
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.2),
                  Text("Oops!,\nEnter your email address to continue..",
                      style: fontstyle1),
                  SizedBox(height: size.height * 0.1),
                  InputFieldEmailB(
                      controller: emailController,
                      width: size.width * 0.8,
                      title: "Email address"),
                  SizedBox(height: size.height * 0.05),
                  ButtonA(
                      width: size.width * 0.8,
                      text1: "Continue",
                      text2: "Validating",
                      isLoading: false,
                      authenticate: () async {
                        await _sendCode();
                      }),
                ],
              ),
            ),
          )
        : stage == 2
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.2),
                      Text(
                          "You're doing great.\nEnter the code you just received in your inbox..",
                          style: fontstyle1),
                      SizedBox(height: size.height * 0.1),
                      InputFieldA(
                          controller: authCodeController,
                          width: size.width * 0.8,
                          title: "Authorization code",
                          enabled: true,
                          hintIcon: SizedBox()),
                      SizedBox(height: size.height * 0.05),
                      ButtonA(
                          width: size.width * 0.8,
                          text1: "Verify",
                          text2: "Verifying",
                          isLoading: false,
                          authenticate: () async {
                            await _verifyCode();
                          }),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.15),
                      Text("Awesome,\nYou can now enter your new password..",
                          style: fontstyle1),
                      SizedBox(height: size.height * 0.1),
                      PasswordFieldB(
                        controller: newPasswordController,
                        width: size.width * 0.8,
                        height: size.width * 0.2,
                        hintText: "New password",
                      ),
                      SizedBox(height: size.height * 0.05),
                      ButtonA(
                          width: size.width * 0.8,
                          text1: "Confirm",
                          text2: "Processing",
                          isLoading: false,
                          authenticate: () async {
                            await _confirm();
                          }),
                    ],
                  ),
                ),
              );
  }

  _sendCode() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      final email = emailController.text.trim();
      final code = _generateAuthCode();
      setState(() {
        constantValues.authCode = code;
      });
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      try {
        var response = await dio.post("$backendUrl/validate-email", data: {
          "email": email,
          "code": constantValues.authCode,
        });
        if (response.data["success"]) {
          Navigator.of(context).pop();
          setState(() {
            stage = 2;
          });
        }
      } on DioError catch (error) {
        Navigator.of(context).pop();
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    }
  }

  _verifyCode() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      final code = int.parse(authCodeController.text.trim());
      if (code == constantValues.authCode) {
        setState(() {
          stage = 3;
        });
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid authorization code!")));
      }
    }
  }

  _confirm() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      final email = emailController.text.trim();
      final newPassw = newPasswordController.text.trim();
      try {
        var response = await dio.post("$backendUrl/update-password", data: {
          "email": email,
          "password": newPassw,
        });
        if (response.data["success"]) {
          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
          context.goNamed("signin");
        }
      } on DioError catch (error) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    }
  }
}
