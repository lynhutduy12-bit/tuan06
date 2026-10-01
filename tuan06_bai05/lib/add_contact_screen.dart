import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _avatar;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Chọn ảnh đại diện từ gallery hoặc camera
  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        _showMessage('Vui lòng cấp quyền camera!');
        return;
      }
    }
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() => _avatar = File(pickedFile.path));
    }
  }

  // Hiện menu chọn nguồn ảnh
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn ảnh từ Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh từ Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_avatar != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Xóa ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _avatar = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveContact() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    // Kiểm tra dữ liệu nhập
    if (name.isEmpty || phone.isEmpty) {
      _showMessage('Tên và số điện thoại không được để trống!');
      return;
    }
    if (email.isNotEmpty &&
        !RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$').hasMatch(email)) {
      _showMessage('Email không hợp lệ!');
      return;
    }

    setState(() => _isSaving = true);

    final contact = ContactInfo(
      displayName: name,
      givenName: name,
      phones: [ValueItem(label: 'mobile', value: phone)],
      emails: email.isNotEmpty ? [ValueItem(label: 'home', value: email)] : [],
      avatar: _avatar != null ? await _avatar!.readAsBytes() : null,
    );

    // Lưu danh bạ vào điện thoại
    try {
      await FlutterContactsService.addContact(contact);
      if (!mounted) return;
      _showMessage('Danh bạ đã được lưu thành công!');
      Navigator.pop(context, true); // trả về true để màn hình danh sách tải lại
    } catch (e) {
      _showMessage('Lỗi khi lưu danh bạ: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm danh bạ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImageSourceSheet,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
                child: _avatar == null
                    ? const Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveContact,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}