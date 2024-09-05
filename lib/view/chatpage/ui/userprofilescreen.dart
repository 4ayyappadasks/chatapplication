import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:chatapplication/view/profilescreen/controller/profilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../color/Color.dart';
import '../../../commonwidgets/time/date_changing.dart';
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
        appBar: PreferredSize(
            preferredSize:
                Size(double.infinity, MediaQuery.of(context).size.height * .25),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .15,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      grad2primaryColor,
                      primaryColor,
                      grad2primaryColor,
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
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
                    Text(
                      "u S e r   DeTaiLs",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          gradprimaryColor,
                          grad3primaryColor,
                        ], // Define your gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircleAvatar(
                              maxRadius: 60,
                              minRadius: 20,
                              child: CachedNetworkImage(
                                imageUrl: user.image ?? "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                errorWidget: (context, url, error) => Center(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(
                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"))),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Center(
                              child: Text(
                                user.email ?? "",
                                style:
                                    TextStyle(color: whiteColor, fontSize: 15),
                              ),
                            ),
                            Center(
                              child: Text(
                                user.name ?? "",
                                style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 5,
                    color: grad2primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            grad3primaryColor,
                            gradprimaryColor
                          ], // Define your gradient colors
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: whiteColor,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: whiteColor,
                        ),
                        title: Center(
                          child: Text(
                            user.about ?? "",
                            style: TextStyle(
                              color: whiteColor,
                            ),
                          ),
                        ),
                        subtitle: Center(
                          child: Text(
                            Datechanging.getLastMessagetime(
                                showyear: true,
                                context: context,
                                time: "${user.createdAt}"),
                            style: TextStyle(
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
