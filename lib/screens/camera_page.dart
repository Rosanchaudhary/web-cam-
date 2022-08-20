import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:webcam/screens/video_page.dart';
//import 'package:camera_web/camera_web.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late bool _isLoading = true;
  late bool _isRecording = false;
  late CameraController _cameraController;

//initializing camera to start reccording
//initializing camera to start reccording
  _initCamera() async {
    final cameras = await availableCameras();
// final front = cameras.firstWhere(
// (camera) => camera.lensDirection == CameraLensDirection.front);
// _cameraController = CameraController(front, ResolutionPreset.max);
// await _cameraController.initialize();
// setState(() => _isLoading = false);
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() => _isLoading = false);
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  _recordVideo() async {
    if (_isRecording) {
      //file from recorded video
      final file = await _cameraController.stopVideoRecording();

//conveting file to bytes to upload in firebase
      Uint8List codeUnits = await file.readAsBytes();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path, codeUnits: codeUnits),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
                height: 500,
                width: 500,
                child: CameraPreview(_cameraController)),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
