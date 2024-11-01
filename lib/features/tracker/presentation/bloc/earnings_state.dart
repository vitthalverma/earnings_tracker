part of 'earnings_bloc.dart';

sealed class EarningsState extends Equatable {
  const EarningsState();

  @override
  List<Object> get props => [];
}

final class EarningsInitial extends EarningsState {}

final class EarningsLoading extends EarningsState {}

final class EarningsLoaded extends EarningsState {
  final List<EarningsDataEntity> earnings;
  const EarningsLoaded(this.earnings);

  @override
  List<Object> get props => [earnings];
}

final class EarningsError extends EarningsState {
  final String error;
  const EarningsError(this.error);

  @override
  List<Object> get props => [error];
}

final class TranscriptError extends EarningsState {
  final String error;
  const TranscriptError(this.error);

  @override
  List<Object> get props => [error];
}

final class TranscriptLoading extends EarningsState {}

final class TranscriptLoaded extends EarningsState {
  final TranscriptEntity transcript;
  const TranscriptLoaded(this.transcript);

  @override
  List<Object> get props => [transcript];
}
