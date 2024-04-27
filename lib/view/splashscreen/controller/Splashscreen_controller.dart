import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../Loginpage/ui/Loginpage.dart';
import '../../homepage/ui/homepage.dart';

class SplashscreenController extends GetxController {
  checkisloagedin() {
    Future.delayed(
      Duration(
        seconds: 5,
      ),
      () {
        print("errrrrr${FirebaseAuth.instance.currentUser}");
        FirebaseAuth.instance.currentUser == null ? Get.to(() =>

            //homepage()
            loginpage()) : Get.to(() => homepage());
      },
    );
  }

  @override
  void onInit() {
    checkisloagedin();
    // TODO: implement onInit
    super.onInit();
  }
}
