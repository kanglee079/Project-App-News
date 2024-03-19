import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/current_exchange_price.dart';

Future<CurrencyExchangeRate> fetchExchangeRates() async {
  const String apiUrl =
      'https://api.metalpriceapi.com/v1/latest?api_key=2f91f7258e1441a9d18245fb772df6fd&base=USD&currencies=VND,XAU,XAG';
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return CurrencyExchangeRate.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load exchange rates');
  }
}
