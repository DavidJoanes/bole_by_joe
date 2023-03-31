// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/controller.dart';

final constantValues = Get.find<Constants>();

class ButtonA extends StatefulWidget {
  ButtonA(
      {Key? key,
      required this.width,
      required this.text1,
      required this.text2,
      required this.isLoading,
      required this.authenticate})
      : super(key: key);
  final double width;
  final String text1;
  final String text2;
  late bool isLoading;
  final Function authenticate;

  @override
  State<ButtonA> createState() => _ButtonAState();
}

class _ButtonAState extends State<ButtonA> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: newElevatedButton(context),
      ),
    );
  }

  Widget newElevatedButton(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(constantValues.primaryColor),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
        ),
        onPressed: () async {
          if (widget.isLoading) return;
          setState(() => widget.isLoading = true);
          await widget.authenticate();
          // await Future.delayed(Duration(seconds: 3));
          setState(() => widget.isLoading = false);
        },
        // onPressed: null,
        child: widget.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    widget.text2,
                    style: GoogleFonts.poppins(textStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            : Text(
                widget.text1,
                style: GoogleFonts.poppins(textStyle: TextStyle(
                  color: constantValues.whiteColor,
                  fontWeight: FontWeight.bold,
                )),
              ));
  }
}

class ButtonB extends StatefulWidget {
  ButtonB(
      {Key? key,
      required this.width,
      required this.buttoncolor,
      required this.textcolor,
      required this.text,
      required this.onpress})
      : super(key: key);
  final double width;
  final Color buttoncolor;
  final Color textcolor;
  final String text;
  final Function onpress;

  @override
  State<ButtonB> createState() => _ButtonBState();
}

class _ButtonBState extends State<ButtonB> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: newElevatedButton(context),
      ),
    );
  }

  Widget newElevatedButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(widget.buttoncolor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 4, vertical: 2)),
      ),
      child: Text(
        widget.text,
        style: GoogleFonts.poppins(textStyle: TextStyle(color: widget.textcolor, fontSize: 12)),
      ),
      onPressed: () async {
        await widget.onpress();
      },
    );
  }
}

class ButtonC extends StatefulWidget {
  ButtonC(
      {Key? key,
      required this.width,
      required this.text,
      required this.onpress})
      : super(key: key);
  final double width;
  final String text;
  final Function onpress;

  @override
  State<ButtonC> createState() => _ButtonCState();
}

class _ButtonCState extends State<ButtonC> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: newElevatedButton(context),
    );
  }

  Widget newElevatedButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            side: BorderSide(width: 2, color: constantValues.primaryColor))),
        backgroundColor: MaterialStateProperty.all(constantValues.whiteColor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 4, vertical: 2)),
      ),
      child: Text(
        widget.text,
        style: GoogleFonts.poppins(textStyle: TextStyle(color: constantValues.primaryColor)),
      ),
      onPressed: () async {
        await widget.onpress();
      },
    );
  }
}

class ButtonC2 extends StatefulWidget {
  ButtonC2(
      {Key? key,
      required this.width,
      required this.text,
      required this.onpress})
      : super(key: key);
  final double width;
  final String text;
  final Function onpress;

  @override
  State<ButtonC2> createState() => _ButtonC2State();
}

class _ButtonC2State extends State<ButtonC2> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: newElevatedButton(context),
    );
  }

  Widget newElevatedButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        )),
        backgroundColor: MaterialStateProperty.all(constantValues.primaryColor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 4, vertical: 2)),
      ),
      child: Text(
        widget.text,
        style: GoogleFonts.poppins(textStyle: TextStyle(color: constantValues.whiteColor)),
      ),
      onPressed: () async {
        await widget.onpress();
      },
    );
  }
}

class ButtonC2b extends StatefulWidget {
  ButtonC2b(
      {Key? key,
      required this.width,
      required this.text,
      required this.onpress})
      : super(key: key);
  final double width;
  final String text;
  final Function onpress;

  @override
  State<ButtonC2b> createState() => _ButtonC2bState();
}

class _ButtonC2bState extends State<ButtonC2b> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: newElevatedButton(context),
    );
  }

  Widget newElevatedButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        )),
        backgroundColor: MaterialStateProperty.all(constantValues.primaryColor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 4, vertical: 16)),
      ),
      child: Text(
        widget.text,
        style: GoogleFonts.poppins(textStyle: TextStyle(color: constantValues.whiteColor)),
      ),
      onPressed: () async {
        await widget.onpress();
      },
    );
  }
}

