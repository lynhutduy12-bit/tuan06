import 'package:flutter/material.dart';
import 'contacts_list_screen.dart';

void main() {
  runApp(const ContactManagerApp());
}

class ContactManagerApp extends StatelessWidget {
  const ContactManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý danh bạ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const ContactsListScreen(),
    );
  }
}