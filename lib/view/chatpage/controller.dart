import 'dart:io';

import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/chatpage/chatpagemodel.dart';

class Chatcontroller extends GetxController {
  var Lists = <Messages>[].obs;
  var message = "".obs;
  var showimoji = false.obs;
  var selectedFileName = ''.obs;
  late XFile selectedFile;
  var selectedFileNames = <String>[].obs;
  RxList<XFile> selectedImages = <XFile>[].obs;
  var isuploading = false.obs;

  emojipicker() {
    showimoji.value = !showimoji.value;
    print("imoji ${showimoji.value}");
  }

  ///camera
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

  /// gallery image

  pickImageFromGallery(BuildContext context, Chatusers chatusers) async {
    try {
      isuploading.value = true;
      final List<XFile>? pickedImages =
          await ImagePicker().pickMultiImage(imageQuality: 70);
      if (pickedImages != null && pickedImages.isNotEmpty) {
        selectedImages.addAll(pickedImages);
        selectedFileNames.addAll(
            pickedImages.map((image) => image.path.split('/').last).toList());

        for (var image in pickedImages) {
          File file = File(image.path);
          print('Image: ${image.path.split('/').last}');
          await Apis.Sendchatimage(chatusers, file).then((value) {
            isuploading.value = false;
          });
        }

        // Optional: If you want to show an alert box or do some UI updates, you can use the below commented code.
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
        isuploading.value = false;
        print('No image selected');
      }
    } catch (e) {
      isuploading.value = false;
      print('Error picking image: $e');
    }
  }
}
