import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/commonwidgets/ChatCard/chatcardcontroller.dart';
import 'package:chatapplication/commonwidgets/time/date_changing.dart';
import 'package:chatapplication/model/chatpage/chatpagemodel.dart';
import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../color/Color.dart';

class chatcard extends StatelessWidget {
  final Chatusers user;

  // var time;
  //
  // var description;
  //
  // var imageurl;

  chatcard({
    super.key,
    required this.user,
    // this.time,
    // this.description,
    // this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Chatcardcontroller());

    /// messages
    Messages? messages;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        child: StreamBuilder(
          stream: Apis.GetLastmessages(user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            controller.templist.value =
                data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
            if (controller.templist.isNotEmpty) {
              messages = controller.templist[0];
            }
            return ListTile(
              leading: CircleAvatar(
                child: CachedNetworkImage(
                  imageUrl: user.image,
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
              ),
              // leading: CircleAvatar(
              //   backgroundColor: Colors.white,
              //   backgroundImage: NetworkImage(imageurl),
              // ),
              trailing: messages == null
                  ? null
                  : messages!.read.isEmpty && messages!.fromid != Apis.user.uid
                      ? Icon(
                          Icons.circle,
                          color: messageactivecolor,
                        )
                      : Text(Datechanging.getLastMessagetime(
                          context: context, time: messages?.sent ?? "")),
              // Text(
              //     "${DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt))}"),
              title: Text(
                user.name,
                style: TextStyle(color: Colors.black38),
              ),
              subtitle: Text(
                messages != null
                    ? messages?.msg ?? ""
                    : "about : ${user.about}",
                maxLines: 1,
              ),
            );
          },
        ),
      ),
    );
  }
}
