import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mo_hinh/tin_nhan.dart';
import '../tien_ich/tien_ich_sms.dart';

void showOtpDialog(BuildContext context, SmsItem item) {
  final code = item.otpCode ?? '------';
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.lock, color: Colors.green),
          SizedBox(width: 8),
          Text('Mã OTP'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Từ: ${item.address}'),
          Text(fmtDateTime(item.date), style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.body,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.copy),
          label: const Text('Sao chép'),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));
            Navigator.pop(ctx);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Đã sao chép mã $code')));
          },
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}
