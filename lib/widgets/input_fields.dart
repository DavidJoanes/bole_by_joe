// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/controller.dart';
import 'input_fields_container.dart';

final constantValues = Get.find<Constants>();

class InputFieldEmailA extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String title;
  final IconData icon;
  InputFieldEmailA({
    Key? key,
    required this.controller,
    required this.width,
    required this.title,
    this.icon = Icons.mail,
  }) : super(key: key);

  @override
  State<InputFieldEmailA> createState() => _InputFieldEmailAState();
}

class _InputFieldEmailAState extends State<InputFieldEmailA> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        validator: (value) => value != null && !EmailValidator.validate(value)
            ? 'Enter a valid email!'
            : null,
        // cursorColor: constantValues.primaryColor,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: constantValues.isDarkTheme
                    ? constantValues.whiteColor
                    : constantValues.blackColor)),
        decoration: InputDecoration(
          suffixIcon: Icon(widget.icon),
          labelText: widget.title,
          labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: constantValues.isDarkTheme
                      ? constantValues.whiteColor
                      : constantValues.blackColor)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class InputFieldEmailB extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String title;
  InputFieldEmailB({
    Key? key,
    required this.controller,
    required this.width,
    required this.title,
  }) : super(key: key);

  @override
  State<InputFieldEmailB> createState() => _InputFieldEmailBState();
}

class _InputFieldEmailBState extends State<InputFieldEmailB> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        validator: (value) => value != null && !EmailValidator.validate(value)
            ? 'Enter a valid email!'
            : null,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: constantValues.isDarkTheme
                    ? constantValues.whiteColor
                    : constantValues.blackColor)),
        decoration: InputDecoration(
          labelText: widget.title,
          labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: constantValues.isDarkTheme
                      ? constantValues.whiteColor
                      : constantValues.blackColor)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class InputFieldA extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String title;
  final bool enabled;
  final Widget hintIcon;
  InputFieldA({
    Key? key,
    required this.controller,
    required this.width,
    required this.title,
    required this.enabled,
    required this.hintIcon,
  }) : super(key: key);

  @override
  State<InputFieldA> createState() => _InputFieldAState();
}

class _InputFieldAState extends State<InputFieldA> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer2(
      width: widget.width,
      child: TextFormField(
        textInputAction: TextInputAction.go,
        controller: widget.controller,
        keyboardType: TextInputType.text,
        autofillHints: [AutofillHints.name],
        enabled: widget.enabled,
        validator: (value) => value == '' ? "required!" : null,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(color: constantValues.blackColor)),
        decoration: InputDecoration(
          suffixIcon: widget.hintIcon,
          labelText: widget.title,
          labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(color: constantValues.blackColor)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class InputFieldA2 extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String title;
  final bool enabled;
  final Widget hintIcon;
  InputFieldA2({
    Key? key,
    required this.controller,
    required this.width,
    required this.title,
    required this.enabled,
    required this.hintIcon,
  }) : super(key: key);

  @override
  State<InputFieldA2> createState() => _InputFieldA2State();
}

class _InputFieldA2State extends State<InputFieldA2> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextFormField(
        textInputAction: TextInputAction.go,
        controller: widget.controller,
        keyboardType: TextInputType.text,
        autofillHints: [AutofillHints.name],
        enabled: widget.enabled,
        validator: (value) => value == '' ? "required!" : null,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: constantValues.isDarkTheme
                    ? constantValues.whiteColor
                    : constantValues.blackColor)),
        decoration: InputDecoration(
          suffixIcon: widget.hintIcon,
          labelText: widget.title,
          labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: constantValues.isDarkTheme
                      ? constantValues.whiteColor
                      : constantValues.blackColor)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class InputFieldB extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String title;
  final bool enabled;
  InputFieldB({
    Key? key,
    required this.controller,
    required this.width,
    required this.title,
    required this.enabled,
  }) : super(key: key);

  @override
  State<InputFieldB> createState() => _InputFieldBState();
}

class _InputFieldBState extends State<InputFieldB> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextFormField(
        textInputAction: TextInputAction.go,
        controller: widget.controller,
        maxLines: 5,
        maxLength: 250,
        keyboardType: TextInputType.text,
        autofillHints: [AutofillHints.name],
        enabled: widget.enabled,
        validator: (value) => value == '' ? "required!" : null,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: constantValues.isDarkTheme
                    ? constantValues.whiteColor
                    : constantValues.blackColor)),
        decoration: InputDecoration(
          labelText: widget.title,
          labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: constantValues.isDarkTheme
                      ? constantValues.whiteColor
                      : constantValues.blackColor)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class InputFieldC extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String title;
  final bool enabled;
  final Widget hintIcon;
  InputFieldC({
    Key? key,
    required this.controller,
    required this.width,
    required this.title,
    required this.enabled,
    required this.hintIcon,
  }) : super(key: key);

  @override
  State<InputFieldC> createState() => _InputFieldCState();
}

class _InputFieldCState extends State<InputFieldC> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextFormField(
        textInputAction: TextInputAction.go,
        controller: widget.controller,
        maxLines: 10,
        keyboardType: TextInputType.text,
        enabled: widget.enabled,
        validator: (value) => value == '' ? "required!" : null,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: constantValues.isDarkTheme
                    ? constantValues.whiteColor
                    : constantValues.blackColor)),
        decoration: InputDecoration(
          labelText: widget.title,
          labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: constantValues.isDarkTheme
                      ? constantValues.whiteColor
                      : constantValues.blackColor)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class InputFieldPhone extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String title;
  final bool enabled;
  final Widget hintIcon;
  InputFieldPhone({
    Key? key,
    required this.controller,
    required this.width,
    required this.title,
    required this.enabled,
    required this.hintIcon,
  }) : super(key: key);

  @override
  State<InputFieldPhone> createState() => _InputFieldPhoneState();
}

class _InputFieldPhoneState extends State<InputFieldPhone> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextFormField(
        textInputAction: TextInputAction.go,
        controller: widget.controller,
        keyboardType: TextInputType.phone,
        maxLength: 11,
        autofillHints: [AutofillHints.telephoneNumber],
        enabled: widget.enabled,
        validator: (value) => value != ''
            ? !value!.isNum
                ? "Invalid phone number!"
                : value.length != 11
                    ? "Incomplete phone number!"
                    : null
            : "required!",
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: constantValues.isDarkTheme
                    ? constantValues.whiteColor
                    : constantValues.blackColor)),
        decoration: InputDecoration(
          suffixIcon: widget.hintIcon,
          labelText: widget.title,
          labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: constantValues.isDarkTheme
                      ? constantValues.whiteColor
                      : constantValues.blackColor)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
