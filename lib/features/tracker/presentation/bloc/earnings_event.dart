part of 'earnings_bloc.dart';

sealed class EarningsEvent extends Equatable {
  const EarningsEvent();

  @override
  List<Object> get props => [];
}

final class GetEarningsDataEvent extends EarningsEvent {
  final String ticker;
  const GetEarningsDataEvent(this.ticker);

  @override
  List<Object> get props => [ticker];
}

final class GetTranscriptEvent extends EarningsEvent {
  final String ticker;
  final int year;
  final int quarter;

  const GetTranscriptEvent(this.ticker, this.year, this.quarter);

  @override
  List<Object> get props => [ticker, year, quarter];
}
