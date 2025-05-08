import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studyflash/firebase_options.dart';
import 'presentation/screens/home_screen.dart';
import 'package:studyflash/presentation/screens/intro_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/env/.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final prefs = await SharedPreferences.getInstance();
  final bool introShown = prefs.getBool('introShown') ?? false;

  runApp(StudyFlash(showIntro: !introShown));
}

class StudyFlash extends StatelessWidget {
  final bool showIntro;

  const StudyFlash({super.key, required this.showIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyFlash',
      theme: ThemeData.dark(),
      home: showIntro ? const IntroScreen() : const NewHomeScreen(),
    );
  }
}