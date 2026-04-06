import 'package:dartz/dartz.dart';

import 'package:test_app/core/errors/Failure.dart';
import 'package:test_app/core/errors/error_handler.dart';
import 'package:test_app/core/utils/api_service.dart';

import 'package:test_app/features/home/data/model/book_model.dart';

import 'home_repo.dart';

class HomeRepoImp implements HomeRepo {
  final ApiService apiService;

  HomeRepoImp(this.apiService);
  @override
  Future<Either<Failure, List<BookModel>>> fetchNewsetBooks() async {
    try {
      var data = await apiService.get(
        endpoint: "volumes?",
        queryParameters: {
          'q': 'subject:Programming',
          'orderBy': 'relevance',
          'sorqedBy': 'newest',
        },
      );
      List<BookModel> books = [];
      for (var item in data['items']) {
        books.add(BookModel.fromJson(item, 1));
      }
      return Right(books);
    } on Exception catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> fetchfeaturedBooks() async {
    try {
      var data = await apiService.get(
        endpoint: "volumes?",
        queryParameters: {'q': 'subject:new', 'orderBy': 'relevance'},
      );
      List<BookModel> books = [];
      for (var item in data['items']) {
        books.add(BookModel.fromJson(item, 1));
      }
      return Right(books);
    } on Exception catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
