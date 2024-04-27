import 'package:chatapplication/view/splashscreen/controller/Splashscreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controll = Get.put(SplashscreenController());
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.contain, image: AssetImage("images/chat.png"))),
    );
  }
}
