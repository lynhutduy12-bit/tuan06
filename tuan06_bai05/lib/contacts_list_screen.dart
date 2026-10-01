import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'add_contact_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<ContactInfo> _contacts = [];
  bool _isLoading = true;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _initPermissionAndLoad();
  }

  // Xin quyền danh bạ rồi mới tải danh sách
  Future<void> _initPermissionAndLoad() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      _permissionDenied = false;
      await _loadContacts();
    } else {
      setState(() {
        _isLoading = false;
        _permissionDenied = true;
      });
    }
  }

  // Lấy danh bạ trên điện thoại (gồm cả danh bạ người dùng tự thêm)
  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final contacts = await FlutterContactsService.getContacts();
    contacts.sort((a, b) => (a.displayName ?? '')
        .toLowerCase()
        .compareTo((b.displayName ?? '').toLowerCase()));
    if (!mounted) return;
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  Future<void> _openAddScreen() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );
    if (added == true) {
      _loadContacts(); // Làm mới danh sách sau khi thêm
    }
  }

  String _firstPhone(ContactInfo c) =>
      (c.phones != null && c.phones!.isNotEmpty)
          ? (c.phones!.first.value ?? 'Không có số')
          : 'Không có số';

  String _firstEmail(ContactInfo c) =>
      (c.emails != null &&
              c.emails!.isNotEmpty &&
              (c.emails!.first.value ?? '').isNotEmpty)
          ? c.emails!.first.value!
          : 'Không có email';

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ứng dụng cần quyền truy cập danh bạ.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                if (await Permission.contacts.isPermanentlyDenied) {
                  await openAppSettings();
                } else {
                  await _initPermissionAndLoad();
                }
              },
              child: const Text('Cấp quyền'),
            ),
          ],
        ),
      );
    }
    if (_contacts.isEmpty) {
      return const Center(child: Text('Không có danh bạ nào.'));
    }
    return RefreshIndicator(
      onRefresh: _loadContacts,
      child: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          final hasAvatar =
              contact.avatar != null && contact.avatar!.isNotEmpty;
          final name = contact.displayName ?? 'Không có tên';
          return ListTile(
            leading: hasAvatar
                ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar!))
                : CircleAvatar(
                    child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
                  ),
            title: Text(name),
            subtitle: Text('${_firstPhone(contact)}\n${_firstEmail(contact)}'),
            isThreeLine: true,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh bạ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm danh bạ',
            onPressed: _permissionDenied ? null : _openAddScreen,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}