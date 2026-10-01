import 'package:flutter/material.dart';

import '../mo_hinh/tin_nhan.dart';
import '../thanh_phan/o_tin_nhan.dart';
import '../thanh_phan/hop_thoai_otp.dart';

class GroupTab extends StatefulWidget {
  final List<SmsItem> messages;
  const GroupTab({super.key, required this.messages});

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  SmsGroup? _selected = SmsGroup.quangCao;

  @override
  Widget build(BuildContext context) {
    final list = _selected == null
        ? widget.messages
        : widget.messages.where((m) => m.group == _selected).toList();

    Widget chip(String label, SmsGroup? g) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: _selected == g,
        onSelected: (_) => setState(() => _selected = g),
      ),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              chip('Tất cả', null),
              chip('Quảng cáo [QC]', SmsGroup.quangCao),
              chip('OTP', SmsGroup.otp),
            ],
          ),
        ),
        if (_selected == SmsGroup.otp)
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              'Chạm vào tin nhắn để lấy mã OTP',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        Expanded(
          child: list.isEmpty
              ? const Center(child: Text('Không có tin nhắn thuộc nhóm này'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final item = list[i];
                    return MessageTile(
                      item: item,
                      onTap: item.group == SmsGroup.otp
                          ? () => showOtpDialog(context, item)
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
