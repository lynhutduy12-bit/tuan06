import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

// Dùng Scaffold trực tiếp (không bọc MaterialApp lần 2) để có nút Back trên AppBar
class ContactsReaderApp extends StatefulWidget {
  const ContactsReaderApp({super.key});

  @override
  State<ContactsReaderApp> createState() => _ContactsReaderAppState();
}

class _ContactsReaderAppState extends State<ContactsReaderApp> {
  List<ContactInfo> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  // Xin quyền đọc danh bạ
  Future<void> _initializePermissions() async {
    final status = await Permission.contacts.request();
    if (!mounted) return;

    if (status.isGranted) {
      await _loadContacts();
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng cấp quyền để đọc danh bạ!')),
      );
    }
  }

  // Lấy danh bạ từ điện thoại
  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final List<ContactInfo> contacts =
        await FlutterContactsService.getContacts();
    if (!mounted) return;
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  // Lấy số điện thoại đầu tiên (an toàn với null)
  String _firstPhone(ContactInfo c) {
    final phones = c.phones;
    if (phones == null || phones.isEmpty) return 'Không có số';
    return phones.first.value ?? 'Không có số';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Reader')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(child: Text('Không có danh bạ nào.'))
          : RefreshIndicator(
              onRefresh: _loadContacts,
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(contact.displayName ?? 'Không có tên'),
                    subtitle: Text(_firstPhone(contact)),
                  );
                },
              ),
            ),
    );
  }
}
