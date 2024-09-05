import 'package:chatapplication/color/Color.dart';
import 'package:chatapplication/view/Loginpage//controll/Loginpagecontroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class loginpage extends StatelessWidget {
  const loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    final textformkey = GlobalKey<FormState>();
    var controller = Get.put(Loginpagecontroll());
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   flexibleSpace: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         "Welcome to ChAt Us",
        //         style: TextStyle(color: Colors.white, fontSize: 25),
        //       )
        //     ],
        //   ),
        //   backgroundColor: primaryColor,
        //   automaticallyImplyLeading: false,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(65))),
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ChAt Us",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Image.asset(height: 150, "images/chat.png"),
              ElevatedButton.icon(
                style: ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                    fixedSize:
                        MaterialStatePropertyAll(Size(double.infinity, 70)),
                    surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                    elevation: MaterialStatePropertyAll(10)),
                onPressed: () {
                  controller.handleGoogleSignIn(context);
                },
                icon: Image.asset("images/google.png"),
                label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                      TextSpan(text: "sign in with "),
                      TextSpan(
                          text: "GOOGLE",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ])),
              ),
            ],
          ),
          // child: Form(
          //   key: textformkey,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Column(
          //       children: [
          //         Expanded(
          //           child: Column(
          //             children: [
          //               Image.asset(height: 150, "images/chat.png"),
          //               TextFormField(
          //                 decoration: InputDecoration(hintText: "username"),
          //                 controller: username,
          //               ),
          //               Obx(() => TextFormField(
          //                     decoration: InputDecoration(
          //                         hintText: "password",
          //                         suffixIcon: IconButton(
          //                             onPressed: () {
          //                               controller.togglepass();
          //                             },
          //                             icon: controller.passvisible.value
          //                                 ? Icon(Icons.visibility_off)
          //                                 : Icon(Icons.visibility))),
          //                     controller: password,
          //                     obscureText: controller.passvisible.value,
          //                   )),
          //               ElevatedButton(
          //                   style: ButtonStyle(
          //                       surfaceTintColor:
          //                           MaterialStatePropertyAll(whiteColor),
          //                       backgroundColor:
          //                           MaterialStatePropertyAll(secondaryColor)),
          //                   onPressed: () {
          //                     Apis.loginWithEmailAndPassword(
          //                             "ayyappadasksglobosoft1@gmail.com",
          //                             "password")
          //                         .then((value) => Get.to(() => homepage()));
          //                   },
          //                   child: Text("log in")),
          //             ],
          //           ),
          //         ),
          //
          //         // ElevatedButton(
          //         //     style: ButtonStyle(
          //         //         surfaceTintColor:
          //         //             MaterialStatePropertyAll(whiteColor),
          //         //         backgroundColor:
          //         //             MaterialStatePropertyAll(secondaryColor)),
          //         //     onPressed: () {
          //         //       Get.to(() => RegistrationScreen());
          //         //     },
          //         //     child: Text("Create your Account")),
          //         ElevatedButton.icon(
          //           style: ButtonStyle(
          //               padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
          //               fixedSize:
          //                   MaterialStatePropertyAll(Size(double.infinity, 70)),
          //               surfaceTintColor:
          //                   MaterialStatePropertyAll(Colors.white),
          //               backgroundColor: MaterialStatePropertyAll(Colors.white),
          //               shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(15))),
          //               elevation: MaterialStatePropertyAll(10)),
          //           onPressed: () {
          //             controller.handleGoogleSignIn(context);
          //           },
          //           icon: Image.asset("images/google.png"),
          //           label: RichText(
          //               text: TextSpan(
          //                   style: TextStyle(color: Colors.black),
          //                   children: [
          //                 TextSpan(text: "sign in with "),
          //                 TextSpan(
          //                     text: "GOOGLE",
          //                     style: TextStyle(fontWeight: FontWeight.bold))
          //               ])),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
