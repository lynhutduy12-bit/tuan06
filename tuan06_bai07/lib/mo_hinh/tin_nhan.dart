enum SmsGroup { quangCao, otp, khac }

class SmsItem {
  final String address;
  final String body;
  final DateTime date;

  SmsItem({required this.address, required this.body, required this.date});

  static final RegExp _otpReg = RegExp(r'\[OTP\]\D*(\d{6})(?!\d)');

  SmsGroup get group {
    if (body.trimLeft().startsWith('[QC]')) return SmsGroup.quangCao;
    if (_otpReg.hasMatch(body)) return SmsGroup.otp;
    return SmsGroup.khac;
  }

  String? get otpCode => _otpReg.firstMatch(body)?.group(1);
}
