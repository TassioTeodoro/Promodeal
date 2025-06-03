import 'package:promodeal/models/account.dart';
import 'package:promodeal/models/post.dart';

class Comment {
  String id;
  String content;
  DateTime date;
  Account from;

  Comment(this.id, this.content,this.date,this.from);

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(map["id"] ?? "", map["content"] ?? "", map["date"], map["from"]);
  }

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date,
      'from': from,
    };
  }
}