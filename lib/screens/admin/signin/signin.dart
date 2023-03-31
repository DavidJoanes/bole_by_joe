// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../controllers/controller.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/password_fields.dart';
import '../../background.dart';
import '../../resolution.dart';

class AdminSignin extends StatefulWidget {
  const AdminSignin({super.key});

  @override
  State<AdminSignin> createState() => _AdminSigninState();
}

class _AdminSigninState extends State<AdminSignin> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Resolution(
                    desktopScreen: desktopScreen(context),
                    mixedScreen: mixedScreen(context)))));
  }

  Widget desktopScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: Background(
            height: size.height,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.2),
                  Image.asset(
                    constantValues.isDarkTheme
                        ? "assets/icons/logo3b.png"
                        : "assets/icons/logob.png",
                    height: size.height * 0.2,
                  ),
                  SizedBox(height: size.height * 0.1),
                  InputFieldEmailB(
                      controller: emailController,
                      width: size.width * 0.4,
                      title: "Email"),
                  SizedBox(height: size.height * 0.03),
                  PasswordFieldA(
                      controller: passwordController,
                      width: size.width * 0.4,
                      title: "Password"),
                  SizedBox(height: size.height * 0.05),
                  ButtonA(
                      width: size.width * 0.4,
                      text1: "Sign In",
                      text2: "Authenticating",
                      isLoading: false,
                      authenticate: () async {
                        await _signin();
                      }),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: size.width * 0.5,
          color: constantValues.greyColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: size.height,
                width: size.width * 0.5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05, vertical: size.height * 0.2),
                child: Image.asset("assets/icons/admin_cover.png", scale: 2),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        height: size.height,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.2),
                Image.asset(
                  "assets/icons/admin_cover.png",
                  height: size.height * 0.2,
                ),
                SizedBox(height: size.height * 0.1),
                InputFieldEmailB(
                    controller: emailController,
                    width: size.width * 0.8,
                    title: "Email"),
                SizedBox(height: size.height * 0.03),
                PasswordFieldA(
                    controller: passwordController,
                    width: size.width * 0.8,
                    title: "Password"),
                SizedBox(height: size.height * 0.05),
                ButtonA(
                    width: size.width * 0.8,
                    text1: "Sign In",
                    text2: "Authenticating",
                    isLoading: false,
                    authenticate: () async {
                      await _signin();
                    }),
              ],
            )));
  }

  _signin() async {
    final form = _formKey.currentState!;
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();
    String token = "";
    if (form.validate()) {
      try {
        var response = await dio.post("$backendUrl2/admin-signin",
            data: {
              "email": email,
              "password": password,
            },
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.data["success"]) {
          setState(() {
            token = response.data["token"];
          });
          Map<String, String> retrievedHeader = {
            "access-token": token,
          };
          var response2 = await dio.post(
            "$backendUrl/validate",
            data: {},
            options: Options(
                contentType: Headers.formUrlEncodedContentType,
                headers: retrievedHeader),
          );
          if (response2.data["success"]) {
            Fluttertoast.showToast(
              msg: response.data["message"],
              toastLength: Toast.LENGTH_LONG,
              webPosition: "center",
            );
            setState(() {
              constantValues.userData = response.data["data"];
              adminLoggedIn = true;
            });
            context.goNamed("dashboard");
          }
        } else {
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
