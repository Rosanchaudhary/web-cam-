import 'dart:html' as html;

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/_http/_html/_file_decoder_html.dart';
import 'package:video_compress/video_compress.dart';
import 'package:webcam/modes/video.dart';

class UploadVideoController extends GetxController {
  void uploadImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen(
      (changeEvent) {
        final file = uploadInput.files!.first;
        final reader = html.FileReader();

        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen(
          (loadEndEvent) async {},
        );
      },
    );
  }

  Future<String> _uploadVideoToStorage(
      String id, String videoPath, Uint8List codeUnits) async {
    print(codeUnits);

    Reference ref = FirebaseStorage.instance.ref().child("videos").child(id);
    final file = File(videoPath);
 
    print(codeUnits);

    UploadTask uploadTask =
        ref.putData(codeUnits, SettableMetadata(contentType: "video/mp4"));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    print(downloadUrl);
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
      print("Hello this is the error");
      print(e.toString());
    }
  }
}
