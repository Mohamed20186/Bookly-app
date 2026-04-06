import 'package:flutter/widgets.dart';
import 'package:test_app/features/home/presentation/views/widgets/best_book_seller_card_view.dart';

class BookListViewBestSeller extends StatelessWidget {
  const BookListViewBestSeller({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
