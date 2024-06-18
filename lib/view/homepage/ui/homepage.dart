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
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomepageController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (controller.issearching.value == true) {
            controller.issearching.value = !controller.issearching.value;
          } else {
            SystemNavigator.pop();
          }
        },
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
                          if (i.name!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                      controller.issearching.value =
                          !controller.issearching.value;
                    },
                    icon: Icon(controller.issearching.value == true
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search))),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Commonwidgets.showAlertBoxmemberadd(
                    context: context,
                    icon: Icons.person,
                    message: "Add Chat",
                    barrierDismissible: true,
                    contentmessage: TextFormField(
                      controller: controller.email,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () async {
                            Get.back();
                            await Apis.addchatuser(controller.email.text)
                                .then((value) {
                              print("v$value");
                              if (!value) {
                                controller.email.clear();
                                Commonwidgets.show(
                                  context,
                                  message: "invalid data",
                                  content: "no user found",
                                );
                              } else {
                                controller.email.clear();
                              }
                            });
                          },
                          icon: Icon(Icons.send_and_archive),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        hintText: "enter email",
                      ),
                    ));
              },
              child: Icon(Icons.contacts),
            ),
            body: StreamBuilder(
              stream: Apis.Getmyuserid(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder(
                    stream: Apis.Getalluser(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          controller.List.value = data
                                  ?.map((e) => Chatusers.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (controller.List.isNotEmpty) {
                            return Obx(() => ListView.builder(
                                  padding: EdgeInsets.only(top: 15),
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      controller.issearching.value == true
                                          ? controller.SearchList.length
                                          : controller.List.length,
                                  itemBuilder: (context, index) => controller
                                              .issearching.value ==
                                          true
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.off(() => Chatpage(
                                                  user: controller
                                                      .SearchList[index],
                                                ));
                                          },
                                          child: chatcard(
                                            user: controller.SearchList[index],
                                            // username:
                                            //     "${controller.SearchList[index].name}",
                                            // description:
                                            //     "${controller.SearchList[index].about}",
                                            // time:
                                            //     "${controller.SearchList[index].createdAt}",
                                            // imageurl: controller
                                            //             .SearchList[index].image ==
                                            //         ""
                                            //     ? Commonwidgets.imageurl
                                            //     : "${controller.SearchList[index].image}",
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Get.off(() => Chatpage(
                                                  user: controller.List[index],
                                                ));
                                          },
                                          child: chatcard(
                                            user: controller.List[index],
                                            // username: "${controller.List[index].name}",
                                            // description:
                                            //     "${controller.List[index].about}",
                                            // time: "${controller.List[index].createdAt}",
                                            // imageurl: controller.List[index].image == ""
                                            //     ? Commonwidgets.imageurl
                                            //     : "${controller.List[index].image}",
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
                  );
                } else {
                  return Center(
                    child: Text("Start your chat"),
                  );
                }
              },
            )
            // StreamBuilder(
            //   stream: Apis.Getalluser(),
            //   builder: (context, snapshot) {
            //     switch (snapshot.connectionState) {
            //       case ConnectionState.waiting:
            //       case ConnectionState.none:
            //         return Center(child: CircularProgressIndicator());
            //       case ConnectionState.active:
            //       case ConnectionState.done:
            //         final data = snapshot.data?.docs;
            //         controller.List.value =
            //             data?.map((e) => Chatusers.fromJson(e.data())).toList() ??
            //                 [];
            //         if (controller.List.value.isNotEmpty) {
            //           return Obx(() => ListView.builder(
            //                 padding: EdgeInsets.only(top: 15),
            //                 physics: BouncingScrollPhysics(),
            //                 itemCount: controller.issearching.value == true
            //                     ? controller.SearchList.length
            //                     : controller.List.length,
            //                 itemBuilder: (context, index) =>
            //                     controller.issearching.value == true
            //                         ? GestureDetector(
            //                             onTap: () {
            //                               Get.off(() => Chatpage(
            //                                     user:
            //                                         controller.SearchList[index],
            //                                   ));
            //                             },
            //                             child: chatcard(
            //                               user: controller.SearchList[index],
            //                               // username:
            //                               //     "${controller.SearchList[index].name}",
            //                               // description:
            //                               //     "${controller.SearchList[index].about}",
            //                               // time:
            //                               //     "${controller.SearchList[index].createdAt}",
            //                               // imageurl: controller
            //                               //             .SearchList[index].image ==
            //                               //         ""
            //                               //     ? Commonwidgets.imageurl
            //                               //     : "${controller.SearchList[index].image}",
            //                             ),
            //                           )
            //                         : GestureDetector(
            //                             onTap: () {
            //                               Get.off(() => Chatpage(
            //                                     user: controller.List[index],
            //                                   ));
            //                             },
            //                             child: chatcard(
            //                               user: controller.List[index],
            //                               // username: "${controller.List[index].name}",
            //                               // description:
            //                               //     "${controller.List[index].about}",
            //                               // time: "${controller.List[index].createdAt}",
            //                               // imageurl: controller.List[index].image == ""
            //                               //     ? Commonwidgets.imageurl
            //                               //     : "${controller.List[index].image}",
            //                             ),
            //                           ),
            //               ));
            //         } else {
            //           return Center(child: Text("No data found"));
            //         }
            //     }
            //     // if (snapshot.hasData) {
            //     //
            //     //   for (var i in data!) {
            //     //     log("response = ${jsonEncode(i.data())}");
            //     //     controller.List.add(i.data()["name"]);
            //     //   }
            //     // }
            //   },
            // ),
            ),
      ),
    );
  }
}
