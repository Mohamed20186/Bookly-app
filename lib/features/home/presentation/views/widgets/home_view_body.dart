import 'package:flutter/material.dart';
import 'package:test_app/core/utils/color_palette.dart';
import 'package:test_app/core/utils/styles.dart' show Styles;

import 'book_List_view_best_seller.dart';
import 'book_list_view.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6),
        BookListView(),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Best Seller',
            style: Styles.titleMedium.copyWith(
              color: AppColor.ceriseRed,
              fontFamily: 'Georgia',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(child: BookListViewBestSeller()),
      ],
    );
  }
}
