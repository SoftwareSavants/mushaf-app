import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mushaf_app/src/doua/detail_doua.dart';
import 'package:mushaf_app/src/helpers/navigator.dart';
import 'package:mushaf_app/src/reciter/view.dart';
import 'package:mushaf_app/src/reciters/controller.dart';
import 'package:mushaf_app/src/wird/controller.dart';
import 'package:provider/provider.dart';
import 'home/tabs/douas.dart';

import 'helpers/theme_config.dart';
import 'home/view.dart';
import 'splash/view.dart';

class MushafApp extends StatelessWidget {
  const MushafApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecitersController()),
        ChangeNotifierProvider(create: (context) => WirdController()),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          title: 'Mushaf app',
          theme: ThemeConfig.lightTheme,
          debugShowCheckedModeBanner: false,
          navigatorKey: AppNavigator.key,
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          routes: {
            SplashView.routeName: (context) => const SplashView(),
            HomeView.routeName: (context) => const HomeView(),
            DouaTab.routeName: (context) => const DouaTab(),
            DouaView.routeName: (context) => const DouaView(),
            ReciterView.routeName: (context) => const ReciterView(),
          },
          onGenerateRoute: AppNavigator.onGeneratedRoute,
        ),
      ),
    );
  }
}
