import 'dart:developer';

import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/color/Color.dart';
import 'package:chatapplication/commonwidgets/time/date_changing.dart';
import 'package:chatapplication/model/chatpage/chatpagemodel.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final Messages message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == message.fromid
        ? _greeenmessage(context)
        : _bluemessage(context);
  }

  /// received message
  Widget _bluemessage(BuildContext context) {
    if (message.read.isEmpty) {
      Apis.updatemessagestatus(message);
      log("message read sucessfully");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: messagerecivecolor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )),
            child: Text(
              "${message.msg}",
              style: TextStyle(color: whiteColor),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(Datechanging.Getformated_Date(
              context: context, time: message.sent)),
        )
      ],
    );
  }

  ///  send message
  Widget _greeenmessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(Datechanging.Getformated_Date(
                  time: message.sent, context: context)),
            ),
            if (message.read.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(
                  size: 20,
                  Icons.done_all,
                  color: messagereadcolor,
                ),
              )
          ],
        ),
        Spacer(),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: messagesentcolor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )),
            child: Text(
              maxLines: null,
              "${message.msg}",
              style: TextStyle(color: whiteColor),
            ),
          ),
        ),
      ],
    );
  }
}
