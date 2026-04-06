import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/splashviewbody.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    navigateToHome();
    super.initState();
  }

  Future<Null> navigateToHome() {
    return Future.delayed(const Duration(seconds: 5), () {
      GoRouter.of(context).pushReplacement('/HomeView');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashViewBody());
  }
}
