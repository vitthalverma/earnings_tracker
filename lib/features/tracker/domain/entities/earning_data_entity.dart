class EarningsDataEntity {
  final String ticker;
  final DateTime pricedate;
  final double estimatedRevenue;
  final double actualRevenue;

  EarningsDataEntity({
    required this.ticker,
    required this.pricedate,
    required this.estimatedRevenue,
    required this.actualRevenue,
  });
}
