import 'package:get/get.dart';

import '../../model/chatpage/chatpagemodel.dart';

class Chatcontroller extends GetxController {
  var List = <Messages>[].obs;
  var message = "".obs;
  var showimoji = false.obs;
  emojipicker() {
    showimoji.value = !showimoji.value;
    print("imoji ${showimoji.value}");
  }
}
