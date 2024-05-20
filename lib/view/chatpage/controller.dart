import 'dart:io';

import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/chatpage/chatpagemodel.dart';

class Chatcontroller extends GetxController {
  var List = <Messages>[].obs;
  var message = "".obs;
  var showimoji = false.obs;
  var selectedFileName = ''.obs;
  late XFile selectedFile; //
  emojipicker() {
    showimoji.value = !showimoji.value;
    print("imoji ${showimoji.value}");
  }

  pickimageusingcam(BuildContext context, Chatusers chatusers) async {
    try {
      final XFile? pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80);

      if (pickedImage != null) {
        selectedFile = pickedImage;
        selectedFileName.value = selectedFile.path.split('/').last;
        File file = File(selectedFile.path);
        print('Image: $selectedFileName');
        Apis.Sendchatimage(chatusers, file);
        // Commonwidgets.Getalertbox(
        //     "image",
        //     whiteColor,
        //     [
        //       TextButton(onPressed: () {}, child: Text("ok")),
        //       TextButton(onPressed: () {}, child: Text("no")),
        //     ],
        //     true,
        //     context,
        //     Image.file(file));
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
