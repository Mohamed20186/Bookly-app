import 'package:dartz/dartz.dart';
import 'package:test_app/core/errors/Failure.dart';
import '../model/book_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<BookModel>>> fetchNewsetBooks();
  Future<Either<Failure, List<BookModel>>> fetchfeaturedBooks();
}
