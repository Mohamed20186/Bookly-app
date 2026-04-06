import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/widgets/custom_error_message.dart';
import 'package:test_app/features/home/presentation/manager/newset_books_cubit/newset_books_cubit.dart';
import 'package:test_app/features/home/presentation/views/widgets/best_book_seller_card_view.dart';

class BookListViewBestSeller extends StatelessWidget {
  const BookListViewBestSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsetBooksCubit, NewsetBooksState>(
      builder: (context, state) {
        if (state is NewsetBooksSuccess) {
          final bestSellers = state.books;
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: bestSellers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BestSellerBookCard(
                  book: bestSellers[index],
                  animationDelay: Duration(milliseconds: index * 80),
                ),
              );
            },
          );
        } else if (state is NewsetBooksFailure) {
          return ErrorMessageWidget(message: state.failure.errorMessage);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
