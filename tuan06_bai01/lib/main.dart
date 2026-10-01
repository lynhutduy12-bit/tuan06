import 'package:flutter/material.dart';

import 'media_picker_home.dart';

void main() {
  runApp(const MediaPickerApp());
}

class MediaPickerApp extends StatelessWidget {
  const MediaPickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Picker App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MediaPickerHome(),
    );
  }
}
