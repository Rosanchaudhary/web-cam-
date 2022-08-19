import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
//import 'package:video_compress/video_compress.dart';
import 'package:webcam/modes/video.dart';

class UploadVideoController extends GetxController {
  Future<String> _uploadVideoToStorage(
      String id, String videoPath, Uint8List codeUnits) async {
    Reference ref = FirebaseStorage.instance.ref().child("videos").child(id);
    UploadTask uploadTask =
        ref.putData(codeUnits, SettableMetadata(contentType: "video/mp4"));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  } 

  // _getThumbnail(String videoPath) async {
  //   final thumbNail = await VideoCompress.getFileThumbnail(videoPath);
  //   thumbNail.readAsBytes();
  //   return thumbNail;
  // }

  // _uploadImageToStorage(String id, String videoPath) async {

  //   Reference ref =
  //       FirebaseStorage.instance.ref().child("thumbnails").child(id);

  //   UploadTask uploadTask = ref.putData(await _getThumbnail(videoPath));
  //   TaskSnapshot snap = await uploadTask;
  //   String downloadUrl = await snap.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  uploadVideo(String videoPath, Uint8List codeUnits) async {
    try {
      var allDocs = await FirebaseFirestore.instance.collection("videos").get();
      int len = allDocs.docs.length;
      String videoUrl =
          await _uploadVideoToStorage("Video $len", videoPath, codeUnits);
      //String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
        id: "Video $len",
        videoUrl: videoUrl,
        thumbnail: "thumbnail",
      );

      await FirebaseFirestore.instance
          .collection("videos")
          .doc("Video $len")
          .set(video.toJson());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
