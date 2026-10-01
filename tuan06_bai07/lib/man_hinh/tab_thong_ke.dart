import 'package:flutter/material.dart';

import '../mo_hinh/tin_nhan.dart';
import '../tien_ich/tien_ich_sms.dart';

class StatsTab extends StatefulWidget {
  final List<SmsItem> messages;
  const StatsTab({super.key, required this.messages});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  bool _byMonth = false;

  @override
  Widget build(BuildContext context) {
    final msgs = widget.messages;
    final qc = msgs.where((m) => m.group == SmsGroup.quangCao).length;
    final otp = msgs.where((m) => m.group == SmsGroup.otp).length;
    final other = msgs.length - qc - otp;

    final Map<String, int> counts = {};
    for (final m in msgs) {
      final key = _byMonth ? fmtMonth(m.date) : fmtDate(m.date);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final maxCount = counts.values.isEmpty
        ? 1
        : counts.values.reduce((a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Tổng số tin nhắn nhận được',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '${msgs.length}',
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _miniCard(SmsGroup.quangCao, qc),
            _miniCard(SmsGroup.otp, otp),
            _miniCard(SmsGroup.khac, other),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Thống kê theo thời gian',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Ngày')),
                ButtonSegment(value: true, label: Text('Tháng')),
              ],
              selected: {_byMonth},
              onSelectionChanged: (s) => setState(() => _byMonth = s.first),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...counts.entries.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 95,
                  child: Text(
                    e.key,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: e.value / maxCount,
                      minHeight: 14,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text('${e.value} tin', textAlign: TextAlign.right),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniCard(SmsGroup g, int count) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(groupIcon(g), color: groupColor(g)),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(groupName(g), style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
