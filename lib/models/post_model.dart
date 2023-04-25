import '../enums.dart';

class Post {
  List<String> imageUrl;
  int upvote = 0;
  int downvote = 0;
  CurrentPostState postState = CurrentPostState.pending;
  String address;
  Map<String, dynamic> location;
  List<String> reviews = [];
  DateTime timeCreated;
  bool hasTag;
  String severity;
  String city;
  String division;

  Post({
    required this.imageUrl,
    required this.address,
    required this.location,
    required this.timeCreated,
    required this.hasTag,
    required this.severity,
    required this.city,
    required this.division,
  });
}
