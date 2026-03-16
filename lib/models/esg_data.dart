class EsgData {
  final int esgScore;
  final String rating;
  final double co2Emissions;

  EsgData({
    required this.esgScore,
    required this.rating,
    required this.co2Emissions,
  });

  factory EsgData.fromJson(Map<String, dynamic> json) {
    return EsgData(
      esgScore: json['esgScore'] ?? 50,
      rating: json['rating'] ?? 'B',
      co2Emissions: json['co2Emissions']?.toDouble() ?? 1000.0,
    );
  }
}
