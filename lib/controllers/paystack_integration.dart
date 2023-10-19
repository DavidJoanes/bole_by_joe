// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:js' as js;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/controller.dart';
import '../controllers/paystack_interop.dart' as paystack;

final constantValues = Get.find<Constants>();
var userInfo = GetStorage();

class PaystackPopup {
  static Future<void> openPaystackPopup({
    required String email,
    required String amount,
    required String ref,
    required void Function() onClosed,
    required void Function() onSuccess,
  }) async {
    js.context.callMethod(
      paystack.paystackPopUp(
        userInfo.read("publicKey"),
        email,
        amount,
        ref,
        js.allowInterop(
          onClosed,
        ),
        js.allowInterop(
          onSuccess,
        ),
      ),
      [],
    );
  }
}
