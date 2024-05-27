import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/commonwidgets/time/date_changing.dart';
import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:chatapplication/view/profilescreen/controller/profilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../color/Color.dart';
import 'chatpage.dart';

class chatuserProfilescreen extends StatelessWidget {
  final Chatusers user;
  final i;
  chatuserProfilescreen({super.key, required this.user, this.i});
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
          title: Text("${user.name}"),
          leading: IconButton(
              onPressed: () {
                Get.off(
                    () => Chatpage(
                          user: user,
                        ),
                    transition: Transition.zoom);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircleAvatar(
                  maxRadius: 60,
                  minRadius: 20,
                  child: CachedNetworkImage(
                    imageUrl: user.image ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
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
                readOnly: true,
                onSaved: (newValue) => Apis.me.name = newValue ?? "",
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : "required field",
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
                readOnly: true,
                onSaved: (newValue) => Apis.me.email = newValue ?? "",
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : "required field",
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
                readOnly: true,
                onSaved: (newValue) => Apis.me.about = newValue ?? "",
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : "required field",
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.podcasts),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: primaryColor))),
                initialValue: user.about,
              ),
            ),
            Spacer(),
            ListTile(
              title: Text("Account Created"),
              subtitle: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.podcasts),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: primaryColor))),
                initialValue: Datechanging.getLastMessagetime(
                    showyear: true,
                    context: context,
                    time: "${user.createdAt}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
