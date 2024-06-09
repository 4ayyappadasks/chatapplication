import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/color/Color.dart';
import 'package:chatapplication/commonwidgets/time/date_changing.dart';
import 'package:chatapplication/commonwidgets/widgets.dart';
import 'package:chatapplication/model/chatpage/chatpagemodel.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final Messages message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isme = Apis.user.uid == message.fromid;
    return InkWell(
      onLongPress: () {
        Commonwidgets.showbottomsheet(
            context,
            ListView(
              physics: ScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              children: [
                Divider(
                  endIndent: MediaQuery.of(context).size.width * .3,
                  indent: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.width * .02,
                  thickness: MediaQuery.of(context).size.width * .006,
                  color: darkcolor,
                ),
                message.type == Type.text
                    ? _OptionItem(Icon(Icons.copy_all), "Copy message", () {})
                    : _OptionItem(
                        Icon(Icons.download), "Download Image", () {}),
                Divider(
                  endIndent: MediaQuery.of(context).size.width * .005,
                  indent: MediaQuery.of(context).size.width * .005,
                  height: MediaQuery.of(context).size.width * .02,
                  thickness: MediaQuery.of(context).size.width * .005,
                  color: lightcolor,
                ),
                (message.type == Type.text && isme == true)
                    ? _OptionItem(Icon(Icons.edit), "Edit message", () {})
                    : SizedBox(),
                (isme == true)
                    ? _OptionItem(Icon(Icons.delete), "Delete message", () {})
                    : SizedBox(),
                (isme == true)
                    ? Divider(
                        endIndent: MediaQuery.of(context).size.width * .005,
                        indent: MediaQuery.of(context).size.width * .005,
                        height: MediaQuery.of(context).size.width * .02,
                        thickness: MediaQuery.of(context).size.width * .005,
                        color: lightcolor,
                      )
                    : SizedBox(),
                _OptionItem(
                    Icon(Icons.visibility),
                    "Sent at : ${Datechanging.getLastMessagetime(context: context, time: message.sent)}",
                    () {}),
                _OptionItem(
                    Icon(Icons.visibility),
                    message.read.isEmpty
                        ? "Message is Delivered but seen"
                        : "Received at :  ${Datechanging.getLastMessagetime(context: context, time: message.read)}",
                    () {}),
              ],
            ),
            whiteColor,
            4.0,
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            true,
            true);
      },
      child: isme ? _greeenmessage(context) : _bluemessage(context),
    );
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
            margin: message.type == Type.text
                ? EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 15)
                : EdgeInsets.all(5),
            padding: message.type == Type.text
                ? EdgeInsets.all(15)
                : EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: messagerecivecolor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )),
            child: message.type == Type.text
                ? Text(
                    "${message.msg}",
                    style: TextStyle(color: whiteColor),
                  )
                : CachedNetworkImage(
                    imageUrl: message.msg,
                    imageBuilder: (context, imageProvider) => Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.contain),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
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
            margin: message.type == Type.text
                ? EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 15)
                : EdgeInsets.all(5),
            padding: message.type == Type.text
                ? EdgeInsets.all(15)
                : EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: messagesentcolor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )),
            child: message.type == Type.text
                ? Text(
                    "${message.msg}",
                    style: TextStyle(color: whiteColor),
                  )
                : CachedNetworkImage(
                    imageUrl: message.msg,
                    imageBuilder: (context, imageProvider) => Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.contain),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
          ),
        ),
      ],
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback ontap;
  const _OptionItem(this.icon, this.name, this.ontap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        return ontap();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * .05,
          top: MediaQuery.of(context).size.height * .01,
          bottom: MediaQuery.of(context).size.height * .01,
        ),
        child: Row(
          children: [icon, Flexible(child: Text("${name}"))],
        ),
      ),
    );
  }
}
