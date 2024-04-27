import 'dart:developer';
import 'dart:io';

import 'package:chatapplication/auth/apis.dart';
import 'package:chatapplication/commonwidgets/widgets.dart';
import 'package:chatapplication/view/homepage/ui/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginpagecontroll extends GetxController {
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log("error in google sign in${e}");
      Commonwidgets.ShowSanckbar(context, "error in network${e}");
    }
    return null;
  }

  handleGoogleSignIn(BuildContext context) async {
    Commonwidgets.progressindicator(context);
    // try {
    signInWithGoogle(context).then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log("user details${user.user}additional ${user.additionalUserInfo}");
        if ((await Apis.userexist())) {
          // Get.to(() => homepage());
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => homepage(),
          ));
        } else {
          Apis.Createuser().then((value) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => homepage()));
          });
        }
        Commonwidgets.GetSnackbar(
          "Sign in Success",
          "${user.user?.displayName}",
          null,
          null,
          NetworkImage(
            "${user.user?.photoURL}",
          ),
          context,
        );
      } else {
        Get.to(() => homepage());
      }
    });
    // } catch (e) {
    //   // Handle sign-in errors
    //   print("Error signing in with Google: $e");
    // }
  }
}
