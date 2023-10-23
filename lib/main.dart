import 'package:appeventos/app/dependecy_inyector/inyector.dart';
import 'package:appeventos/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meedu/meedu.dart';
import 'app/data/data_source/remote/push_notifications_service.dart';
import 'app/my_app.dart';

void main() async{
  bool shouldUseFirestoreEmulator=false;
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  await Firebase.initializeApp(options: 
   DefaultFirebaseOptions.currentPlatform);
  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  Get.put<Inyector>(Inyector());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Solo modo vertical
  ]);
  runApp(const MyApp());
}
  