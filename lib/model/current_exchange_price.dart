class CurrencyExchangeRate {
  final bool success;
  final String base;
  final int timestamp;
  final Map<String, double> rates;

  CurrencyExchangeRate(
      {required this.success,
      required this.base,
      required this.timestamp,
      required this.rates});

  factory CurrencyExchangeRate.fromJson(Map<String, dynamic> json) {
    var ratesMap = json['rates'] as Map<String, dynamic>;
    Map<String, double> rates =
        ratesMap.map((key, value) => MapEntry(key, value.toDouble()));
    return CurrencyExchangeRate(
      success: json['success'],
      base: json['base'],
      timestamp: json['timestamp'],
      rates: rates,
    );
  }
}
