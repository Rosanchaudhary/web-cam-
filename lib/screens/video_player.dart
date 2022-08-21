import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:webcam/controllers/upload_video_controller.dart';

class VideoApp extends StatefulWidget {
  final String path;
    final Uint8List codeUnits;

  const VideoApp({Key? key, required this.path,required this.codeUnits}) : super(key: key);

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
    UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());
  late VideoPlayerController _controller;
  late Duration videoLength;
  late Duration videoPosition;

  double volume = 0.5;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.path)
      ..addListener(() => setState(() {
            videoPosition = _controller.value.position;
          }))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          videoLength = _controller.value.duration;
        });
      });
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
                    widget.path, widget.codeUnits);
              },
            )
          ],
        ),
        body: Column(
            children: [
              if (_controller.value.isInitialized) ...[
                SizedBox(
                  height: MediaQuery.of(context).size.height-110,
                  child: VideoPlayer(_controller)),
                
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.black,
                      ),
                      onPressed: () => setState(
                        () {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        },
                      ),
                    ),

                    Icon(animatedVolumeIcon(volume)),
                    Slider(
                        value: volume,
                        min: 0,
                        max: 1,
                        onChanged: (changedVolume) {
                          setState(() {
                            volume = changedVolume;
                            _controller.setVolume(changedVolume);
                          });
                        }),
                    const Spacer(),
                    IconButton(
                        icon: Icon(Icons.loop,
                            color: _controller.value.isLooping
                                ? Colors.green
                                : Colors.black),
                        onPressed: () {
                          _controller.setLooping(!_controller.value.isLooping);
                        })
                  ],
                )
              ]
            ],
          ),
        
      
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


IconData animatedVolumeIcon(double volume) {
  if (volume == 0) {
    return Icons.volume_mute;
  } else if (volume < 0.5) {
    return Icons.volume_down;
  } else {
    return Icons.volume_up;
  }
}
