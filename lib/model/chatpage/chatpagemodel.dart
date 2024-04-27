class Messages {
  Messages({
    required this.msg,
    required this.toid,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromid,
  });
  late final String msg;
  late final String toid;
  late final String read;
  late final Type type;
  late final String sent;
  late final String fromid;

  Messages.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    ;
    toid = json['toid'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromid = json['fromid'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['toid'] = toid;
    data['read'] = read;
    data['type'] = type;
    data['sent'] = sent;
    data['fromid'] = fromid;
    return data;
  }
}

enum Type { text, image }
