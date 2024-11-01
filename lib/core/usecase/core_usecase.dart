import 'package:dartz/dartz.dart';
import 'package:earnings_tracker/core/constants/error/failure.dart';

abstract class CoreUsecases<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params input);
}

class NoParams {}
