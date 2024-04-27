import 'dart:developer';

import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/color/Color.dart';
import 'package:chatapplication/commonwidgets/ChatCard/chatcard.dart';
import 'package:chatapplication/commonwidgets/widgets.dart';
import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:chatapplication/view/chatpage/ui/chatpage.dart';
import 'package:chatapplication/view/homepage/controller/homepagecontroller.dart';
import 'package:chatapplication/view/profilescreen/ui/Profilescreenn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomepageController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: whiteColor,
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Obx(() => controller.issearching.value == true
              ? TextFormField(
                  onChanged: (value) {
                    controller.SearchList.clear();
                    for (var i in controller.List.value) {
                      if (i.name!.toLowerCase().contains(value.toLowerCase()) ||
                          i.email!
                              .toLowerCase()
                              .contains(value.toLowerCase())) {
                        controller.SearchList.add(i);
                      }
                      ;
                    }
                    log("message${controller.SearchList.length}mes${controller.List.length}");
                  },
                  decoration: InputDecoration(
                      hintText: "search hear",
                      hintStyle: TextStyle(
                        color: whiteColor,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteColor)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      fillColor: primaryColor,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteColor))),
                )
              : Text("ChAt Us")),
          leading: IconButton(
              onPressed: () {
                Get.off(
                    () => Profilescreen(
                          user: Apis.me,
                        ),
                    transition: Transition.zoom);
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              )),
          actions: [
            Obx(() => IconButton(
                onPressed: () {
                  controller.issearching.value = !controller.issearching.value;
                },
                icon: Icon(controller.issearching.value == true
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.chat),
        ),
        body: StreamBuilder(
          stream: Apis.Getalluser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                controller.List.value =
                    data?.map((e) => Chatusers.fromJson(e.data())).toList() ??
                        [];
                if (controller.List.value.isNotEmpty) {
                  return Obx(() => ListView.builder(
                        padding: EdgeInsets.only(top: 15),
                        physics: BouncingScrollPhysics(),
                        itemCount: controller.issearching.value == true
                            ? controller.SearchList.length
                            : controller.List.length,
                        itemBuilder: (context, index) => controller
                                    .issearching.value ==
                                true
                            ? GestureDetector(
                                onTap: () {
                                  Get.off(() => Chatpage(
                                        user: controller.SearchList[index],
                                      ));
                                },
                                child: chatcard(
                                  username:
                                      "${controller.SearchList[index].name}",
                                  description:
                                      "${controller.SearchList[index].about}",
                                  time:
                                      "${controller.SearchList[index].createdAt}",
                                  imageurl: controller
                                              .SearchList[index].image ==
                                          ""
                                      ? Commonwidgets.imageurl
                                      : "${controller.SearchList[index].image}",
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Get.off(() => Chatpage(
                                        user: controller.List[index],
                                      ));
                                },
                                child: chatcard(
                                  username: "${controller.List[index].name}",
                                  description:
                                      "${controller.List[index].about}",
                                  time: "${controller.List[index].createdAt}",
                                  imageurl: controller.List[index].image == ""
                                      ? Commonwidgets.imageurl
                                      : "${controller.List[index].image}",
                                ),
                              ),
                      ));
                } else {
                  return Center(child: Text("No data found"));
                }
            }
            // if (snapshot.hasData) {
            //
            //   for (var i in data!) {
            //     log("response = ${jsonEncode(i.data())}");
            //     controller.List.add(i.data()["name"]);
            //   }
            // }
          },
        ),
      ),
    );
  }
}
