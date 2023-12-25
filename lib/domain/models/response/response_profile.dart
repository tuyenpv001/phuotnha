class ResponseProfile {
  final bool resp;
  final String message;
  final ProfileDetail profile;
  final List<TripProfile> tripsProfile;
  final List<TripImage> tripsImage;
  final List<PostImage> postsImage;

  ResponseProfile({required this.resp, required this.message, required this.profile, required this.tripsProfile, required this.tripsImage, required this.postsImage});

   factory ResponseProfile.fromJson(Map<String, dynamic> json) => ResponseProfile(
        resp: json["resp"],
        message: json["message"],
        profile:ProfileDetail.fromJson(json['profile'][0]),
        tripsProfile: List<TripProfile>.from(json["tripsProfile"].map((x) => TripProfile.fromJson(x))),
        tripsImage:List<TripImage>.from(json["tripsImage"].map((x) => TripImage.fromJson(x))) ,
        postsImage: List<PostImage>.from(
            json["postsImage"].map((x) => PostImage.fromJson(x))),
      );
  
}

class PostImage {
  //  images_post.uid as postuid, images_post.image postImage
  final String postUid;
  final String postImage;

  PostImage({required this.postUid, required this.postImage});
   factory PostImage.fromJson(Map<String, dynamic> json) => PostImage(
      postUid: json['postuid'],
      postImage: json['postImage']
   );
}

class TripImage {
  // trip_images.uid as tripuid,trip_images.trip_image_url as tripImage
  final String tripUid;
  final String tripImage;

  TripImage({required this.tripUid, required this.tripImage});
factory TripImage.fromJson(Map<String, dynamic> json) =>
      TripImage(tripUid: json['tripuid'], tripImage: json['tripImage']);
}

class TripProfile {
  // trips.uid as tripuid, ROUND(AVG(trip_members.trip_rate), 2) as avgRate, COUNT(trip_members.person_uid) as memberJoined, COUNT(trip_members.trip_comment) as totalComment
  final String tripUid;
  final String title;
  final double avgRate;
  final int memberJoined;
  final int totalComment;

  TripProfile({required this.tripUid,required this.avgRate,required this.title, required this.memberJoined, required this.totalComment});

  factory TripProfile.fromJson(Map<String, dynamic> json) => TripProfile(
    tripUid: json['tripuid'],
    title: json['trip_title'],
    avgRate:  json['avgRate'] == 0 ? 0.toDouble() : json['avgRate'] + 0.0 , 
    memberJoined: json['memberJoined'], 
    totalComment: json['totalComment']);
}

class ProfileDetail {
  final String fullname;
  final String avatar;
  final String coverImage;
  final String email;
  final String username;
  final String achievement;
  final int isLeader;
  final int countTripCreated;
  final int countPostCreated;
  final int countTripJoined;
  final int countUserFollowing;
  final int countUserFollower;

  ProfileDetail( {required this.fullname, required this.avatar, required this.coverImage, required this.email, required this.username, required this.isLeader, required this.countTripCreated, required this.countPostCreated, required this.countTripJoined, required this.countUserFollowing, required this.countUserFollower,required this.achievement});

  factory ProfileDetail.fromJson(Map<String, dynamic> json) => ProfileDetail(
    fullname: json['fullname'], 
    avatar: json['image'], 
    coverImage: json['cover'], 
    email: json['email'], 
    username: json['username'], 
    isLeader: json['is_leader'], 
    achievement: json['achievement'],
    countTripCreated: json['countTripCreated'], 
    countPostCreated: json['countPostCreated'], 
    countTripJoined: json['countTripJoined'], 
    countUserFollowing: json['countUserFollowing'], 
    countUserFollower: json['countUserFollower']);


}  //  person.fullname, person.image, person.cover,person.is_leader, person.achievement,users.email, users.username,
	// (SELECT COUNT(uid) FROM trips WHERE trips.user_uid = ID_USER) AS countTripCreated,
  //   (SELECT COUNT(uid) FROM trip_members WHERE trip_members.person_uid = ID_USER) AS countTripJoined,
  //   (SELECT COUNT(uid) FROM posts WHERE posts.person_uid = ID_USER) AS countPostCreated,
  //   (SELECT COUNT(uid) FROM followers WHERE followers.person_uid = ID_USER) AS countUserFollowing,
  //   (SELECT COUNT(uid) FROM followers WHERE followers.followers_uid = ID_USER) AS countUserFollower

