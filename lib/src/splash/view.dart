import 'package:flutter/material.dart';
import 'package:mushaf_app/src/helpers/icons.dart';
import 'package:mushaf_app/src/helpers/navigator.dart';
import 'package:mushaf_app/src/home/view.dart';

class SplashView extends StatefulWidget {
  static const routeName = '/';
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => AppNavigator.pushReplacement(HomeView.routeName),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppIcons.appIcon),
      backgroundColor: Colors.white,
    );
  }
}
