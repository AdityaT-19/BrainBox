import 'package:get/get.dart';

class User {
  final String uid;
  final String name;
  final String username;
  final RxList<Group> gids;
  final String? profilePicLink;
  User({
    required this.uid,
    required this.name,
    required this.gids,
    required this.username,
    this.profilePicLink,
  });
}

class Group {
  final String gid;
  final String name;

  Group({
    required this.gid,
    required this.name,
  });
}
