import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'Screens/landing_screen.dart';

void InitProj() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(
    const MyApp(),
  );
}

void main() {
  InitProj();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'File Downloader Feature',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
