import 'package:chatapplication/auth/apis.dart';
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
    super.onInit();
  }
}
