// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../controllers/controller.dart';
import '../../../widgets/app_bar.dart';

class DailyIncome extends StatefulWidget {
  DailyIncome({super.key, required this.month, required this.year});
  final String month;
  final String year;

  @override
  State<DailyIncome> createState() => _DailyIncomeState();
}

class _DailyIncomeState extends State<DailyIncome> {
  final constantValues = Get.find<Constants>();
  late DateTime dateOfIncome = DateTime.now();
  var mainDate = "";
  var startDate;
  var endDate;
  num total = 0;

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  String _convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    mainDate = formatted;
    return date;
  }

  _fetchDailyIncome(date, month, year) {
    var monthData = [];
    total = 0;
    var monthList = [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12'
    ];
    if (month == 'jan') {
      month = monthList[0];
    } else if (month == 'feb') {
      month = monthList[1];
    } else if (month == 'mar') {
      month = monthList[2];
    } else if (month == 'apr') {
      month = monthList[3];
    } else if (month == 'may') {
      month = monthList[4];
    } else if (month == 'jun') {
      month = monthList[5];
    } else if (month == 'jul') {
      month = monthList[6];
    } else if (month == 'aug') {
      month = monthList[7];
    } else if (month == 'sep') {
      month = monthList[8];
    } else if (month == 'oct') {
      month = monthList[9];
    } else if (month == 'nov') {
      month = monthList[10];
    } else if (month == 'dec') {
      month = monthList[11];
    }
    for (var data in constantValues.allOrders) {
      if (year == data["dateplaced"].split('-')[0]) {
        if (month == data["dateplaced"].split('-')[1]) {
          monthData.add(data);
        }
      }
    }
    setState(() {
      startDate = DateTime(int.parse(year), int.parse(month), 01);
      endDate = DateTime(int.parse(year), int.parse(month) + 1);
    });
    for (var data in monthData) {
      if (date == data["dateplaced"]) {
        total += data["total"];
      }
    }
  }

  @override
  void initState() {
    _convertDateTimeDisplay(dateOfIncome.toString());
    _fetchDailyIncome(mainDate, widget.month, widget.year);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryAppBar(context, "Daily Income", () {
          Navigator.of(context).pop();
        }),
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: mixedScreen(context))));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 =
        GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600));
    final fontStyle1b = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontSize: size.width * 0.1,
            color: constantValues.whiteColor,
            fontWeight: FontWeight.bold));
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: ListTile(
            title: Text("Search by date: $mainDate", style: fontStyle1),
            trailing: IconButton(
              tooltip: "Pick a date",
              icon: Icon(Icons.calendar_month_outlined,
                  color: constantValues.primaryColor),
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: startDate!,
                        lastDate: endDate!)
                    .then((date) => setState(() {
                          dateOfIncome = date!;
                          _convertDateTimeDisplay(dateOfIncome.toString());
                          _fetchDailyIncome(
                              mainDate, widget.month, widget.year);
                        }));
              },
            ),
          ),
        ),
        SizedBox(height: size.height * 0.2),
        Card(
          elevation: 20,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    constantValues.primaryColor,
                    constantValues.pinkColor,
                  ],
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.1, horizontal: size.width * 0.2),
              child: Text("${currencyIcon(context).currencySymbol}$total",
                  style: fontStyle1b),
            ),
          ),
        ),
      ],
    );
  }
}
