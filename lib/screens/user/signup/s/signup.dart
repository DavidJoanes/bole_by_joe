// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../screens/resolution.dart';
import '../../../../screens/user/signup/s/signup_validation.dart';
import '../../../../controllers/controller.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/password_fields.dart';
import '../../../background.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  _generateAuthCode() {
    return Random().nextInt(999999);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
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
                    height: size.height * 1.3,
                    child: Resolution(
                        desktopScreen: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.2),
                          child: mixedScreen(context),
                        ),
                        mixedScreen: mixedScreen(context))))));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontstyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w400));
    final fontstyle1b = GoogleFonts.poppins(
        textStyle: TextStyle(
            color: constantValues.primaryColor, fontWeight: FontWeight.w400));
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          InputFieldA2(
              controller: firstNameController,
              width: size.width * 0.8,
              hintIcon: Icon(Icons.person),
              title: "First name",
              enabled: true),
          SizedBox(height: size.height * 0.02),
          InputFieldA2(
              controller: lastNameController,
              width: size.width * 0.8,
              hintIcon: Icon(Icons.person),
              title: "Last name",
              enabled: true),
          SizedBox(height: size.height * 0.02),
          InputFieldEmailA(
              controller: emailController,
              width: size.width * 0.8,
              title: "Email address"),
          SizedBox(height: size.height * 0.02),
          InputFieldPhone(
            controller: phoneNumberController,
            width: size.width * 0.8,
            title: "Phone number",
            enabled: true,
            hintIcon: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "+234",
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          PasswordFieldB(
            controller: passwordController,
            width: size.width * 0.8,
            height: size.width * 0.17,
            hintText: "Password",
          ),
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: OverflowBar(
              children: [
                Text("by clicking on 'Sign up', you agree to our ",
                    style: fontstyle1),
                OverflowBar(
                  children: [
                    GestureDetector(
                      child: Text(
                        "Policies ",
                        style: fontstyle1b,
                      ),
                    ),
                    Text("and ", style: fontstyle1),
                    GestureDetector(
                      child: Text(
                        "T&C",
                        style: fontstyle1b,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.05),
          ButtonA(
              width: size.width * 0.8,
              text1: "Sign Up",
              text2: "Processing",
              isLoading: false,
              authenticate: () async {
                await _signup();
              })
        ],
      ),
    );
  }

  _signup() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      final fname = firstNameController.text.trim().toLowerCase();
      final lname = lastNameController.text.trim().toLowerCase();
      final email = emailController.text.trim().toLowerCase();
      final phone = "+234${phoneNumberController.text.substring(1)}";
      final password = passwordController.text.trim();
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
        var response = await dio.post("$backendUrl/signup",
            data: {
              "code": constantValues.authCode,
              "firstname": fname,
              "lastname": lname,
              "email": email,
              "phonenumber": phone,
              "password": password,
            },
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.data["success"]) {
          setState(() {
            constantValues.tempUserData = response.data["data"];
          });
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SignupValidation()));
        } else {
          Navigator.of(context).pop();
          return ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.data["message"])));
        }
      } on DioError catch (error) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
    }
  }
}
