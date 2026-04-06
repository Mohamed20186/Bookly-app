import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/utils/app_router.dart';
import 'package:test_app/core/utils/color_palette.dart';
import 'package:test_app/core/utils/service_locator.dart';
import 'package:test_app/features/home/data/repos/home_repo_imp.dart';
import 'package:test_app/features/home/presentation/manager/featured_book_cubit/featured_book_cubit.dart'
    show FeaturedBookCubit;
import 'package:test_app/features/home/presentation/manager/newset_books_cubit/newset_books_cubit.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FeaturedBookCubit(homeRepo: getIt.get<HomeRepoImp>()),
        ),
        BlocProvider(
          create: (context) => NewsetBooksCubit(getIt.get<HomeRepoImp>()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
        title: 'Cosmic Counter',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColor.backgroundDark,
        ),
      ),
    );
  }
}
