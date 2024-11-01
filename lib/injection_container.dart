import 'package:earnings_tracker/features/tracker/data/remote_datasource/earning_data_source.dart';
import 'package:earnings_tracker/features/tracker/data/repository/earnings_repository_impl.dart';
import 'package:earnings_tracker/features/tracker/domain/repository/earnings_repository.dart';
import 'package:earnings_tracker/features/tracker/domain/usecases/get_earnings_data.dart';
import 'package:earnings_tracker/features/tracker/domain/usecases/get_transcript.dart';
import 'package:earnings_tracker/features/tracker/presentation/bloc/earnings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final httpClient = http.Client();
  sl.registerLazySingleton(() => httpClient);
  _initTracker();
}

Future<void> _initTracker() async {
  // Datasource
  sl
    ..registerFactory<EarningDataSource>(() => EarningDataSourceImpl(sl()))
    // Repository
    ..registerFactory<EarningsRepository>(() => EarningsRepositoryImpl(sl()))
    // Usecases
    ..registerFactory(() => GetEarningsData(sl()))
    ..registerFactory(() => GetTranscript(sl()))
    // Bloc
    ..registerLazySingleton(() => EarningsBloc(sl(), sl()));
}
