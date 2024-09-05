import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/commonwidgets/widgets.dart';
import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:chatapplication/view/Loginpage/ui/Loginpage.dart';
import 'package:chatapplication/view/homepage/ui/homepage.dart';
import 'package:chatapplication/view/profilescreen/controller/profilecontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../../color/Color.dart';

class Profilescreen extends StatelessWidget {
  final Chatusers user;
  Profilescreen({super.key, required this.user});
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Profilecontroler());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: whiteColor,
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text("ProfileScreen"),
          leading: IconButton(
              onPressed: () {
                Get.off(() => homepage(), transition: Transition.zoom);
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Commonwidgets.Getalertbox(
                      "do you want to log out",
                      whiteColor,
                      [
                        ElevatedButton(
                            onPressed: () async {
                              await Apis.updateonlineststus(false);
                              await FirebaseAuth.instance.signOut();
                              await GoogleSignIn().signOut();
                              Commonwidgets.GetSnackbar(
                                  "logout",
                                  "${user.name} logged out",
                                  whiteColor,
                                  null,
                                  NetworkImage(user.image ?? ""),
                                  context);
                              Get.off(() => loginpage(),
                                  transition: Transition.upToDown);
                              Apis.auth = FirebaseAuth.instance;
                            },
                            child: Text("yes")),
                        ElevatedButton(
                            onPressed: () async {
                              Get.back();
                            },
                            child: Text("no"))
                      ],
                      true,
                      context,
                      Text(""));
                },
                icon: Icon(Icons.login))
          ],
        ),
        body: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Stack(
                      children: [
                        Obx(() => CircleAvatar(
                              maxRadius: 60,
                              minRadius: 20,
                              child: controller
                                      .selectedFileName.value.isNotEmpty
                                  ? Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: FileImage(File(
                                                controller.selectedFile.path)),
                                            fit: BoxFit.fill),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: user.image ?? "",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Icon(Icons.error)),
                                    ),
                            )),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                                backgroundColor: darkcolor.withOpacity(.8),
                                child: IconButton(
                                    onPressed: () {
                                      Commonwidgets.showbottomsheet(
                                          context,
                                          ListView(
                                            padding: EdgeInsets.only(top: 20),
                                            shrinkWrap: true,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Obx(() => controller
                                                          .selectedFileName
                                                          .value
                                                          .isNotEmpty
                                                      ? Text(
                                                          "Selected Profile Photo",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25),
                                                        )
                                                      : Text(
                                                          "Select Your Profile Photo",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25),
                                                        )),
                                                ],
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                child: Obx(() => controller
                                                        .selectedFileName
                                                        .value
                                                        .isNotEmpty
                                                    ? Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: FileImage(
                                                                    File(controller
                                                                        .selectedFile
                                                                        .path)))),
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                controller
                                                                    .pickimageusingcam();
                                                                controller
                                                                    .CamSizeincrease();
                                                              },
                                                              icon: Icon(
                                                                Icons.camera,
                                                                size: controller
                                                                        .camsizeincrease
                                                                        .value
                                                                    ? 75
                                                                    : 40,
                                                                color: controller
                                                                        .camsizeincrease
                                                                        .value
                                                                    ? primaryColor
                                                                    : darkcolor,
                                                              )),
                                                          SizedBox(
                                                            width: 80,
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                controller
                                                                    .GALSizeincrease();
                                                                controller
                                                                    .pickfile();
                                                              },
                                                              icon: Icon(
                                                                Icons.image,
                                                                size: controller
                                                                        .gallerysizeincrease
                                                                        .value
                                                                    ? 75
                                                                    : 40,
                                                                color: controller
                                                                        .gallerysizeincrease
                                                                        .value
                                                                    ? primaryColor
                                                                    : darkcolor,
                                                              ))
                                                        ],
                                                      )),
                                              ),
                                              Obx(() => controller
                                                      .selectedFileName
                                                      .value
                                                      .isNotEmpty
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              print(
                                                                  "imagpath ${controller.selectedFile.path}");
                                                              Apis.updateprofile(File(
                                                                      controller
                                                                          .selectedFile
                                                                          .path))
                                                                  .then(
                                                                      (value) {
                                                                Commonwidgets.GetSnackbar(
                                                                    "Profile Update",
                                                                    "Profile Updated Successfully",
                                                                    whiteColor,
                                                                    SnackStyle
                                                                        .FLOATING,
                                                                    NetworkImage(
                                                                        Apis.me.image ??
                                                                            ""),
                                                                    context);
                                                                Get.off(() =>
                                                                    homepage());
                                                              });
                                                            },
                                                            child: Icon(
                                                                Icons.check)),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              controller
                                                                      .selectedFile =
                                                                  XFile("");
                                                              controller
                                                                  .selectedFileName
                                                                  .value = "";
                                                            },
                                                            child: Icon(
                                                                Icons.close))
                                                      ],
                                                    )
                                                  : SizedBox())
                                            ],
                                          ),
                                          whiteColor,
                                          4.0,
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          true,
                                          false);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: whiteColor,
                                    ))))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Text(user.email ?? ""),
                  ),
                ),
                ListTile(
                  title: Text("name"),
                  subtitle: TextFormField(
                    onSaved: (newValue) => Apis.me.name = newValue ?? "",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "required field",
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: primaryColor))),
                    initialValue: user.name,
                  ),
                ),
                ListTile(
                  title: Text("email"),
                  subtitle: TextFormField(
                    onSaved: (newValue) => Apis.me.email = newValue ?? "",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "required field",
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: primaryColor))),
                    initialValue: user.email,
                  ),
                ),
                ListTile(
                  title: Text("About"),
                  subtitle: TextFormField(
                    onSaved: (newValue) => Apis.me.about = newValue ?? "",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "required field",
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.podcasts),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: primaryColor))),
                    initialValue: user.about,
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        surfaceTintColor:
                            MaterialStatePropertyAll(primaryColor),
                        backgroundColor: MaterialStatePropertyAll(
                            primaryColor.withOpacity(.8))),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        Apis.updateuser().then((value) {
                          Commonwidgets.GetSnackbar(
                              "Profile Update",
                              "Profile Updated Successfully",
                              whiteColor,
                              SnackStyle.FLOATING,
                              NetworkImage(Apis.me.image ?? ""),
                              context);
                          Get.off(() => homepage());
                        });
                        log("validationdone");
                      }
                    },
                    child: Text("Update")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
