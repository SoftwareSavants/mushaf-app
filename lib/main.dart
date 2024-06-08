import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mushaf_app/preferences.dart';
import 'package:mushaf_app/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Preferences.initialize();
  runApp(const MushafApp());
}
