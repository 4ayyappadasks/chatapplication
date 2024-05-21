import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatapplication/model/chatpage/chatpagemodel.dart';
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

  ///****************************** chatting ****************************///

  static String getConverstioniD(String id) => user.uid.hashCode <= id.hashCode
      ? "${user.uid}_${id}"
      : "${id}_${user.uid}";

  /// get all messages(read received messages)

  static Stream<QuerySnapshot<Map<String, dynamic>>> GetAllmessages(
      Chatusers user) {
    return firestore
        .collection('chats/${getConverstioniD("${user.id}")}/messages/')
        .orderBy("sent", descending: true)
        .snapshots();
  }

  /// send messages
  static Future<void> sendmessages(
      Chatusers chatuser, String msg, Type type) async {
    log("message${msg},chatuser${jsonEncode(chatuser)},,${Type.text}");
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Messages message = Messages(
        msg: msg,
        toid: "${chatuser.id}",
        read: "",
        type: type,
        sent: time,
        fromid: user.uid);
    final ref = firestore
        .collection('chats/${getConverstioniD("${chatuser.id}")}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  /// read messaged

  static Future<void> updatemessagestatus(Messages messages) async {
    firestore
        .collection('chats/${getConverstioniD(messages.fromid)}/messages/')
        .doc(messages.sent)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

  /// get last messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> GetLastmessages(
      Chatusers user) {
    return firestore
        .collection('chats/${getConverstioniD("${user.id}")}/messages/')
        .orderBy("sent", descending: true)
        .limit(1)
        .snapshots();
  }

  /// send chat image
  static Future<void> Sendchatimage(Chatusers chatusers, File file) async {
    try {
      final ext = file.path.split(".").last;
      log("saved extention ${ext}");
      log("images arrived for changing ${file}");
      final ref = Storage.ref().child(
          "images/${getConverstioniD("${chatusers.id}")}/${DateTime.now().millisecondsSinceEpoch}.${ext}");
      await ref
          .putFile(file, SettableMetadata(contentType: "images/${ext}"))
          .then((p0) {
        log("data transfer ${p0.bytesTransferred / 1000} kb");
      });
      final imageurl = await ref.getDownloadURL();
      await sendmessages(chatusers, imageurl, Type.image);
    } catch (e) {
      log("error in profile update ${e}");
    }
  }
}
