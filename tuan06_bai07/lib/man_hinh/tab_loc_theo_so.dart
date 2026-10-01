import 'package:flutter/material.dart';

import '../mo_hinh/tin_nhan.dart';
import '../thanh_phan/o_tin_nhan.dart';

class FilterByPhoneTab extends StatefulWidget {
  final List<SmsItem> messages;
  const FilterByPhoneTab({super.key, required this.messages});

  @override
  State<FilterByPhoneTab> createState() => _FilterByPhoneTabState();
}

class _FilterByPhoneTabState extends State<FilterByPhoneTab> {
  final _controller = TextEditingController();
  String _keyword = '';

  String _normalize(String s) =>
      s.replaceAll(RegExp(r'[\s\-\.]'), '').toLowerCase();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> senders = {};
    for (final m in widget.messages) {
      senders[m.address] = (senders[m.address] ?? 0) + 1;
    }
    final sortedSenders = senders.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final filtered = _keyword.isEmpty
        ? <SmsItem>[]
        : widget.messages
              .where(
                (m) => _normalize(m.address).contains(_normalize(_keyword)),
              )
              .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Nhập số điện thoại / tên người gửi',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: _keyword.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _keyword = '');
                      },
                    ),
            ),
            onChanged: (v) => setState(() => _keyword = v.trim()),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: sortedSenders
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      label: Text('${e.key} (${e.value})'),
                      onPressed: () {
                        _controller.text = e.key;
                        setState(() => _keyword = e.key);
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const Divider(),
        Expanded(
          child: _keyword.isEmpty
              ? const Center(
                  child: Text('Nhập hoặc chọn một số để lọc tin nhắn'),
                )
              : filtered.isEmpty
              ? const Center(child: Text('Không có tin nhắn từ số này'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Tìm thấy ${filtered.length} tin nhắn',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => MessageTile(item: filtered[i]),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
