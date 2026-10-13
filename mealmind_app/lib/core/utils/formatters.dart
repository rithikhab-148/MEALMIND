import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
    locale: 'en_IN',
  );

  static final NumberFormat _currencyDecimalFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 2,
    locale: 'en_IN',
  );

  static final NumberFormat _numberFormat = NumberFormat('#,##0.#');

  static String formatCurrency(double amount, {bool showDecimals = false}) {
    if (showDecimals) {
      return _currencyDecimalFormat.format(amount);
    }
    return _currencyFormat.format(amount);
  }

  static String formatWeight(double weight, {String unit = 'kg'}) {
    return '${_numberFormat.format(weight)} $unit';
  }

  static String formatPercentage(double pct) {
    return '${pct.toStringAsFixed(1)}%';
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEE, d MMM yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
}
