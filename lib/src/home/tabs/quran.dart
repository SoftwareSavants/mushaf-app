import 'package:flutter/material.dart';
import 'package:mushaf_app/src/helpers/navigator.dart';
import 'package:mushaf_app/src/quran_viewer/view.dart';
import 'package:quran/quran.dart' as quran;

class QuranTab extends StatelessWidget {
  const QuranTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إذاعة موريتانيا - القرآن الكريم'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'السور'),
              Tab(text: 'الأجزاء'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.separated(
              itemCount: quran.totalSurahCount,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) =>
                  _SurahCard(surahNumber: index + 1),
              separatorBuilder: (context, index) => const Divider(),
            ),
            ListView.separated(
              itemCount: quran.totalJuzCount,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) => _JuzCard(juzNumber: index + 1),
              separatorBuilder: (context, index) => const Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final int surahNumber;
  const _SurahCard({required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    final surahName = quran.getSurahNameArabic(surahNumber);
    final ayahCount = quran.getVerseCount(surahNumber);
    final isMakkiyya = quran.getPlaceOfRevelation(surahNumber) == 'Makkah';

    return InkWell(
      onTap: () => AppNavigator.push(
        QuranViewer.buildRouteName(quran.getPageNumber(surahNumber, 1)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '$surahNumber',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'سورة $surahName',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  '$ayahCount آية، ${isMakkiyya ? 'مدنية' : 'مكية'}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JuzCard extends StatelessWidget {
  final int juzNumber;
  const _JuzCard({required this.juzNumber});

  @override
  Widget build(BuildContext context) {
    final surahAndVersesFromJuz = quran.getSurahAndVersesFromJuz(juzNumber);
    final surahNumber = juzNumber == 1
        ? surahAndVersesFromJuz.keys.last
        : surahAndVersesFromJuz.keys.first;

    final verseNumber = surahAndVersesFromJuz.values.first.first;

    final surahName = quran.getSurahNameArabic(surahNumber);
    final juzName = quran.getVerse(surahNumber, verseNumber);

    return InkWell(
      onTap: () => AppNavigator.push(
        QuranViewer.buildRouteName(
          quran.getPageNumber(surahNumber, verseNumber),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '$juzNumber',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text(
                    juzName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Text(
                  'سورة $surahName',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
