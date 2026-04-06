import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/utils/constant.dart';
import 'package:test_app/core/widgets/book_List_shimmer.dart';
import 'package:test_app/features/home/presentation/manager/featured_book_cubit/featured_book_cubit.dart';
import 'package:test_app/features/home/presentation/views/widgets/image_card.dart';
import 'package:test_app/core/widgets/custom_error_message.dart'
    show ErrorMessageWidget;

class BookListView extends StatelessWidget {
  const BookListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturedBookCubit, FeaturedBookState>(
      builder: (context, state) {
        if (state is FeaturedBookSuccess) {
          return SizedBox(
            height: 250,
            child: Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    ImageCard(imageUrl: state.books[index].coverUrl),
                itemCount: 10,
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
        } else if (state is FeaturedBookFailure) {
          return ErrorMessageWidget(message: state.failure.errorMessage);
        } else {
          return const BookListShimmer();
        }
      },
    );
  }
}
