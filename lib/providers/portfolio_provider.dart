import 'package:flutter/material.dart';
import '../models/portfolio_item.dart';
import '../models/stock.dart';
import '../services/esg_api_service.dart';
import '../services/stock_api_service.dart';

class PortfolioProvider extends ChangeNotifier {
  final StockApiService _stockApi = StockApiService();
  final EsgApiService _esgApi = EsgApiService();

  List<PortfolioItem> _portfolio = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDarkMode = false;

  List<PortfolioItem> get portfolio => _portfolio;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isDarkMode => _isDarkMode;

  // Portfolio calculations
  double get totalPortfolioValue {
    return _portfolio.fold(0.0, (sum, item) => sum + item.totalValue);
  }

  double get totalCo2Emissions {
    return _portfolio.fold(0.0, (sum, item) => sum + item.totalCo2Emissions);
  }

  double get portfolioGreenScore {
    if (_portfolio.isEmpty) return 0.0;
    
    double totalVal = totalPortfolioValue;
    
    if (totalVal == 0) {
      // If portfolio has 0 value, return a neutral score or straight average
      return _portfolio.fold(0.0, (sum, item) => sum + (item.esgData?.esgScore ?? 0)) / _portfolio.length;
    }

    double totalWeightedEmissions = 0;
    for (var item in _portfolio) {
      final valueWeight = item.totalValue / totalVal;
      totalWeightedEmissions += (item.esgData?.co2Emissions ?? 0) * valueWeight;
    }

    // Calculate overall sustainability score based on the portfolio’s weighted emissions
    // Base scale: 0 emissions = 100 score, 10000+ emissions = 0 score
    double score = 100 - (totalWeightedEmissions / 100);
    return score.clamp(0.0, 100.0);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> addStock(Stock stock, int quantity) async {
    _setLoading(true);
    _clearError();

    try {
      // Check if stock already exists in portfolio
      final existingIndex = _portfolio.indexWhere((item) => item.symbol == stock.symbol);

      if (existingIndex >= 0) {
        // Just update quantity
        _portfolio[existingIndex] = PortfolioItem(
          symbol: _portfolio[existingIndex].symbol,
          quantity: _portfolio[existingIndex].quantity + quantity,
          currentPrice: _portfolio[existingIndex].currentPrice,
          esgData: _portfolio[existingIndex].esgData,
        );
      } else {
        // Fetch new data
        final currentPrice = await _stockApi.fetchCurrentPrice(stock.symbol);
        final esgData = await _esgApi.fetchEsgData(stock.symbol);

        final newItem = PortfolioItem(
          symbol: stock.symbol,
          quantity: quantity,
          currentPrice: currentPrice,
          esgData: esgData,
        );
        _portfolio.add(newItem);
      }
    } catch (e) {
      _errorMessage = 'Failed to add stock: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeStock(String symbol) async {
    _portfolio.removeWhere((item) => item.symbol == symbol);
    notifyListeners();
  }

  Future<void> refreshPortfolio() async {
    if (_portfolio.isEmpty) return;
    
    _setLoading(true);
    _clearError();

    try {
      List<PortfolioItem> updated = [];
      for (var item in _portfolio) {
        final currentPrice = await _stockApi.fetchCurrentPrice(item.symbol);
        // We could refresh ESG data too but usually it changes slowly. 
        // We will just refresh price for performance.
        updated.add(
          PortfolioItem(
            symbol: item.symbol,
            quantity: item.quantity,
            currentPrice: currentPrice,
            esgData: item.esgData,
          )
        );
      }
      _portfolio = updated;
    } catch (e) {
      _errorMessage = 'Failed to refresh portfolio: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Stock>> searchStock(String keyword) async {
    _clearError();
    try {
      return await _stockApi.searchStock(keyword);
    } catch (e) {
      _errorMessage = 'Failed to search stock: $e';
      notifyListeners();
      return [];
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    // Don't notify here to prevent unnecessary rebuilds, will notify in finally block
  }
}
