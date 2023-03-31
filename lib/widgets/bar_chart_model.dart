import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';

import '../controllers/controller.dart';

final constantValues = Get.find<Constants>();

class BarChartModel {
  final String category;
  final int total;
  final charts.Color color;

  BarChartModel(this.category, this.total, this.color);
}

var discounted = [];
var normal = [];
var users = [];
var dispatchers = [];
var paidOrders = [];
var podOrders = [];
var awaitingRider = [];
var enRoute = [];
var delivered = [];
var cancelled = [];
var jan = 0;
var feb = 0;
var mar = 0;
var apr = 0;
var may = 0;
var jun = 0;
var jul = 0;
var aug = 0;
var sep = 0;
var oct = 0;
var nov = 0;
var dec = 0;
var pack1 = [];
var pack2 = [];
var pack3 = [];
var pack4 = [];
var pack5 = [];
var pack6 = [];
var pack7 = [];
var aroundChobaOrAlakahia = [];
var notaroundChobaOrAlakahia = [];
var approvedRefundApplication = [];
var deniedRefundApplication = [];
var pendingRefundApplication = [];
var adminLogs = [];
var userLogs = [];
fetchPackageCategories() {
  discounted.clear();
  normal.clear();
  for (var data in constantValues.allPackages) {
    if (data["discount"] > 0) {
      discounted.add(data);
    } else {
      normal.add(data);
    }
  }
  return;
}

fetchAccountCategories() {
  users.clear();
  dispatchers.clear();
  for (var data in constantValues.allAccounts) {
    if (data["accounttype"] == "user") {
      users.add(data);
    } else {
      dispatchers.add(data);
    }
  }
}

fetchOrderCategories() {
  paidOrders.clear();
  podOrders.clear();
  for (var data in constantValues.allOrders) {
    if (data["paid"]) {
      paidOrders.add(data);
    } else {
      podOrders.add(data);
    }
  }
}

fetchOrderStatus() {
  awaitingRider.clear();
  enRoute.clear();
  delivered.clear();
  cancelled.clear();
  for (var data in constantValues.allOrders) {
    if (data["status"] == "awaiting rider") {
      awaitingRider.add(data);
    } else if (data["status"] == "en-route") {
      enRoute.add(data);
    } else if (data["status"] == "delivered") {
      delivered.add(data);
    } else {
      cancelled.add(data);
    }
  }
}

fetchMonthlyIncome(year) {
  jan = 0;
  feb = 0;
  mar = 0;
  apr = 0;
  may = 0;
  jun = 0;
  jul = 0;
  aug = 0;
  sep = 0;
  oct = 0;
  nov = 0;
  dec = 0;
  num total = 0;
  for (var data in constantValues.allOrders) {
    if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "01") {
      total += data["total"];
      jan = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "02") {
      total += data["total"];
      feb = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "03") {
      total += data["total"];
      mar = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "04") {
      total += data["total"];
      apr = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "05") {
      total += data["total"];
      may = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "06") {
      total += data["total"];
      jun = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "07") {
      total += data["total"];
      jul = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "08") {
      total += data["total"];
      aug = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "09") {
      total += data["total"];
      sep = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "10") {
      total += data["total"];
      oct = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "11") {
      total += data["total"];
      nov = total as int;
    } else if (data["status"] == "delivered" &&
        data["dateplaced"].split("-")[0] == year &&
        data["dateplaced"].split("-")[1] == "12") {
      total += data["total"];
      dec = total as int;
    }
  }
}

fetchMonthlyPackagesSold(year, month) {
  pack1.clear();
  pack2.clear();
  pack3.clear();
  pack4.clear();
  pack5.clear();
  pack6.clear();
  pack7.clear();
  for (var data in constantValues.allOrders) {
    for (var data2 in data["items"]) {
      if (data["status"] == "delivered" &&
          data["dateplaced"].split("-")[0] == year &&
          data["dateplaced"].split("-")[1] == month &&
          data2["packagename"] == "Valentine") {
        pack1.add(data2);
      } else if (data["status"] == "delivered" &&
          data["dateplaced"].split("-")[0] == year &&
          data["dateplaced"].split("-")[1] == month &&
          data2["packagename"] == "Newbie") {
        pack2.add(data2);
      } else if (data["status"] == "delivered" &&
          data["dateplaced"].split("-")[0] == year &&
          data["dateplaced"].split("-")[1] == month &&
          data2["packagename"] == "Quickie") {
        pack3.add(data2);
      } else if (data["status"] == "delivered" &&
          data["dateplaced"].split("-")[0] == year &&
          data["dateplaced"].split("-")[1] == month &&
          data2["packagename"] == "Basic") {
        pack4.add(data2);
      } else if (data["status"] == "delivered" &&
          data["dateplaced"].split("-")[0] == year &&
          data["dateplaced"].split("-")[1] == month &&
          data2["packagename"] == "Foodie") {
        pack5.add(data2);
      } else if (data["status"] == "delivered" &&
          data["dateplaced"].split("-")[0] == year &&
          data["dateplaced"].split("-")[1] == month &&
          data2["packagename"] == "Big boy") {
        pack6.add(data2);
      } else if (data["status"] == "delivered" &&
          data["dateplaced"].split("-")[0] == year &&
          data["dateplaced"].split("-")[1] == month &&
          data2["packagename"] == "Family") {
        pack7.add(data2);
      }
    }
  }
}

fetchLocationCategories() {
  aroundChobaOrAlakahia.clear();
  notaroundChobaOrAlakahia.clear();
  for (var data in constantValues.allLocations) {
    if (data["address"].toLowerCase().contains("choba") ||
        data["address"].toLowerCase().contains("alakahia")) {
      aroundChobaOrAlakahia.add(data);
    } else {
      notaroundChobaOrAlakahia.add(data);
    }
  }
}

fetchRefundCategories() {
  approvedRefundApplication.clear();
  deniedRefundApplication.clear();
  pendingRefundApplication.clear();
  for (var data in constantValues.allRefunds) {
    if (data["status"] == "approved") {
      approvedRefundApplication.add(data);
    } else if (data["status"] == "denied") {
      deniedRefundApplication.add(data);
    } else {
      pendingRefundApplication.add(data);
    }
  }
}

fetchDataLogCategories() {
  adminLogs.clear();
  userLogs.clear();
  for (var data in constantValues.allDataLogs) {
    if (data["logtype"].toLowerCase().contains("added") ||
        data["logtype"].toLowerCase().contains("account updated") ||
        data["logtype"].toLowerCase().contains("converted") ||
        data["logtype"].toLowerCase().contains("suspended") ||
        data["logtype"].toLowerCase().contains("admin")) {
      adminLogs.add(data);
    } else {
      userLogs.add(data);
    }
  }
}
