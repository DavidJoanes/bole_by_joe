// // ignore_for_file: prefer_const_constructors

// import 'package:boleafrika/controllers/route_controllers.dart';
// import 'package:boleafrika/widgets/app_bar.dart';
// import 'package:boleafrika/widgets/fetch_map.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_web/flutter_google_places_web.dart';
// import 'package:geolocator/geolocator.dart';
// // import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// // import 'package:latlong2/latlong.dart' hide LatLng;
// // import 'package:mapbox_gl/mapbox_gl.dart';

// import '../../../controllers/controller.dart';
// import '../../../widgets/buttons.dart';

// class Tracking extends StatefulWidget {
//   const Tracking({super.key});

//   @override
//   State<Tracking> createState() => _TrackingState();
// }

// class _TrackingState extends State<Tracking> {
//   final constantValues = Get.find<Constants>();
//   TextEditingController suggestedPlaces = TextEditingController();
//   late Position _currentPosition;
//   // late CameraPosition _initialCameraPosition;
//   // late MapboxMapController controller;
//   TextEditingController latlangController = TextEditingController();
//   // final Distance distance = Distance();
//   // late num km = distance.as(LengthUnit.Kilometer, LatLng(24.012856, 89.259056),
//   //     LatLng(_locationData.latitude!, _locationData.longitude!));
//   bool checker = false;
//   String test = "";

//   @override
//   void initState() {
//     _getCurrentLocation();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // _onMapCreated(controller);
//     latlangController.dispose();
//     suggestedPlaces.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: constantValues.isDarkTheme
//             ? constantValues.blackColor
//             : constantValues.primaryColor,
//         foregroundColor: constantValues.whiteColor,
//         onPressed: () {
//           _getCurrentLocation();
//           // controller.animateCamera(
//           //     CameraUpdate.newCameraPosition(_initialCameraPosition));
//         },
//         child: Icon(Icons.my_location, color: constantValues.whiteColor),
//       ),
//       appBar: primaryAppBar(context, "Tracker"),
//       backgroundColor: constantValues.whiteColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             child: mixedScreen(context)),
//       ),
//     );
//   }

//   Widget mixedScreen(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final fontstyle1 =
//         GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold));
//     final fontstyle2 = GoogleFonts.poppins(
//         textStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 10));
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // SizedBox(
//         //   height: size.height * 0.6,
//         //   width: size.width,
//         //   child: checker
//         //       ? MapboxMap(
//         //           accessToken: constantValues.mapBoxAccessToken,
//         //           initialCameraPosition: _initialCameraPosition,
//         //           onMapCreated: _onMapCreated,
//         //           onStyleLoadedCallback: _onStyleLoadedCallback,
//         //           myLocationEnabled: true,
//         //           myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
//         //           minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
//         //         )
//         //       : Center(child: CircularProgressIndicator()),
//         // ),
//         latlangController.text != ""
//             ? SizedBox(
//                 height: size.height * 0.4,
//                 child: getMap(
//                     _currentPosition.latitude, _currentPosition.longitude),
//               )
//             : Center(child: CircularProgressIndicator()),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
//           child: FlutterGooglePlacesWeb(
//             apiKey: constantValues.googleApiKey,
//             proxyURL: "https://cors-anywhere.herokuapp.com/",
//             required: true,
//             components: 'country:ng',
//             decoration: InputDecoration(
//               labelStyle: fontstyle2,
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             setState(() {
//               test = FlutterGooglePlacesWeb.value['name'] ?? '';
//             });
//           },
//           child: Text('Press to test'),
//         ),
//         Text(test, style: fontstyle1),
//         SizedBox(height: 10),
//         ButtonC(
//           width: size.width * 0.5,
//           text: "Route to map",
//           onpress: () {
//             RouteTo.openMap(
//                 _currentPosition.latitude, _currentPosition.longitude);
//           },
//         ),
//       ],
//     );
//   }

// // Method for retrieving the current location

//   _getCurrentLocation() async {
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//         .then((Position position) async {
//       setState(() {
//         // Store the position in the variable
//         _currentPosition = position;
//         latlangController.text =
//             "${_currentPosition.latitude}, ${_currentPosition.longitude}";

//         // For moving the camera to current location
//         // mapController.animateCamera(
//         //   CameraUpdate.newCameraPosition(
//         //     CameraPosition(
//         //       target: LatLng(position.latitude, position.longitude),
//         //       zoom: 18.0,
//         //     ),
//         //   ),
//         // );
//       });
//       // await _getAddress();
//     }).catchError((e) {
//       // print(e);
//     });
//   }

//   // _marker() {
//   // return CurrentLocationLayer(
//   //     followOnLocationUpdate: FollowOnLocationUpdate.always,
//   //     turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
//   //     style: LocationMarkerStyle(
//   //       marker: DefaultLocationMarker(
//   //         child: Icon(
//   //           Icons.navigation,
//   //           color: constantValues.primaryColor,
//   //           size: 20,
//   //         ),
//   //       ),
//   //       markerSize: const Size(30, 30),
//   //       markerDirection: MarkerDirection.heading,
//   //     ));
//   // }

//   // _onMapCreated(MapboxMapController controller) async {
//   //   this.controller = controller;
//   // }

//   // _onStyleLoadedCallback() async {
//   //   await controller.addSymbol(
//   //     SymbolOptions(
//   //       geometry: LatLng(_locationData.latitude!, _locationData.longitude!),
//   //       iconSize: 0.2,
//   //     ),
//   //   );
//   // _addSourceAndLineLayer(0, false);
//   // }
// }
