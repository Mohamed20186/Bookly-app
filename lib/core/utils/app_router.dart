import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/features/home/presentation/views/home_view.dart';
import 'package:test_app/features/spalsh/presentation/views/splash_veiw.dart';

abstract class AppRoutes {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashView();
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/HomeView',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeView();
            },
          ),
        ],
      ),
    ],
  );
}
