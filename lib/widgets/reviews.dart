// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/controller.dart';

class Reviews extends StatefulWidget {
  Reviews({super.key, required this.reviews});
  var reviews;

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final constantValues = Get.find<Constants>();
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(textStyle: TextStyle());
    final fontStyle1b = GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w400));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          child: ListTile(
              leading: Icon(Icons.reviews_outlined),
              title: Text(
                "Reviews",
                style: fontStyle1,
              ),
              trailing: IconButton(
                  icon: Icon(isOpen
                      ? Icons.arrow_drop_down_outlined
                      : Icons.arrow_right_outlined),
                  onPressed: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  })),
        ),
        isOpen
            ? SizedBox(
                child: SizedBox(
                  height: size.height * 0.25,
                  width: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.reviews.length,
                      itemBuilder: (context, index) {
                        return Container(
                            width: size.width * 0.6,
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02,
                                    vertical: size.height * 0.01),
                                child: OverflowBar(
                                  alignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.reviews[index]["review"]}\n- ${widget.reviews[index]["name"]}",
                                      style: fontStyle1b,
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      }),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
