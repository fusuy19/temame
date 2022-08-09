import 'package:dersasistan/AnaSayfa/LevelGirisSayfasi.dart';
import 'package:dersasistan/AnaSayfa/OyunModuSecimi.dart';
import 'package:dersasistan/AyarSayfasi.dart';
import 'package:dersasistan/deneme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'VeriTabani/Database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {});
  runApp(new MediaQuery(data: new MediaQueryData(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeMaMe',
      theme: ThemeData(
        textTheme: GoogleFonts.basicTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: OyunModuSecimi(),
    );
  }
}
