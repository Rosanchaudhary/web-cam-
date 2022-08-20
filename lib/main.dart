import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:webcam/screens/camera_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //requirements from firebase
      options: const FirebaseOptions(
    apiKey: "AIzaSyA4pqxu_9vM-5WeEIHnux4cFVeLLeeFOIc",
    appId: "1:778253435753:web:0611083ffa8dddcd2033f8",
    messagingSenderId: "778253435753",
    projectId: "testevent-63cf4",
    storageBucket: "testevent-63cf4.appspot.com",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(),
    );
  }
}
