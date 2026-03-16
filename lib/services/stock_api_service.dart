import 'package:dio/dio.dart';
import '../models/stock.dart';
import '../utils/constants.dart';

class StockApiService {
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
    },
  ));

  // Fetches current real-time stock price from Yahoo Finance
  Future<double> fetchCurrentPrice(String symbol) async {
    try {
      final response = await _dio.get(
        '${Constants.yahooFinanceQuoteUrl}/$symbol',
        queryParameters: {
          'interval': '1d',
          'range': '1d',
        },
      );

      final data = response.data;
      if (data != null && data['chart'] != null && data['chart']['result'] != null) {
        final result = data['chart']['result'][0];
        if (result['meta'] != null && result['meta']['regularMarketPrice'] != null) {
          return double.parse(result['meta']['regularMarketPrice'].toString());
        }
      }
      return 0.0;
    } catch (e) {
      print('Error fetching real-time price for $symbol: $e');
      return 0.0;
    }
  }

  // Search for stocks manually via Yahoo Finance
  Future<List<Stock>> searchStock(String keyword) async {
    try {
      final response = await _dio.get(
        Constants.yahooFinanceSearchUrl,
        queryParameters: {
          'q': keyword,
          'quotesCount': 5,
          'newsCount': 0,
        },
      );

      final data = response.data;
      if (data != null && data['quotes'] != null) {
        final matches = data['quotes'] as List;
        return matches.map<Stock>((json) {
          return Stock(
            symbol: json['symbol'] ?? '',
            name: json['shortname'] ?? json['longname'] ?? json['symbol'] ?? '',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error searching stocks: $e');
      return [];
    }
  }
}
