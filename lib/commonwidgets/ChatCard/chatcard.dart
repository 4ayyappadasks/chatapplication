import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/commonwidgets/ChatCard/chatcardcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class chatcard extends StatelessWidget {
  var username;

  var time;

  var description;

  var imageurl;

  chatcard({
    super.key,
    this.username,
    this.time,
    this.description,
    this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Chatcardcontroller());
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        child: ListTile(
          leading: CircleAvatar(
            child: CachedNetworkImage(
              imageUrl: imageurl,
              imageBuilder: (context, imageProvider) => Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.531),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
          trailing:
              Text("${DateTime.fromMillisecondsSinceEpoch(int.parse(time))}"),
          title: Text(
            username ?? "User name",
            style: TextStyle(color: Colors.black38),
          ),
          subtitle: Text(
            description ?? "last user message",
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
