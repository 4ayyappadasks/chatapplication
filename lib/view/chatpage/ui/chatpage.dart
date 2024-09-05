import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/commonwidgets/time/date_changing.dart';
import 'package:chatapplication/model/chatpage/chatpagemodel.dart';
import 'package:chatapplication/view/chatpage/controller.dart';
import 'package:chatapplication/view/chatpage/ui/userprofilescreen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../auth/apis.dart';
import '../../../color/Color.dart';
import '../../../model/homepage/homepagemodel.dart';
import '../../homepage/ui/homepage.dart';
import '../widgets/messagecard.dart';

class Chatpage extends StatelessWidget {
  final Chatusers user;
  Chatpage({super.key, required this.user});
  final msg = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Chatcontroller());
    print("last active ${user.lastActive}");
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(user.lastActive ?? ""));
    String formattedTime = DateFormat.jm().format(dateTime);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (controller.showimoji.value) {
            controller.emojipicker();
          } else {
            Get.off(() => homepage());
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size(double.infinity, MediaQuery.of(context).size.height * .25),
            child: GestureDetector(
              onTap: () {
                Get.off(() => chatuserProfilescreen(user: user));
              },
              child: StreamBuilder(
                stream: Apis.getuserinfo(user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => Chatusers.fromJson(e.data())).toList() ??
                          [];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            grad2primaryColor,
                            primaryColor,
                            grad2primaryColor,
                          ]),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Get.off(() => homepage(),
                                    transition: Transition.fade);
                              },
                              icon: Icon(
                                CupertinoIcons.back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  maxRadius:
                                      MediaQuery.of(context).size.height * .05,
                                  minRadius:
                                      MediaQuery.of(context).size.height * .02,
                                  backgroundImage: list.isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          list[0].image ?? "")
                                      : CachedNetworkImageProvider(
                                          user.image ?? ""),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    // Handle image error
                                  },
                                ),
                                SizedBox(height: 10),
                                Text(
                                  list.isNotEmpty
                                      ? "${list[0].name}"
                                      : "${user.name}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  (list.isNotEmpty)
                                      ? (list[0].isOnline!)
                                          ? "Online"
                                          : Datechanging.getlastactivetime(
                                              context: context,
                                              lastactive:
                                                  "${list[0].lastActive}")
                                      : Datechanging.getlastactivetime(
                                          context: context,
                                          lastactive: "${user.lastActive}"),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          ///
          // AppBar(
          //   automaticallyImplyLeading: false,
          //   surfaceTintColor: whiteColor,
          //   backgroundColor: primaryColor,
          //   leading: IconButton(
          //       onPressed: () {
          //         Get.off(() => homepage(), transition: Transition.fade);
          //       },
          //       icon: Icon(
          //         CupertinoIcons.back,
          //         color: Colors.white,
          //       )),
          //   centerTitle: true,
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 5),
          //         child: CircleAvatar(
          //           child: CachedNetworkImage(
          //             imageUrl: user.image ?? "",
          //             imageBuilder: (context, imageProvider) => Container(
          //               width: double.infinity,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(8.531),
          //                 image: DecorationImage(
          //                     image: imageProvider, fit: BoxFit.cover),
          //               ),
          //             ),
          //             placeholder: (context, url) => Center(
          //               child: CircularProgressIndicator(),
          //             ),
          //             errorWidget: (context, url, error) =>
          //                 const Center(child: Icon(Icons.error)),
          //           ),
          //         ),
          //       ),
          //       Column(
          //         children: [
          //           Text("${user.name}"),
          //           Text(
          //             "last seen: ${DateFormat.jm().format(dateTime)}",
          //             style:
          //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: Apis.GetAllmessages(user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        //   log("message${jsonEncode(data?[0].data())}");
                        controller.Lists.value = data
                                ?.map((e) => Messages.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (controller.Lists.value.isNotEmpty) {
                          return Obx(() => ListView.builder(
                                padding: EdgeInsets.only(top: 15),
                                physics: BouncingScrollPhysics(),
                                itemCount: controller.Lists.length,
                                itemBuilder: (context, index) => MessageCard(
                                  message: controller.Lists[index],
                                ),
                                reverse: true,
                              ));
                        } else {
                          return Center(
                              child: Text("ready for your first message"));
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
              Obx(() {
                return controller.isuploading.value == true
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          child: CircularProgressIndicator(),
                          alignment: Alignment.bottomRight,
                        ),
                      )
                    : SizedBox();
              }),
              Obx(() => controller.editmessage.value == false
                  ? Card(
                      elevation: 5,
                      margin: EdgeInsets.only(right: 10, left: 10, top: 10),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                controller.emojipicker();
                              },
                              icon: Icon(Icons.emoji_emotions_outlined)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onTap: () {
                                  if (controller.showimoji.value) {
                                    controller.emojipicker();
                                  }
                                },
                                controller: msg,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor)),
                                  hintText: "type your message......",
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.pickImageFromGallery(context, user);
                              },
                              icon: Icon(Icons.image)),
                          IconButton(
                              onPressed: () {
                                controller.pickimageusingcam(context, user);
                              },
                              icon: Icon(CupertinoIcons.camera)),
                          CircleAvatar(
                            child: IconButton(
                                onPressed: () {
                                  if (msg.text.isNotEmpty) {
                                    if (controller.Lists.isEmpty) {
                                      Apis.sendfirstmessage(
                                          user, msg.text, Type.text);
                                    } else {
                                      Apis.sendmessages(
                                          user, msg.text, Type.text);
                                    }
                                    Apis.sendpushnotification(user, msg.text);
                                    msg.text = "";
                                  }
                                },
                                icon: Icon(Icons.send)),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: TextFormField(
                        controller: controller.edtmsg,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            prefixIcon: IconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  controller.edtemojipicker();
                                },
                                icon: Icon(Icons.emoji_emotions_outlined)),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  controller.editmessage.value = false;
                                  Apis.updatemessage(controller.editedmsg,
                                      "${controller.edtmsg.text}");
                                },
                                icon: CircleAvatar(
                                  child: Icon(Icons.send),
                                ))),
                      ),
                    )),
              Obx(() => controller.showimoji.value
                  ? EmojiPicker(
                      textEditingController:
                          msg, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        height: MediaQuery.of(context).size.height * .4,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 28 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.20
                                  : 1.0),
                        ),
                        swapCategoryAndBottomBar: false,
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: const CategoryViewConfig(),
                        bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                      ),
                    )
                  : SizedBox()),
              Obx(() => controller.editshowimoji.value
                  ? EmojiPicker(
                      textEditingController: controller
                          .edtmsg, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        height: MediaQuery.of(context).size.height * .4,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 28 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.20
                                  : 1.0),
                        ),
                        swapCategoryAndBottomBar: false,
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: const CategoryViewConfig(),
                        bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                      ),
                    )
                  : SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
