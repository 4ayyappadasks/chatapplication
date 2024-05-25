import 'dart:developer';

import 'package:chatapplication/auth/apis.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/homepage/homepagemodel.dart';

class HomepageController extends GetxController {
  /// store all user
  var List = <Chatusers>[].obs;

  /// store searching users
  var SearchList = <Chatusers>[].obs;

  /// serach  conditions
  var issearching = false.obs;
  @override
  void onInit() {
    Apis.getselfinfo();
    Apis.updateonlineststus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log("message of ${message}");
      log("res${Apis.auth.currentUser}");
      if (Apis.auth.currentUser != null) {
        if (message.toString().contains("paused")) {
          Apis.updateonlineststus(false);
        }
        if (message.toString().contains("resumed")) {
          Apis.updateonlineststus(true);
        }
      }
      return Future.value(message);
    });
    super.onInit();
  }
}
