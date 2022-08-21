import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:webcam/controllers/upload_video_controller.dart';

class VideoPage extends StatefulWidget {
  final String filePath;
  final Uint8List codeUnits;
  const VideoPage({Key? key, required this.filePath, required this.codeUnits})
      : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  playVideo(String atUrl) {
    if (kIsWeb) {
      final v = html.window.document.getElementById('videoPlayer');
      if (v != null) {
        v.setInnerHtml('<source type="video/mp4" src="$atUrl">',
            validator: html.NodeValidatorBuilder()
              ..allowElement('source', attributes: ['src', 'type']));
        final a = html.window.document.getElementById('triggerVideoPlayer');
        if (a != null) {
          a.dispatchEvent(html.MouseEvent('click'));
        }
      }
    } else {
      // we're not on the web platform
      // and should use the video_player package
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0, 
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              uploadVideoController.uploadVideo(
                  widget.filePath, widget.codeUnits);
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
      ),
    );
  }
}

 
   
   
  