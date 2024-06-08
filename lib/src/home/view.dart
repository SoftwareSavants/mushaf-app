import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mushaf_app/src/home/tabs/douas.dart';
import 'package:mushaf_app/src/home/tabs/quran.dart';
import 'package:mushaf_app/src/reciters/view.dart';

import '../wird/view.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 4, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          QuranTab(),
          RecitersTab(),
          DouaTab(),
          WirdTab(),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: tabController,
        builder: (context, _) => FloatingNavbar(
          currentIndex: tabController.index,
          onTap: tabController.animateTo,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.onPrimary,
          unselectedItemColor: Theme.of(context).colorScheme.onBackground,
          items: [
            FloatingNavbarItem(
              icon: EvaIcons.bookOpenOutline,
              title: 'المصحف',
            ),
            FloatingNavbarItem(
              icon: EvaIcons.micOutline,
              title: 'القراء',
            ),
            FloatingNavbarItem(
              icon: EvaIcons.bookOutline,
              title: 'الأذكار',
            ),
            FloatingNavbarItem(
              icon: EvaIcons.bookmarkOutline,
              title: 'الورد',
            ),
          ],
        ),
      ),
    );
  }
}
