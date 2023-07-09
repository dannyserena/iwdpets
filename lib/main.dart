import 'package:flutter/material.dart';
import 'package:iwdpets/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WTM Lauro de Freitas',
      theme: _buildTheme(),
      home: const HomePage(),
    );
  }

  _buildTheme() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF6B317),
      brightness: Brightness.light,
      primaryColor: const Color(0xFFF6B317),
      primarySwatch: Colors.cyan,
    );
  }
}
