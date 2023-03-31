// ignore_for_file: prefer_const_constructors, avoid_web_libraries_in_flutter, use_build_context_synchronously, unused_field, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:html' as html;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/controller.dart';
import '../../../widgets/input_fields.dart';
import '../../resolution.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final constantValues = Get.find<Constants>();
  final _formKey = GlobalKey<FormState>();
  Dio dio = Dio();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  late Uint8List? _bytesData;
  late List<int>? _selectedFile;
  late var _file;
  bool loading = false;

  @override
  void initState() {
    setState(() {
      firstNameController.text = constantValues.userData["firstname"];
      lastNameController.text = constantValues.userData["lastname"];
      phoneNumberController.text =
          "0${constantValues.userData["phonenumber"].substring(4)}";
    });
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryAppBar2(
          context,
          "Edit Profile",
          IconButton(
            tooltip: "Save",
            icon: Icon(Icons.done_outlined),
            onPressed: () async {
              _save();
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Resolution(
                  desktopScreen: desktopScreen(context),
                  mixedScreen: mixedScreen(context))),
        ));
  }

  Widget desktopScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            ProfilePicture2(
                image: constantValues.userData["profileimage"]["url"] != ""
                    ? constantValues.userData["profileimage"]["url"]
                    : "assets/icons/user.png",
                radius: size.width * 0.08,
                isDesktop: true,
                loading: loading,
                onClicked: () async {
                  await _chooseImage();
                }),
            SizedBox(height: size.height * 0.1),
            InputFieldA2(
                controller: firstNameController,
                width: size.width * 0.8,
                hintIcon: Text(''),
                title: "First name",
                enabled: true),
            SizedBox(height: size.height * 0.04),
            InputFieldA2(
                controller: lastNameController,
                width: size.width * 0.8,
                hintIcon: Text(''),
                title: "Last name",
                enabled: true),
            SizedBox(height: size.height * 0.04),
            InputFieldPhone(
              controller: phoneNumberController,
              width: size.width * 0.8,
              title: "Phone number",
              enabled: true,
              hintIcon: Padding(
                padding: EdgeInsets.all(2),
                child: Text("+234", style: fontStyle1),
              ),
            ),
            SizedBox(height: size.height * 0.1),
          ],
        ),
      ),
    );
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          ProfilePicture2(
              image: constantValues.userData["profileimage"]["url"] != ""
                  ? constantValues.userData["profileimage"]["url"]
                  : "assets/icons/user.png",
              radius: size.width * 0.22,
              isDesktop: false,
              loading: loading,
              onClicked: () async {
                await _chooseImage();
              }),
          SizedBox(height: size.height * 0.1),
          InputFieldA2(
              controller: firstNameController,
              width: size.width * 0.8,
              hintIcon: Text(''),
              title: "First name",
              enabled: true),
          SizedBox(height: size.height * 0.04),
          InputFieldA2(
              controller: lastNameController,
              width: size.width * 0.8,
              hintIcon: Text(''),
              title: "Last name",
              enabled: true),
          SizedBox(height: size.height * 0.04),
          InputFieldPhone(
            controller: phoneNumberController,
            width: size.width * 0.8,
            title: "Phone number",
            enabled: true,
            hintIcon: Padding(
              padding: EdgeInsets.all(2),
              child: Text("+234", style: fontStyle1),
            ),
          ),
          SizedBox(height: size.height * 0.1),
        ],
      ),
    );
  }

  _chooseImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      setState(() {
        _bytesData = null;
        _selectedFile = null;
      });

      reader.onLoad.listen((event) async {
        setState(() {
          _bytesData =
              Base64Decoder().convert(reader.result.toString().split(",").last);
          _selectedFile = _bytesData;
          _file = file.name;
          loading = true;
        });
        await uploadProfileImage(_bytesData!, _file);
      });
      reader.readAsDataUrl(file);
    });
  }

  uploadProfileImage(List<int> file, String fileName) async {
    final email = constantValues.userData["email"];
    final formData = FormData.fromMap({
      "email": email,
      "category": "profileimage",
      "image": MultipartFile.fromBytes(file,
          filename: fileName,
          contentType: MediaType('image', fileName.split(".")[1])),
    });
    try {
      var response =
          await dio.post("$backendUrl/upload-profile-image", data: formData);
      if (response.data["success"]) {
        setState(() {
          loading = false;
          constantValues.userData.clear();
          constantValues.userData = response.data["data"];
        });
        Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center",
        );
      } else {
        return ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
      // ignore: unused_catch_clause
    } on DioError catch (error) {
      setState(() {
        loading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Maximum profile image size allowed: 5mb")));
    }
  }

  _save() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      final email = constantValues.userData["email"];
      final firstname = firstNameController.text.trim().toLowerCase();
      final lastname = lastNameController.text.trim().toLowerCase();
      final phone = "+234${phoneNumberController.text.substring(1)}";
      try {
        var response = await dio.post("$backendUrl/update-profile", data: {
          "email": email,
          "firstname": firstname,
          "lastname": lastname,
          "phone": phone,
        });
        if (response.data["success"]) {
          setState(() {
            constantValues.userData = response.data["data"];
          });
          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_LONG,
            webPosition: "center",
          );
          Navigator.of(context).pop();
          context.goNamed("home");
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
