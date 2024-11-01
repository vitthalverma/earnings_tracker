import 'package:dartz/dartz.dart';
import 'package:earnings_tracker/core/constants/error/failure.dart';
import 'package:earnings_tracker/features/tracker/domain/entities/earning_data_entity.dart';
import 'package:earnings_tracker/features/tracker/domain/entities/transcript_entity.dart';

abstract interface class EarningsRepository {
  Future<Either<Failure, List<EarningsDataEntity>>> getEarningsData({required String ticker});
  Future<Either<Failure, TranscriptEntity>> getTranscript({required String ticker, required int year, required int quarter});
}
