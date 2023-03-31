// ignore_for_file: prefer_const_constructors

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../screens/admin/home/daily_income.dart';
import '../../../widgets/app_bar.dart';
import '../../../controllers/controller.dart';
import '../../../controllers/theme_modifier.dart';
import '../../../widgets/bar_chart_model.dart' as chartmodels;
import '../../../widgets/navigation_drawer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final constantValues = Get.find<Constants>();
  Dio dio = Dio();

  String? currentYear;
  var years = {
    "2023",
  };
  DropdownMenuItem<String> buildYears(String yr) => DropdownMenuItem(
      value: yr,
      child: Text(
        yr,
      ));

  String? currentYear2;
  var years2 = {
    "2023",
  };
  DropdownMenuItem<String> buildYears2(String yr) => DropdownMenuItem(
      value: yr,
      child: Text(
        yr,
      ));

  String? currentMonth;
  var months = {
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
  };
  DropdownMenuItem<String> buildMonths(String mon) => DropdownMenuItem(
      value: mon,
      child: Text(
        mon,
      ));

  currencyIcon(context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return format;
  }

  List<charts.Series<chartmodels.BarChartModel, String>> _createPackagesData() {
    var data = [
      chartmodels.BarChartModel(
          "Discounted Packages",
          chartmodels.discounted.length,
          charts.ColorUtil.fromDartColor(Colors.green)),
      chartmodels.BarChartModel("Normal Packages", chartmodels.normal.length,
          charts.ColorUtil.fromDartColor(Colors.blue)),
    ];
    return [
      charts.Series(
          id: "Packages category",
          data: data,
          domainFn: (chartmodels.BarChartModel series, _) => series.category,
          measureFn: (chartmodels.BarChartModel series, _) => series.total,
          colorFn: (chartmodels.BarChartModel series, _) => series.color),
    ];
  }

  List<charts.Series<chartmodels.BarChartModel, String>> _createAccountsData() {
    var data = [
      chartmodels.BarChartModel("User Accounts", chartmodels.users.length,
          charts.ColorUtil.fromDartColor(Colors.purple)),
      chartmodels.BarChartModel(
          "Dispatcher Accounts",
          chartmodels.dispatchers.length,
          charts.ColorUtil.fromDartColor(Colors.amber)),
    ];
    return [
      charts.Series(
          id: "Accounts category",
          data: data,
          domainFn: (chartmodels.BarChartModel series, _) => series.category,
          measureFn: (chartmodels.BarChartModel series, _) => series.total,
          colorFn: (chartmodels.BarChartModel series, _) => series.color),
    ];
  }

  List<charts.Series<chartmodels.BarChartModel, String>> _createOrdersData() {
    var data = [
      chartmodels.BarChartModel("Paid Orders", chartmodels.paidOrders.length,
          charts.ColorUtil.fromDartColor(Colors.yellow)),
      chartmodels.BarChartModel("PoD Orders", chartmodels.podOrders.length,
          charts.ColorUtil.fromDartColor(Colors.teal)),
    ];
    return [
      charts.Series(
          id: "Orders category",
          data: data,
          domainFn: (chartmodels.BarChartModel series, _) => series.category,
          measureFn: (chartmodels.BarChartModel series, _) => series.total,
          colorFn: (chartmodels.BarChartModel series, _) => series.color),
    ];
  }

  List<charts.Series<chartmodels.BarChartModel, String>>
      _createOrderStatusData() {
    var data = [
      chartmodels.BarChartModel(
          "Awaiting Rider",
          chartmodels.awaitingRider.length,
          charts.ColorUtil.fromDartColor(Colors.amberAccent)),
      chartmodels.BarChartModel("En-Route", chartmodels.enRoute.length,
          charts.ColorUtil.fromDartColor(Colors.teal)),
      chartmodels.BarChartModel("Delivered", chartmodels.delivered.length,
          charts.ColorUtil.fromDartColor(Colors.greenAccent)),
      chartmodels.BarChartModel("Cancelled", chartmodels.cancelled.length,
          charts.ColorUtil.fromDartColor(Colors.redAccent)),
    ];
    return [
      charts.Series(
          id: "Orders category",
          data: data,
          domainFn: (chartmodels.BarChartModel series, _) => series.category,
          measureFn: (chartmodels.BarChartModel series, _) => series.total,
          colorFn: (chartmodels.BarChartModel series, _) => series.color),
    ];
  }

  List<charts.Series<chartmodels.BarChartModel, String>>
      _createMonthlyIncomeData() {
    var data = [
      chartmodels.BarChartModel(
          "Jan", chartmodels.jan, charts.ColorUtil.fromDartColor(Colors.red)),
      chartmodels.BarChartModel("Feb", chartmodels.feb,
          charts.ColorUtil.fromDartColor(Colors.purple)),
      chartmodels.BarChartModel("Mar", chartmodels.mar,
          charts.ColorUtil.fromDartColor(Colors.lightBlue)),
      chartmodels.BarChartModel("Apr", chartmodels.apr,
          charts.ColorUtil.fromDartColor(Colors.deepOrange)),
      chartmodels.BarChartModel(
          "May", chartmodels.may, charts.ColorUtil.fromDartColor(Colors.green)),
      chartmodels.BarChartModel("Jun", chartmodels.jun,
          charts.ColorUtil.fromDartColor(Colors.purpleAccent)),
      chartmodels.BarChartModel("Jul", chartmodels.jul,
          charts.ColorUtil.fromDartColor(Colors.lightGreen)),
      chartmodels.BarChartModel("Aug", chartmodels.aug,
          charts.ColorUtil.fromDartColor(Colors.deepPurple)),
      chartmodels.BarChartModel(
          "Sep", chartmodels.sep, charts.ColorUtil.fromDartColor(Colors.pink)),
      chartmodels.BarChartModel("Oct", chartmodels.oct,
          charts.ColorUtil.fromDartColor(Colors.yellow)),
      chartmodels.BarChartModel("Nov", chartmodels.nov,
          charts.ColorUtil.fromDartColor(Colors.indigoAccent)),
      chartmodels.BarChartModel(
          "Dec", chartmodels.dec, charts.ColorUtil.fromDartColor(Colors.teal)),
    ];
    return [
      charts.Series(
          id: "Monthly income",
          data: data,
          domainFn: (chartmodels.BarChartModel series, _) => series.category,
          measureFn: (chartmodels.BarChartModel series, _) => series.total,
          colorFn: (chartmodels.BarChartModel series, _) => series.color),
    ];
  }

  List<charts.Series<chartmodels.BarChartModel, String>>
      _createMonthlyPackagesSoldData() {
    var data = [
      chartmodels.BarChartModel("Valentine", chartmodels.pack1.length,
          charts.ColorUtil.fromDartColor(Colors.tealAccent)),
      chartmodels.BarChartModel("Newbie", chartmodels.pack2.length,
          charts.ColorUtil.fromDartColor(Colors.indigo)),
      chartmodels.BarChartModel("Quickie", chartmodels.pack3.length,
          charts.ColorUtil.fromDartColor(Colors.limeAccent)),
      chartmodels.BarChartModel("Basic", chartmodels.pack4.length,
          charts.ColorUtil.fromDartColor(Colors.brown)),
      chartmodels.BarChartModel("Foodie", chartmodels.pack5.length,
          charts.ColorUtil.fromDartColor(Colors.orangeAccent)),
      chartmodels.BarChartModel("Big boy", chartmodels.pack6.length,
          charts.ColorUtil.fromDartColor(Colors.purple)),
      chartmodels.BarChartModel("Family", chartmodels.pack7.length,
          charts.ColorUtil.fromDartColor(Colors.greenAccent)),
    ];
    return [
      charts.Series(
          id: "Packages sold (Monthly)",
          data: data,
          domainFn: (chartmodels.BarChartModel series, _) => series.category,
          measureFn: (chartmodels.BarChartModel series, _) => series.total,
          colorFn: (chartmodels.BarChartModel series, _) => series.color),
    ];
  }

  List<charts.Series<chartmodels.BarChartModel, String>> _createRefundsData() {
    var data = [
      chartmodels.BarChartModel(
          "Approved",
          chartmodels.approvedRefundApplication.length,
          charts.ColorUtil.fromDartColor(Colors.greenAccent)),
      chartmodels.BarChartModel(
          "Pending",
          chartmodels.pendingRefundApplication.length,
          charts.ColorUtil.fromDartColor(Colors.amberAccent)),
      chartmodels.BarChartModel(
          "Denied",
          chartmodels.deniedRefundApplication.length,
          charts.ColorUtil.fromDartColor(Colors.redAccent)),
    ];
    return [
      charts.Series(
          id: "Refunds category",
          data: data,
          domainFn: (chartmodels.BarChartModel series, _) => series.category,
          measureFn: (chartmodels.BarChartModel series, _) => series.total,
          colorFn: (chartmodels.BarChartModel series, _) => series.color),
    ];
  }

  List<charts.Series<chartmodels.BarChartModel, String>> _createDataLogsData() {
    var data = [
      chartmodels.BarChartModel("Admin Logs", chartmodels.adminLogs.length,
          charts.ColorUtil.fromDartColor(Colors.cyan)),
      chartmodels.BarChartModel("User Logs", chartmodels.userLogs.length,
          charts.ColorUtil.fromDartColor(Colors.grey)),
    ];
    return [
      charts.Series(
          id: "Data Logs category",
          data: data,
          domainFn: (chartmodels.BarChartModel series, _) => series.category,
          measureFn: (chartmodels.BarChartModel series, _) => series.total,
          colorFn: (chartmodels.BarChartModel series, _) => series.color),
    ];
  }

  @override
  void initState() {
    setState(() {
      currentYear = "2023";
      currentYear2 = "2023";
    });
    _fetchRequiredData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
        appBar: primaryAppBar(context, "Dashboard"),
        drawer: CustomDrawer(),
        floatingActionButton: CircleAvatar(
          radius: 20,
          backgroundColor: constantValues.blackColor,
          child: IconButton(
            icon: Icon(
              constantValues.isDarkTheme
                  ? Icons.lightbulb_circle
                  : Icons.lightbulb_circle_outlined,
            ),
            onPressed: () {
              setState(() {
                constantValues.isDarkTheme = !constantValues.isDarkTheme;
              });
              themeChanger.setTheme(constantValues.isDarkTheme
                  ? ThemeData.dark()
                  : ThemeData(
                      primarySwatch: MaterialColor(
                          0xFFFFA726, constantValues.defaultColor),
                      brightness: Brightness.light));
            },
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: mixedScreen(context))));
  }

  Widget mixedScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fontStyle1 = GoogleFonts.poppins(textStyle: TextStyle());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Column(
            children: [
              ListTile(title: Text("PACKAGES DISTRIBUTION", style: fontStyle1)),
              SizedBox(
                height: size.height * 0.4,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child: charts.BarChart(_createPackagesData(),
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (model) async {
                            var cat = model.selectedSeries[0]
                                .domainFn(model.selectedDatum[0].index);

                            final qty = model.selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index)
                                .toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$cat: $qty")));
                          })
                        ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Column(
            children: [
              ListTile(title: Text("ACCOUNTS DISTRIBUTION", style: fontStyle1)),
              SizedBox(
                height: size.height * 0.4,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child: charts.BarChart(_createAccountsData(),
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (model) async {
                            var cat = model.selectedSeries[0]
                                .domainFn(model.selectedDatum[0].index);

                            final qty = model.selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index)
                                .toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$cat: $qty")));
                          })
                        ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Column(
            children: [
              ListTile(title: Text("ORDERS DISTRIBUTION", style: fontStyle1)),
              SizedBox(
                height: size.height * 0.4,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child:
                        charts.BarChart(_createOrdersData(), selectionModels: [
                      charts.SelectionModelConfig(
                          changedListener: (model) async {
                        var cat = model.selectedSeries[0]
                            .domainFn(model.selectedDatum[0].index);

                        final qty = model.selectedSeries[0]
                            .measureFn(model.selectedDatum[0].index)
                            .toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$cat: $qty")));
                      })
                    ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Column(
            children: [
              ListTile(title: Text("STATUS OF ORDERS", style: fontStyle1)),
              SizedBox(
                height: size.height * 0.4,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child: charts.BarChart(_createOrderStatusData(),
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (model) async {
                            var cat = model.selectedSeries[0]
                                .domainFn(model.selectedDatum[0].index);

                            final qty = model.selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index)
                                .toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$cat: $qty")));
                          })
                        ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Column(
            children: [
              ListTile(
                  title: Text("MONTHLY INCOME ANALYSIS", style: fontStyle1)),
              Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text('Year'),
                  subtitle: Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            // hint: Text(""),
                            isExpanded: true,
                            value: currentYear,
                            items: years.map(buildYears).toList(),
                            onChanged: (value) async {
                              setState(() {
                                currentYear = value!;
                                chartmodels.fetchMonthlyIncome(currentYear);
                              });
                            }),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.4,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.01),
                    child: charts.BarChart(_createMonthlyIncomeData(),
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (model) async {
                            var month = model.selectedSeries[0]
                                .domainFn(model.selectedDatum[0].index);

                            final total = model.selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index)
                                .toString();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Total income in $month, $currentYear: ${currencyIcon(context).currencySymbol}$total")));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DailyIncome(
                                      month: month.toLowerCase(),
                                      year: currentYear!,
                                    )));
                          })
                        ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Column(
            children: [
              ListTile(title: Text("PACKAGES SOLD", style: fontStyle1)),
              OverflowBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Year'),
                      subtitle: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                isExpanded: true,
                                value: currentYear2,
                                items: years2.map(buildYears2).toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    currentYear2 = value!;
                                    chartmodels.fetchMonthlyPackagesSold(
                                        currentYear2, currentMonth);
                                  });
                                }),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Month'),
                      subtitle: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                isExpanded: true,
                                value: currentMonth,
                                items: months.map(buildMonths).toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    currentMonth = value!;
                                    chartmodels.fetchMonthlyPackagesSold(
                                        currentYear2, currentMonth);
                                  });
                                }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.4,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.01),
                    child: charts.BarChart(_createMonthlyPackagesSoldData(),
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (model) async {
                            var package = model.selectedSeries[0]
                                .domainFn(model.selectedDatum[0].index);

                            final total = model.selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index)
                                .toString();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Total $package package sold: $total")));
                          })
                        ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Column(
            children: [
              ListTile(
                  title: Text("REFUND APPLICATIONS DISTRIBUTION",
                      style: fontStyle1)),
              SizedBox(
                height: size.height * 0.4,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child:
                        charts.BarChart(_createRefundsData(), selectionModels: [
                      charts.SelectionModelConfig(
                          changedListener: (model) async {
                        var cat = model.selectedSeries[0]
                            .domainFn(model.selectedDatum[0].index);

                        final qty = model.selectedSeries[0]
                            .measureFn(model.selectedDatum[0].index)
                            .toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$cat: $qty")));
                      })
                    ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Column(
            children: [
              ListTile(
                  title: Text("DATA LOGS DISTRIBUTION", style: fontStyle1)),
              SizedBox(
                height: size.height * 0.4,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child: charts.BarChart(_createDataLogsData(),
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (model) async {
                            var cat = model.selectedSeries[0]
                                .domainFn(model.selectedDatum[0].index);

                            final qty = model.selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index)
                                .toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$cat: $qty")));
                          })
                        ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
        ],
      ),
    );
  }

  _fetchRequiredData() async {
    try {
      var packages = await dio.post("$backendUrl2/all-packages");
      var accounts = await dio.post("$backendUrl2/all-accounts");
      var orders = await dio.post("$backendUrl2/all-orders");
      var refunds = await dio.post("$backendUrl2/all-refunds");
      var logs = await dio.post("$backendUrl2/all-data-logs");
      if (packages.data["success"]) {
        setState(() {
          constantValues.allPackages = packages.data["data"];
        });
        chartmodels.fetchPackageCategories();
      }
      if (accounts.data["success"]) {
        setState(() {
          constantValues.allAccounts = accounts.data["data"];
        });
        chartmodels.fetchAccountCategories();
      }
      if (orders.data["success"]) {
        setState(() {
          constantValues.allOrders = orders.data["data"];
          currentMonth =
              constantValues.allOrders[0]["dateplaced"].split("-")[1];
        });
        chartmodels.fetchOrderCategories();
        chartmodels.fetchOrderStatus();
        chartmodels.fetchMonthlyIncome(currentYear);
        chartmodels.fetchMonthlyPackagesSold(currentYear2, currentMonth);
      }
      if (refunds.data["success"]) {
        setState(() {
          constantValues.allRefunds = refunds.data["data"];
        });
        chartmodels.fetchRefundCategories();
      }
      if (logs.data["success"]) {
        setState(() {
          constantValues.allDataLogs = logs.data["data"];
        });
        chartmodels.fetchDataLogCategories();
      }
    } on DioError catch (error) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.response!.data["message"])));
    }
  }
}
