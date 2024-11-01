import 'package:dartz/dartz.dart';
import 'package:earnings_tracker/core/constants/error/failure.dart';
import 'package:earnings_tracker/core/usecase/core_usecase.dart';
import 'package:earnings_tracker/features/tracker/domain/entities/transcript_entity.dart';
import 'package:earnings_tracker/features/tracker/domain/repository/earnings_repository.dart';

class GetTranscript implements CoreUsecases<TranscriptEntity, GetTranscriptParams> {
  final EarningsRepository earningsRepository;

  GetTranscript(this.earningsRepository);
  @override
  Future<Either<Failure, TranscriptEntity>> call(GetTranscriptParams input) async {
    return await earningsRepository.getTranscript(ticker: input.ticker, year: input.year, quarter: input.quarter);
  }
}

class GetTranscriptParams {
  final String ticker;
  final int year;
  final int quarter;

  GetTranscriptParams({required this.ticker, required this.year, required this.quarter});
}
