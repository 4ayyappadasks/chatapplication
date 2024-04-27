import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profilecontroler extends GetxController {
  var camsizeincrease = false.obs;
  var gallerysizeincrease = false.obs;
  var selectedFileName = ''.obs;
  late XFile selectedFile; //
  // late XFile CAMFilename;
  // var CAMselectedFileName = ''.obs;
  CamSizeincrease() {
    camsizeincrease.value = true;
    gallerysizeincrease.value = false;
    print("sizeincreaseofcam ${camsizeincrease}");
    print("sizeincreasegal ${gallerysizeincrease}");
  }

  GALSizeincrease() {
    camsizeincrease.value = false;
    gallerysizeincrease.value = true;
    print("sizeincreaseofcam ${camsizeincrease}");
    print("sizeincreasegal ${gallerysizeincrease}");
  }

  void pickfile() async {
    try {
      final XFile? pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedImage != null) {
        selectedFile = pickedImage;
        selectedFileName.value = selectedFile.path.split('/').last;
        print('Image: $selectedFileName');
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  pickimageusingcam() async {
    try {
      final XFile? pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80);

      if (pickedImage != null) {
        selectedFile = pickedImage;
        selectedFileName.value = selectedFile.path.split('/').last;
        print('Image: $selectedFileName');
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
