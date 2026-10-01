import 'package:flutter/material.dart';

import '../mo_hinh/tin_nhan.dart';
import '../tien_ich/tien_ich_sms.dart';

class MessageTile extends StatelessWidget {
  final SmsItem item;
  final VoidCallback? onTap;
  const MessageTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final g = item.group;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: groupColor(g),
          child: Icon(groupIcon(g), color: groupColor(g)),
        ),
        title: Text(
          item.address,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text(
          fmtDateTime(item.date),
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }
}
