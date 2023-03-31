// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart';

Widget getMap(double latitude, double longitude) {
  //A unique id to name the div element
  String htmlId = "6";
  //creates a webview in dart
  //ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final latLang = LatLng(latitude, longitude);
    //class to create a div element

    final mapOptions = MapOptions()
      ..zoom = 20
      ..tilt = 90
      ..center = latLang;
    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = "none";

    final map = GMap(elem, mapOptions);
    Marker(MarkerOptions()
      ..position = latLang
      ..map = map
      ..title = 'My position');
    Marker(MarkerOptions()
      ..position = LatLng(4.9557616, 6.7568832)
      ..map = map
      ..title = 'My position');
    return elem;
  });
  //creates a platform view for Flutter Web
  return HtmlElementView(
    viewType: htmlId,
  );
}
