// ignore_for_file: prefer_const_constructors, unused_import, dead_code
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:mylogin3/views/registartion/login.dart';
import 'package:mylogin3/views/registartion/registartion.dart';
import 'package:mylogin3/views/Police/dropdown.dart';
import 'package:mylogin3/views/Police/policehomescreen.dart';
import 'package:mylogin3/views/Police/qrcode.dart';
import 'package:mylogin3/views/User/feedback.dart';
import 'package:mylogin3/views/User/scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      home: LoginScreen(
          //police
          //police@gmail.com
          //police100
          //user
          //user@gmail.com
          //user123
          ),
    );
  }
}
