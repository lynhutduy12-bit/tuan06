import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsReaderApp extends StatefulWidget {
  const SmsReaderApp({super.key});

  @override
  State<SmsReaderApp> createState() => _SmsReaderAppState();
}

class _SmsReaderAppState extends State<SmsReaderApp> {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  // Xin quyền đọc SMS
  Future<void> _initializePermissions() async {
    final statuses = await [Permission.sms, Permission.phone].request();
    if (!mounted) return;

    if (statuses[Permission.sms]?.isGranted ?? false) {
      await _loadMessages();
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng cấp quyền để đọc tin nhắn SMS!'),
        ),
      );
    }
  }

  // Lấy tin nhắn trong hộp thư đến, mới nhất lên đầu
  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    final List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY,
        SmsColumn.DATE,
        SmsColumn.TYPE,
      ],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );
    if (!mounted) return;
    setState(() {
      _messages = messages;
      _isLoading = false;
    });
  }

  String _formatDate(int? millis) {
    if (millis == null) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(millis);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS Reader')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _messages.isEmpty
          ? const Center(child: Text('Không có tin nhắn nào.'))
          : RefreshIndicator(
              onRefresh: _loadMessages,
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ListTile(
                    leading: const Icon(Icons.sms),
                    title: Text(message.body ?? 'Không có nội dung'),
                    subtitle: Text(
                      'Từ: ${message.address ?? 'Không rõ'}  •  ${_formatDate(message.date)}',
                    ),
                  );
                },
              ),
            ),
    );
  }
}
