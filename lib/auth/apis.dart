import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatapplication/model/chatpage/chatpagemodel.dart';
import 'package:chatapplication/model/homepage/homepagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage Storage = FirebaseStorage.instance;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
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
        await getfirbasemessagingtoken();
        Apis.updateonlineststus(true);
        updateonlineststus(true);
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

  /// delete message

  static Future<void> deletemessage(Messages messages) async {
    firestore
        .collection('chats/${getConverstioniD(messages.toid)}/messages/')
        .doc(messages.sent)
        .delete();
    if (messages.type == Type.image)
      await Storage.refFromURL(messages.msg).delete();
  }

  /// update message

  static Future<void> updatemessage(
      Messages messages, String? updatedmessage) async {
    firestore
        .collection('chats/${getConverstioniD(messages.toid)}/messages/')
        .doc(messages.sent)
        .update({"msg": updatedmessage});
  }

  /// getuser info

  static Stream<QuerySnapshot<Map<String, dynamic>>> getuserinfo(
      Chatusers user) {
    return firestore
        .collection('user')
        .where("id", isEqualTo: user.id)
        .snapshots();
  }

  /// update online and offline
  static Future<void> updateonlineststus(bool isonline) async {
    firestore.collection('user').doc(user.uid).update({
      "is_online": isonline,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
      "push_Token": me.pushToken,
    });
  }

  ///*************************************/// get firebase notification
  static Future<void> getfirbasemessagingtoken() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await messaging.getToken().then((value) {
      log("messagesssssssssssssssssssssss${value}");
      if (value != null) {
        me.pushToken = value;
        log("fcm token${value}");
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  /// send push notification
  static Future<void> sendpushnotification(
      Chatusers chatusers, String message) async {
    //var url = Uri.https('example.com', 'whatsit/create');
    log("messageiii:${message}");
    final body = {
      "message": {
        'token': chatusers.pushToken,
        "notification": {
          "title": "${chatusers.name}",
          "body": "${message}",
        }
      },
      // "data": {
      //   "some_data": "User ID:${me.id}",
      // },
    };
    var response = await http.post(
        Uri.parse(
            "https://fcm.googleapis.com/v1/projects/chat-us-41c60/messages:send"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:
              "Bearer ya29.a0AXooCguT0A8vyZnSPWCCi6tBVc3sSDZbYGVQTY5z6oO6Es8uON2Cf7vu2xDuM0JLbEfArtsZFkhYPtD149Rf8AOxWP3Zq7r1CqN-9A8Y9H75S9Kzzn5oS7X4aO9pT62dMYfoo_ltOoGMzwD24r5TWI4b4kjD-TGPHG-9aCgYKAVcSARISFQHGX2MinECezd0oNjXCFmEth79enw0171"
        },
        body: jsonEncode(body));
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');
  }
}
