import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mushaf_app/src/quran_viewer/view.dart';

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();
  static NavigatorState get state => key.currentState!;
  static BuildContext get context => key.currentContext!;

  static Future<T?> push<T>(String route, {Object? arguments}) =>
      state.pushNamed<T>(route, arguments: arguments);

  static void popUntilHome() => state.popUntil((route) => route.isFirst);

  static Future<T?> popAllAndPush<T>(String route, {Object? arguments}) =>
      state.pushNamedAndRemoveUntil<T>(
        route,
        (route) => false,
        arguments: arguments,
      );

  static Future<T?> pushReplacement<T, TO>(
    String route, {
    TO? result,
    Object? arguments,
  }) =>
      state.pushReplacementNamed<T, TO>(
        route,
        result: result,
        arguments: arguments,
      );

  static void pop<T>([T? result]) => state.pop<T>(result);

  static Future<T?> dialog<T>(Widget dialog) => showDialog<T>(
        context: context,
        builder: (context) => dialog,
      );

  static Route<dynamic>? onGeneratedRoute(RouteSettings routeSettings) {
    return CupertinoPageRoute<void>(
      settings: routeSettings,
      builder: (context) {
        final route = Uri.parse(routeSettings.name!);

        switch (route.path) {
          case QuranViewer.routeName:
            final queryParameters =
                Uri.parse(routeSettings.name!).queryParameters;
            return QuranViewer(
              initialPageNumber: int.parse(queryParameters['number']!),
              forWird: queryParameters['forWird'] == 'true',
            );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
