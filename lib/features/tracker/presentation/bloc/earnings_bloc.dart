import 'package:earnings_tracker/features/tracker/domain/entities/earning_data_entity.dart';
import 'package:earnings_tracker/features/tracker/domain/entities/transcript_entity.dart';
import 'package:earnings_tracker/features/tracker/domain/usecases/get_earnings_data.dart';
import 'package:earnings_tracker/features/tracker/domain/usecases/get_transcript.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'earnings_event.dart';
part 'earnings_state.dart';

class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  final GetEarningsData getEarningsData;
  final GetTranscript getTranscript;
  EarningsBloc(this.getEarningsData, this.getTranscript) : super(EarningsInitial()) {
    on<GetEarningsDataEvent>((event, emit) async {
      emit(EarningsLoading());
      final result = await getEarningsData(event.ticker);
      result.fold(
        (error) => emit(EarningsError(error.message)),
        (earnings) => emit(EarningsLoaded(earnings)),
      );
    });

    on<GetTranscriptEvent>((event, emit) async {
      emit(TranscriptLoading());
      final result = await getTranscript(GetTranscriptParams(
        ticker: event.ticker,
        year: event.year,
        quarter: event.quarter,
      ));
      result.fold(
        (error) => emit(TranscriptError(error.message)),
        (transcript) => emit(TranscriptLoaded(transcript)),
      );
    });
  }
}
