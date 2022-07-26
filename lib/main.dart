import 'package:flutter/material.dart';
import 'homepage.dart';
import 'mahasiswa_tambah.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      routes: {
        'homepage': (context) => const Homepage(),
        'mahasiswa_tambah': (context) => const MahasiswaTambah(),
      },
      initialRoute: 'homepage',
    );
  }
}
