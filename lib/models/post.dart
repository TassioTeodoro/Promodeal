import 'package:promodeal/models/account.dart';
import 'package:promodeal/models/comment.dart';

class Post {
  late String id;
  late Account owner;
  String contents;
  num from;
  num to;
  late List<Account> likes;
  late List<Account> share;
  late DateTime published;
  late DateTime until;
  late DateTime sheduledPostDate;
  late List<Comment> comments;

  Post(this.owner, this.contents, this.from, this.to);

}