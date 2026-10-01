import '../mo_hinh/tin_nhan.dart';

List<SmsItem> demoMessages() {
  final now = DateTime.now();
  return [
    SmsItem(
      address: 'VCB',
      body:
          '[OTP] 482915 la ma xac thuc giao dich cua Quy khach. Khong chia se ma nay.',
      date: now.subtract(const Duration(minutes: 5)),
    ),
    SmsItem(
      address: 'Shopee',
      body: '[QC] Sieu sale 10.10 - Giam den 50% toan bo don hang. Mua ngay!',
      date: now.subtract(const Duration(hours: 2)),
    ),
    SmsItem(
      address: '0909123456',
      body: 'Toi nay di an com khong?',
      date: now.subtract(const Duration(hours: 5)),
    ),
    SmsItem(
      address: 'Techcombank',
      body: '[OTP] Ma OTP cua ban la 731046, hieu luc trong 3 phut.',
      date: now.subtract(const Duration(days: 1)),
    ),
    SmsItem(
      address: 'Viettel',
      body: '[QC] Dang ky goi ST90 nhan ngay 90GB data. Soan ST90 gui 191.',
      date: now.subtract(const Duration(days: 1, hours: 3)),
    ),
    SmsItem(
      address: '0909123456',
      body: 'Nho mang bao cao nhom 7 nhe.',
      date: now.subtract(const Duration(days: 2)),
    ),
    SmsItem(
      address: '0912345678',
      body: 'Chieu nay hop nhom luc 3h.',
      date: now.subtract(const Duration(days: 3)),
    ),
    SmsItem(
      address: 'Grab',
      body: '[QC] Nhap ma GRAB20 giam 20K cho chuyen di dau tien.',
      date: now.subtract(const Duration(days: 35)),
    ),
    SmsItem(
      address: 'MoMo',
      body: '[OTP] 905512 la ma OTP dang nhap MoMo.',
      date: now.subtract(const Duration(days: 40)),
    ),
    SmsItem(
      address: '0912345678',
      body: 'Cam on ban nhieu!',
      date: now.subtract(const Duration(days: 41)),
    ),
  ];
}
