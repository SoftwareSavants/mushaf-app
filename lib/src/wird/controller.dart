import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mushaf_app/preferences.dart';

class WirdController extends ChangeNotifier {
  final pagesCount = 604;
  final juzCount = 30;
  final pagesPerJuz = 20;

  /// in days
  int? dailyDoze = Preferences.getInt(PreferencesKey.dailyDoze);
  bool isJuz = Preferences.getBool(PreferencesKey.isJuz) ?? false;
  int completedPages = Preferences.getInt(PreferencesKey.completedPages) ?? 0;
  int completedWirds = Preferences.getInt(PreferencesKey.completedWirds) ?? 0;

  int get dailyJuzs => dailyDoze! ~/ pagesPerJuz;

  double get completedPercentage =>
      isJuz ? completedWirds / juzCount : completedPages / pagesCount;

  String get currentWirdStr {
    if (isJuz) {
      return dailyJuzs == 2
          ? 'جزأين'
          : dailyJuzs == 1
              ? 'جزء واحد'
              : dailyJuzs < 10
                  ? '$dailyJuzs أجزاء'
                  : '$dailyJuzs جزء';
    }
    return dailyDoze == 2
        ? 'صفحتان'
        : dailyDoze == 1
            ? 'صفحة'
            : dailyDoze! < 10
                ? '$dailyDoze صفحات'
                : '$dailyDoze صفحة';
  }

  void setDailyDoze(int newVal, bool isJuz) {
    dailyDoze = newVal;
    completedPages = 0;
    completedWirds = 0;
    this.isJuz = isJuz;
    notifyListeners();
    Preferences.setInt(PreferencesKey.dailyDoze, dailyDoze!);
    Preferences.setBool(PreferencesKey.isJuz, isJuz);
    Preferences.remove(PreferencesKey.completedPages);
    Preferences.remove(PreferencesKey.completedWirds);
  }

  int get wirdPage => isJuz
      ? getJuzPage(completedWirds + 1)
      : max(completedWirds * dailyDoze! + 1, completedPages);
  int get nextWirdPage => isJuz
      ? getJuzPage(completedWirds + 2)
      : min(
          pagesCount,
          (completedWirds + 1) * (dailyDoze ?? 0) + 1,
        );

  int getJuzPage(int juz) {
    if (juz == 1) return 1;
    if (juz == juzCount) return 582;
    return juz * pagesPerJuz + 2;
  }

  void completeCurrentWird({bool updateCP = false}) async {
    if (updateCP) {
      completedPages =
          (completedPages - completedPages % dailyDoze!) + dailyDoze!;
    }
    completedWirds++;
    await Preferences.setInt(PreferencesKey.completedPages, completedPages);
    await Preferences.setInt(PreferencesKey.completedWirds, completedWirds);
    if (completedPercentage >= 1) {
      dailyDoze = null;
      isJuz = false;
      completedPages = 0;
      await Preferences.remove(PreferencesKey.dailyDoze);
      await Preferences.remove(PreferencesKey.isJuz);
      await Preferences.remove(PreferencesKey.completedPages);
      await Preferences.remove(PreferencesKey.completedWirds);
    }

    notifyListeners();
  }

  void onWirdCompleted(int page) {
    completedPages = page;
    notifyListeners();
    Preferences.setInt(PreferencesKey.completedPages, page);
  }
}
