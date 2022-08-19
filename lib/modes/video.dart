// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String id;
  String videoUrl;
  String thumbnail;

  Video({
    required this.id,
    required this.videoUrl,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Video(
      id: snapshot['id'],
      videoUrl: snapshot['videoUrl'],
      thumbnail: snapshot['thumbnail'],
    );
  }
}
