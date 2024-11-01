import 'package:dartz/dartz.dart';
import 'package:earnings_tracker/core/constants/error/api_exception.dart';
import 'package:earnings_tracker/core/constants/error/failure.dart';
import 'package:earnings_tracker/features/tracker/data/remote_datasource/earning_data_source.dart';
import 'package:earnings_tracker/features/tracker/domain/entities/earning_data_entity.dart';
import 'package:earnings_tracker/features/tracker/domain/entities/transcript_entity.dart';
import 'package:earnings_tracker/features/tracker/domain/repository/earnings_repository.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  final EarningDataSource earningDataSource;

  EarningsRepositoryImpl(this.earningDataSource);
  @override
  Future<Either<Failure, List<EarningsDataEntity>>> getEarningsData({required String ticker}) async {
    try {
      final earnings = await earningDataSource.getEarningsData(ticker: ticker);
      if (earnings.isEmpty) {
        return Left(Failure('No earnings data found'));
      }
      return Right(earnings);
    } on ApiException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, TranscriptEntity>> getTranscript({required String ticker, required int year, required int quarter}) async {
    try {
      final transcript = await earningDataSource.getTranscript(ticker: ticker, year: year, quarter: quarter);
      return Right(transcript);
    } on ApiException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
