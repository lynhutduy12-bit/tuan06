import 'package:flutter/material.dart';

import '../mo_hinh/tin_nhan.dart';

String _two(int n) => n.toString().padLeft(2, '0');
String fmtDate(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';
String fmtMonth(DateTime d) => '${_two(d.month)}/${d.year}';
String fmtDateTime(DateTime d) =>
    '${fmtDate(d)} ${_two(d.hour)}:${_two(d.minute)}';

String groupName(SmsGroup g) {
  switch (g) {
    case SmsGroup.quangCao:
      return 'Quảng cáo';
    case SmsGroup.otp:
      return 'Mã OTP';
    case SmsGroup.khac:
      return 'Khác';
  }
}

IconData groupIcon(SmsGroup g) {
  switch (g) {
    case SmsGroup.quangCao:
      return Icons.campaign;
    case SmsGroup.otp:
      return Icons.lock;
    case SmsGroup.khac:
      return Icons.sms;
  }
}

Color groupColor(SmsGroup g) {
  switch (g) {
    case SmsGroup.quangCao:
      return Colors.orange;
    case SmsGroup.otp:
      return Colors.green;
    case SmsGroup.khac:
      return Colors.blueGrey;
  }
}
