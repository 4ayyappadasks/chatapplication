// // To parse this JSON data, do
// //
// //     final chatUSers = chatUSersFromJson(jsonString);
//
// import 'dart:convert';
//
// ChatUSers chatUSersFromJson(String str) => ChatUSers.fromJson(json.decode(str));
//
// String chatUSersToJson(ChatUSers data) => json.encode(data.toJson());
//
// class ChatUSers {
//   String image;
//   String pushToken;
//   String isActive;
//   String about;
//   String name;
//   String createdAt;
//   bool isOnline;
//   String lastActive;
//   String id;
//   String email;
//
//   ChatUSers({
//     required this.image,
//     required this.pushToken,
//     required this.isActive,
//     required this.about,
//     required this.name,
//     required this.createdAt,
//     required this.isOnline,
//     required this.lastActive,
//     required this.id,
//     required this.email,
//   });
//
//   factory ChatUSers.fromJson(Map<String, dynamic> json) => ChatUSers(
//         image: json["image"],
//         pushToken: json["push_Token"],
//         isActive: json["is_active"],
//         about: json["about"],
//         name: json["name"],
//         createdAt: json["created_at"],
//         isOnline: json["is_online"],
//         lastActive: json["last_active"],
//         id: json["id"],
//         email: json["email"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "image": image,
//         "push_Token": pushToken,
//         "is_active": isActive,
//         "about": about,
//         "name": name,
//         "created_at": createdAt,
//         "is_online": isOnline,
//         "last_active": lastActive,
//         "id": id,
//         "email": email,
//       };
// }
class Chatusers {
  String? image;
  String? pushToken;
  String? isActive;
  String? about;
  String? name;
  String? createdAt;
  bool? isOnline;
  String? lastActive;
  String? id;
  String? email;

  Chatusers(
      {this.image,
      this.pushToken,
      this.isActive,
      this.about,
      this.name,
      this.createdAt,
      this.isOnline,
      this.lastActive,
      this.id,
      this.email});

  Chatusers.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    pushToken = json['push_Token'];
    isActive = json['is_active'];
    about = json['about'];
    name = json['name'];
    createdAt = json['created_at'];
    isOnline = json['is_online'];
    lastActive = json['last_active'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['push_Token'] = this.pushToken;
    data['is_active'] = this.isActive;
    data['about'] = this.about;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['is_online'] = this.isOnline;
    data['last_active'] = this.lastActive;
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}
