// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/controller.dart';
import 'input_fields_container.dart';

final constantValues = Get.find<Constants>();

class PasswordFieldA extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String title;
  const PasswordFieldA({
    Key? key,
    required this.controller,
    required this.width,
    required this.title,
  }) : super(key: key);

  @override
  State<PasswordFieldA> createState() => _PasswordFieldAState();
}

class _PasswordFieldAState extends State<PasswordFieldA> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextFormField(
        textInputAction: TextInputAction.go,
        obscureText: true,
        controller: widget.controller,
        keyboardType: TextInputType.visiblePassword,
        style: GoogleFonts.poppins(textStyle: TextStyle()),
        validator: (value) => value == '' ? 'Password cannot be blank!' : null,
        decoration: InputDecoration(
          labelText: widget.title,
          labelStyle: GoogleFonts.poppins(textStyle: TextStyle(
              color: constantValues.isDarkTheme
                  ? constantValues.whiteColor
                  : constantValues.blackColor)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class PasswordFieldB extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final double height;
  final String hintText;
  const PasswordFieldB({
    Key? key,
    required this.controller,
    required this.width,
    required this.height,
    required this.hintText,
  }) : super(key: key);

  @override
  State<PasswordFieldB> createState() => _PasswordFieldBState();
}

class _PasswordFieldBState extends State<PasswordFieldB> {
  bool isObscurePassword = true;
  late var isObscurePasswordIcon1 = Icon(Icons.visibility_off_rounded);
  late var isObscurePasswordIcon2 = Icon(Icons.remove_red_eye_rounded);
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: Column(
        children: [
          TextFormField(
            obscureText: isObscurePassword,
            controller: widget.controller,
            keyboardType: TextInputType.visiblePassword,
            style: GoogleFonts.poppins(textStyle: TextStyle()),
            validator: (value) => !status ? "Enter a valid password!" : null,
            decoration: InputDecoration(
              labelText: widget.hintText,
              labelStyle: GoogleFonts.poppins(textStyle: TextStyle(
                  color: constantValues.isDarkTheme
                      ? constantValues.whiteColor
                      : constantValues.blackColor)),
              icon: Icon(
                Icons.lock,
              ),
              suffixIcon: IconButton(
                icon: isObscurePassword
                    ? isObscurePasswordIcon2
                    : isObscurePasswordIcon1,
                onPressed: () {
                  setState(() {
                    isObscurePassword = !isObscurePassword;
                  });
                },
              ),
              border: InputBorder.none,
            ),
          ),
          FlutterPwValidator(
              controller: widget.controller,
              minLength: 8,
              numericCharCount: 1,
              specialCharCount: 1,
              width: widget.width,
              height: widget.height,
              onSuccess: () => success(widget.controller),
              onFail: () => failure(widget.controller)),
        ],
      ),
    );
  }

  success(value) {
    setState(() {
      status = true;
    });
  }

  failure(value) {
    value == null ? 'Password must be alphanumeric!' : null;
    setState(() {
      status = false;
    });
  }
}
