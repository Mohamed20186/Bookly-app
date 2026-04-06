import 'package:flutter/material.dart';
import 'package:test_app/core/utils/color_palette.dart';
import 'package:test_app/features/home/presentation/views/widgets/bookly_app_bar.dart';
import 'package:test_app/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundDeep,
      appBar: const BooklyAppBar(),
      body: const HomeViewBody(),
    );
  }
}
