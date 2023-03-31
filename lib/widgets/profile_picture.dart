// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/controller.dart';

final constantValues = Get.find<Constants>();

class ProfilePicture extends StatelessWidget {
  ProfilePicture({
    Key? key,
    required this.image,
    required this.radius,
    required this.onClicked,
  }) : super(key: key);
  final String image;
  final double radius;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return buildImage();
  }

  Widget buildImage() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: !image.startsWith('a')
          ? NetworkImage(image)
          : AssetImage(image) as ImageProvider,
      child: InkWell(
        onTap: onClicked,
      ),
    );
  }
}

class AdminProfilePicture extends StatelessWidget {
  AdminProfilePicture({
    Key? key,
    required this.radius,
    required this.onClicked,
  }) : super(key: key);
  final double radius;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return buildImage();
  }

  Widget buildImage() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: AssetImage('assets/icons/admin.png'),
      child: InkWell(
        onTap: onClicked,
      ),
    );
  }
}

class ProfilePicture2 extends StatelessWidget {
  final String image;
  final double radius;
  bool isDesktop;
  bool loading;
  final VoidCallback onClicked;

  ProfilePicture2({
    Key? key,
    required this.image,
    required this.radius,
    required this.isDesktop,
    required this.loading,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: loading
            ? Center(
                child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(),
              ))
            : Stack(
                children: [
                  buildImage(),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: buildEditIcon(context, constantValues.primaryColor),
                  ),
                ],
              ));
  }

  Widget buildImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: constantValues.whiteColor,
          backgroundImage: !image.startsWith('a')
              ? NetworkImage(image)
              : AssetImage(image) as ImageProvider,
          child: InkWell(
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget buildEditIcon(BuildContext context, Color color) => CircleAvatar(
        backgroundColor: constantValues.whiteColor,
        radius: isDesktop ? 25 : 20,
        child: CircleAvatar(
          backgroundColor: color,
          radius: isDesktop ? 23 : 18,
          child: IconButton(
            icon: Icon(
              Icons.add_a_photo_rounded,
              size: isDesktop ? 25 : 20,
              color: constantValues.whiteColor,
            ),
            onPressed: () {
              onClicked();
            },
          ),
        ),
      );
}
