import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_manager/pages/home_page.dart';

late AudioHandler _audioHandler;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Misuc Manager',
      // darkTheme: ThemeData.dark(),
      theme: ThemeData.dark(),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
