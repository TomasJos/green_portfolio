import 'esg_data.dart';

class PortfolioItem {
  final String symbol;
  final int quantity;
  double currentPrice;
  EsgData? esgData;

  PortfolioItem({
    required this.symbol,
    required this.quantity,
    this.currentPrice = 0.0,
    this.esgData,
  });

  double get totalValue => currentPrice * quantity;
  double get totalCo2Emissions => (esgData?.co2Emissions ?? 0) * quantity;
  
  // Note: To make an app realistic, ESG score logic might just be the average or base
  // score of the company, but emissions multiply by quantity of shares.
}
