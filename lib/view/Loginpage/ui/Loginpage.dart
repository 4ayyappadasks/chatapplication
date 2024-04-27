import 'package:chatapplication/color/Color.dart';
import 'package:chatapplication/view/Loginpage//controll/Loginpagecontroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class loginpage extends StatelessWidget {
  const loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    final textformkey = GlobalKey<FormState>();
    var controller = Get.put(Loginpagecontroll());
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to ChAt Us",
              style: TextStyle(color: Colors.white, fontSize: 25),
            )
          ],
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(65))),
      ),
      body: Center(
        child: Form(
          key: textformkey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(height: 150, "images/chat.png"),
                TextFormField(
                  decoration: InputDecoration(hintText: "username"),
                  controller: username,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "password"),
                  controller: password,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        surfaceTintColor: MaterialStatePropertyAll(whiteColor),
                        backgroundColor:
                            MaterialStatePropertyAll(secondaryColor)),
                    onPressed: () {},
                    child: Text("log in")),
                Spacer(
                  flex: 10,
                ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
