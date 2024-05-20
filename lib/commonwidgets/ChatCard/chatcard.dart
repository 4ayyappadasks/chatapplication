import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/commonwidgets/ChatCard/chatcardcontroller.dart';
import 'package:chatapplication/commonwidgets/time/date_changing.dart';
import 'package:chatapplication/model/chatpage/chatpagemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../color/Color.dart';
import '../../model/homepage/homepagemodel.dart';
import '../widgets.dart';

class chatcard extends StatelessWidget {
  // var username;
  //
  // var time;
  //
  // var description;
  //
  // var imageurl;

  Chatusers user;

  chatcard(
      {
      // super.key,
      // this.username,
      // this.time,
      // this.description,
      // this.imageurl,
      required this.user});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Chatcardcontroller());
    Messages? messages;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        child: StreamBuilder(
          stream: Apis.GetLastmessages(user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            if (data != null && data.isNotEmpty && data.first.exists) {
              log("messagegg${data}");
              messages = Messages.fromJson(data.first.data());
              log("last 00message:${messages?.msg}");
            } else {
              log("No documents found or the first document does not exist.");
            }
            return ListTile(
              leading: CircleAvatar(
                child: CachedNetworkImage(
                  imageUrl: user.image ?? Commonwidgets.imageurl,
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
                  : messages!.read.isEmpty && messages?.fromid != Apis.user.uid
                      ? Icon(
                          Icons.radio_button_checked,
                          color: messageactivecolor,
                        )
                      : Text(Datechanging.getLastMessagetime(
                          context: context, time: messages?.sent ?? "")),
              title: Text(
                user.name ?? "User name",
                style: TextStyle(color: Colors.black38),
              ),
              subtitle: messages?.msg == null || messages?.type == Type.text
                  ? Text(
                      messages?.msg ?? user.about ?? "",
                      maxLines: 1,
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.image)),
            );
          },
        ),
      ),
    );
  }
}
