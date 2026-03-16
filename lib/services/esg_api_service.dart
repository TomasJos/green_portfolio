import 'dart:math';
import 'package:dio/dio.dart';
import '../models/esg_data.dart';
import '../utils/constants.dart';

class EsgApiService {
  final Dio _dio = Dio();

  // Fetches real ESG data from ESG Enterprise (via RapidAPI)
  Future<EsgData> fetchEsgData(String symbol) async {
    try {
      if (Constants.esgApiKey == 'YOUR_RAPID_API_KEY_HERE') {
        print('ESG API Key not configured. Using fallback generated data for $symbol');
        return _generateFallbackEsgData(symbol);
      }

      final response = await _dio.get(
        Constants.esgApiBaseUrl,
        queryParameters: {'q': symbol},
        options: Options(
          headers: {
            'X-RapidAPI-Key': Constants.esgApiKey,
            'X-RapidAPI-Host': Constants.esgApiHost,
          },
        ),
      );

      final data = response.data;
      // Depending on actual ESG Enterprise JSON schema
      // Usually returns a list or an object with company esg score.
      if (data != null && data.isNotEmpty) {
        // Safe parsing example assuming standard structure:
        final companyData = data is List ? data.first : data;
        final esgScore = companyData['environment_score'] ?? companyData['esg_score'] ?? 50;
        final co2Emissions = companyData['ghg_emissions'] ?? 1000.0; // greenhouse gas emissions
        
        return EsgData(
          esgScore: (esgScore is num) ? esgScore.toInt() : 50,
          rating: _getRatingFromScore((esgScore is num) ? esgScore.toInt() : 50),
          co2Emissions: (co2Emissions is num) ? co2Emissions.toDouble() : 1000.0,
        );
      }
      
      return _generateFallbackEsgData(symbol);
    } catch (e) {
      print('Error fetching real ESG data for $symbol: $e. Using fallback.');
      return _generateFallbackEsgData(symbol);
    }
  }

  String _getRatingFromScore(int score) {
    if (score >= 80) return 'A';
    if (score >= 60) return 'B';
    if (score >= 40) return 'C';
    return 'D';
  }

  // Fallback if API key is not provided or fails
  EsgData _generateFallbackEsgData(String symbol) {
    final random = Random(symbol.hashCode);
    final esgScore = 30 + random.nextInt(60); 
    final co2Emissions = 100 + random.nextDouble() * 5000;

    return EsgData(
      esgScore: esgScore,
      rating: _getRatingFromScore(esgScore),
      co2Emissions: double.parse(co2Emissions.toStringAsFixed(2)),
    );
  }
}
