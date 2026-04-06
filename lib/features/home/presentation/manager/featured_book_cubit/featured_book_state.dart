part of 'featured_book_cubit.dart';

@immutable
sealed class FeaturedBookState {}

final class FeaturedBookInitial extends FeaturedBookState {}

final class FeaturedBookLoading extends FeaturedBookState {}

final class FeaturedBookFailure extends FeaturedBookState {
  final Failure failure;

  FeaturedBookFailure(this.failure);
}

final class FeaturedBookSuccess extends FeaturedBookState {
  final List<BookModel> books;

  FeaturedBookSuccess(this.books);
}
