import 'package:flutter/material.dart';
import 'package:test_app/core/utils/constant.dart';
import 'package:test_app/features/home/presentation/views/widgets/image_card.dart';

class BookListView extends StatelessWidget {
  const BookListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) =>
              const ImageCard(imageUrl: Constant.testImage),
          itemCount: 10,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
