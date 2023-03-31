// ignore_for_file: prefer_const_constructors, invalid_use_of_visible_for_testing_member, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../screens/background.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/password_fields.dart';
import '../../../controllers/controller.dart';
import '../../resolution.dart';

class UserSignin extends StatefulWidget {
  const UserSignin({super.key});

  @override
  State<UserSignin> createState() => _UserSigninState();
}

class _UserSigninState extends State<UserSignin> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  saveCredentials(email, password) async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', email);
    pref.setString('password', password);
  }

  getCredentials() async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';
    String passw = pref.getString('password') ?? '';
    email != ''
        ? setState(() {
            constantValues.rememberPassword = true;
            emailController.text = email;
            passwordController.text = passw;
          })
        : null;
  }

  @override
  void initState() {
    getCredentials();
    constantValues.emailAddress != null
        ? emailController.text = constantValues.emailAddress!
        : '';
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Background(
                    height: size.height,
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
    final fontStyle1 = GoogleFonts.poppins(textStyle: TextStyle());
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.1),
          Image.asset(
            "assets/icons/logo.png",
            height: size.height * 0.15,
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
          SizedBox(height: size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                OverflowBar(
                  spacing: 3,
                  children: [
                    Checkbox(
                      value: constantValues.rememberPassword,
                      onChanged: (value) {
                        setState(() {
                          constantValues.rememberPassword = value;
                        });
                        value == true
                            ? saveCredentials(emailController.text.trim(),
                                passwordController.text.trim())
                            : null;
                      },
                    ),
                    Text("Remember me", style: fontStyle1)
                  ],
                ),
                GestureDetector(
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: constantValues.primaryColor),
                  ),
                  onTap: () {
                    context.goNamed("forgot-password");
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.07),
          ButtonA(
              width: size.width * 0.8,
              text1: "Sign In",
              text2: "Authenticating",
              isLoading: false,
              authenticate: () async {
                await _signin();
              }),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1, vertical: size.height * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Are you a newbie?", style: fontStyle1),
                SizedBox(width: 5),
                GestureDetector(
                  child: Text(
                    "Sign up",
                    style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(color: constantValues.primaryColor)),
                  ),
                  onTap: () {
                    context.goNamed("signup");
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _signin() async {
    final form = _formKey.currentState!;
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();
    String token = "";
    // final connectivityResult = await Connectivity().checkConnectivity();
    if (form.validate()) {
      // if (connectivityResult != ConnectivityResult.none) {
      try {
        var response = await dio.post("$backendUrl/signin",
            data: {
              "email": email,
              "password": password,
            },
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.data["success"] == "true") {
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
              constantValues.publicKey = response.data["pk"];
              constantValues.userData = response.data["data"];
            });
            context.goNamed("home");
          }
        } else if (response.data["success"] == "suspended") {
          return ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.data["message"])));
        } else {
          return ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.data["message"])));
        }
      } on DioError catch (error) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.response!.data["message"])));
      }
      // } else {
      //   return Fluttertoast.showToast(
      //     msg: "No internet connection!",
      //     toastLength: Toast.LENGTH_LONG,
      //     webPosition: "center",
      //   );
      // }
    }
  }
}
