import 'package:dartz/dartz.dart';
import 'package:earnings_tracker/core/constants/error/failure.dart';
import 'package:earnings_tracker/core/usecase/core_usecase.dart';
import 'package:earnings_tracker/features/tracker/domain/entities/earning_data_entity.dart';
import 'package:earnings_tracker/features/tracker/domain/repository/earnings_repository.dart';

class GetEarningsData implements CoreUsecases<List<EarningsDataEntity>, String> {
  final EarningsRepository earningsRepository;

  GetEarningsData(this.earningsRepository);
  @override
  Future<Either<Failure, List<EarningsDataEntity>>> call(String ticker) async {
    return await earningsRepository.getEarningsData(ticker: ticker);
  }
}
