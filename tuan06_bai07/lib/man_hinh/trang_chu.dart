import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

import '../du_lieu/du_lieu_mau.dart';
import '../mo_hinh/tin_nhan.dart';
import 'tab_loc_theo_so.dart';
import 'tab_nhom_tin.dart';
import 'tab_thong_ke.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SmsItem> _messages = [];
  bool _loading = true;
  String? _error;
  bool _isDemo = false;

  @override
  void initState() {
    super.initState();
    _loadSms();
  }

  Future<void> _loadSms() async {
    setState(() {
      _loading = true;
      _error = null;
      _isDemo = false;
    });
    try {
      final status = await Permission.sms.request();
      if (!status.isGranted) {
        setState(() {
          _loading = false;
          _error = 'Ứng dụng chưa được cấp quyền đọc tin nhắn.';
        });
        return;
      }
      final query = SmsQuery();
      final raw = await query.querySms(kinds: [SmsQueryKind.inbox]);
      final list =
          raw
              .map(
                (m) => SmsItem(
                  address: m.address ?? 'Không rõ',
                  body: m.body ?? '',
                  date: m.date ?? DateTime.now(),
                ),
              )
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
      setState(() {
        _messages = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Lỗi đọc tin nhắn: $e';
      });
    }
  }

  void _useDemo() {
    setState(() {
      _messages = demoMessages()..sort((a, b) => b.date.compareTo(a.date));
      _isDemo = true;
      _error = null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isDemo ? 'SMS Analyzer (dữ liệu mẫu)' : 'SMS Analyzer'),
          actions: [
            IconButton(
              tooltip: 'Tải lại tin nhắn',
              icon: const Icon(Icons.refresh),
              onPressed: _loadSms,
            ),
            IconButton(
              tooltip: 'Dùng dữ liệu mẫu',
              icon: const Icon(Icons.science),
              onPressed: _useDemo,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bar_chart), text: 'Thống kê'),
              Tab(icon: Icon(Icons.phone), text: 'Theo số'),
              Tab(icon: Icon(Icons.filter_alt), text: 'Nhóm tin'),
            ],
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56, color: Colors.red),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadSms,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
              TextButton(
                onPressed: openAppSettings,
                child: const Text('Mở cài đặt cấp quyền'),
              ),
              TextButton(
                onPressed: _useDemo,
                child: const Text('Dùng dữ liệu mẫu'),
              ),
            ],
          ),
        ),
      );
    }
    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Hộp thư đến không có tin nhắn nào.'),
            TextButton(
              onPressed: _useDemo,
              child: const Text('Dùng dữ liệu mẫu'),
            ),
          ],
        ),
      );
    }
    return TabBarView(
      children: [
        StatsTab(messages: _messages),
        FilterByPhoneTab(messages: _messages),
        GroupTab(messages: _messages),
      ],
    );
  }
}
