import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/model/chatpage/chatpagemodel.dart';
import 'package:chatapplication/view/chatpage/controller.dart';
import 'package:flutter/cupertino.dart';
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
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: whiteColor,
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Column(
            children: [
              Text("${user.name}"),
              Text(
                "last seen: ${DateFormat.jm().format(dateTime)}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )
            ],
          ),
          flexibleSpace: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.off(() => homepage(), transition: Transition.fade);
                  },
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  )),
              CircleAvatar(
                child: CachedNetworkImage(
                  imageUrl: user.image ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.531),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              )
            ],
          ),
        ),
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
                      controller.List.value = data
                              ?.map((e) => Messages.fromJson(e.data()))
                              .toList() ??
                          [];
                      if (controller.List.value.isNotEmpty) {
                        return Obx(() => ListView.builder(
                              padding: EdgeInsets.only(top: 15),
                              physics: BouncingScrollPhysics(),
                              itemCount: controller.List.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  // Get.off(() => Chatpage(
                                  //       user: controller.List[index],
                                  //     ));
                                },
                                child: MessageCard(
                                  message: controller.List[index],
                                ),
                              ),
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
            Card(
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
                        controller: msg,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 10, bottom: 10, left: 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          hintText: "type your message......",
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.image)),
                  IconButton(
                      onPressed: () {}, icon: Icon(CupertinoIcons.camera)),
                  CircleAvatar(
                    child: IconButton(
                        onPressed: () {
                          if (msg.text.isNotEmpty) {
                            Apis.sendmessages(user, msg.text);
                            msg.text = "";
                          }
                        },
                        icon: Icon(Icons.send)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
