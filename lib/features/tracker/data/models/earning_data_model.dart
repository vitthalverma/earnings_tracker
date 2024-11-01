import 'package:earnings_tracker/features/tracker/domain/entities/earning_data_entity.dart';

class EarningsDataModel extends EarningsDataEntity {
  EarningsDataModel({
    required super.ticker,
    required super.pricedate,
    required super.actualRevenue,
    required super.estimatedRevenue,
  });

  factory EarningsDataModel.fromJson(Map<String, dynamic> json) {
    return EarningsDataModel(
      ticker: json['ticker'],
      pricedate: DateTime.parse(json['pricedate']),
      actualRevenue: (json['actual_revenue'] as num).toDouble(), // Ensure double
      estimatedRevenue: (json['estimated_revenue'] as num).toDouble(), // Ensure double
    );
  }
}
