import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_app/features/home/data/model/book_model.dart';
import 'package:test_app/features/home/data/repos/home_repo.dart';

import '../../../../../core/errors/Failure.dart';

part 'newset_books_state.dart';

class NewsetBooksCubit extends Cubit<NewsetBooksState> {
  final HomeRepo homeRepo;

  NewsetBooksCubit(this.homeRepo) : super(NewsetBooksInitial());

  Future<void> fetchNewsetBooks() async {
    emit(NewsetBooksLoading());
    var result = await homeRepo.fetchNewsetBooks();
    result.fold(
      (failure) => emit(NewsetBooksFailure(failure)),
      (books) => emit(NewsetBooksSuccess(books)),
    );
  }
}
