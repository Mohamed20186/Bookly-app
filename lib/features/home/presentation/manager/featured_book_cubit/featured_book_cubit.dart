import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_app/core/errors/Failure.dart';
import 'package:test_app/features/home/data/model/book_model.dart';
import 'package:test_app/features/home/data/repos/home_repo.dart';

part 'featured_book_state.dart';

class FeaturedBookCubit extends Cubit<FeaturedBookState> {
  final HomeRepo homeRepo;

  FeaturedBookCubit({required this.homeRepo}) : super(FeaturedBookInitial());

  Future<void> fetchFeaturedBooks() async {
    emit(FeaturedBookLoading());
    var result = await homeRepo.fetchfeaturedBooks();
    result.fold(
      (failure) => emit(FeaturedBookFailure(failure)),
      (books) => emit(FeaturedBookSuccess(books)),
    );  
  }
}
