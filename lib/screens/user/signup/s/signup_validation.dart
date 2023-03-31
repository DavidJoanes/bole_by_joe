// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/app_bar.dart';
import '../../../../controllers/controller.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/input_fields.dart';
import '../../../background.dart';

class SignupValidation extends StatefulWidget {
  const SignupValidation({super.key});

  @override
  State<SignupValidation> createState() => _SignupValidationState();
}

class _SignupValidationState extends State<SignupValidation> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  final authCodeController = TextEditingController();
  int stage = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    authCodeController.dispose();
    constantValues.authCode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: primaryAppBar(context, "Signup Validation"),
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
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Form(
            key: _formKey,
            child: Column(children: [
              SizedBox(height: size.height * 0.2),
              Text("Please, enter the code you just received in your inbox..",
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
            ])));
  }

  _verifyCode() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      final code = int.parse(authCodeController.text.trim());
      if (code == constantValues.authCode) {
        try {
          var response = await dio.post("$backendUrl/validate_signup", data: {
            "email": constantValues.tempUserData["email"],
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
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid authorization code!")));
      }
    }
  }
}
