import 'package:flutter/material.dart';

import 'man_hinh/trang_chu.dart';

void main() => runApp(const SmsAnalyzerApp());

class SmsAnalyzerApp extends StatelessWidget {
  const SmsAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomePage(),
    );
  }
}
