import 'package:url_launcher/url_launcher.dart';

class RouteTo {

  RouteTo._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
  static Future<void> openMap2(String address) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openPhone(String phoneNumber) async {
    String phone = "tel:$phoneNumber";   
    if (await canLaunchUrl(Uri.parse(phone))) {
       await launchUrl(Uri.parse(phone));
    } else {
      throw 'Could not launch $phone';
}
  }
}