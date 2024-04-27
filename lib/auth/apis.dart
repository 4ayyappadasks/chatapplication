import 'dart:developer';
import 'dart:io';

import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage Storage = FirebaseStorage.instance;
  static User get user => auth.currentUser!;

  /// user exist
  static Future<bool> userexist() async {
    return (await firestore.collection("user").doc(auth.currentUser!.uid).get())
        .exists;
  }

  /// store user name
  static late Chatusers me;

  /// user info
  static Future<void> getselfinfo() async {
    await firestore
        .collection("user")
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = Chatusers.fromJson(user.data()!);
        log("getself info ${user.data()}");
      } else {
        await Createuser().then((value) => getselfinfo());
      }
    });
  }

  /// user create
  static Future<void> Createuser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = Chatusers(
        id: user.uid,
        name: user.displayName.toString(),
        image: user.photoURL.toString(),
        email: user.email.toString(),
        createdAt: time,
        about: "using a chat",
        isOnline: false,
        lastActive: time,
        pushToken: "");
    return (await firestore
        .collection("user")
        .doc(user.uid)
        .set(chatuser.toJson()));
  }

  /// all user details
  static Stream<QuerySnapshot<Map<String, dynamic>>> Getalluser() {
    return firestore
        .collection('user')
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  /// userinfo update
  static Future<void> updateuser() async {
    await firestore
        .collection("user")
        .doc(auth.currentUser!.uid)
        .update({"name": me.name, "about": me.about, "email": me.email});
  }

  /// update profile image
  static Future<void> updateprofile(File file) async {
    try {
      final ext = file.path.split(".").last;
      log("saved extention ${ext}");
      log("images arrived for changing ${file}");
      final ref = Storage.ref().child("profileimage/${user.uid}.${ext}");
      await ref
          .putFile(file, SettableMetadata(contentType: "images/${ext}"))
          .then((p0) {
        log("data transfer ${p0.bytesTransferred / 1000} kb");
      });
      me.image = await ref.getDownloadURL();
      await firestore
          .collection("user")
          .doc(auth.currentUser!.uid)
          .update({"image": me.image});
    } catch (e) {
      log("error in profile update ${e}");
    }
  }

  /// get all messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> GetAllmessages() {
    return firestore.collection('messages').snapshots();
  }
}
