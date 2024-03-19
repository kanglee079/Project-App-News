import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0);
  return formatter.format(amount);
}
