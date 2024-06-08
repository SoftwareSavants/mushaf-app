import 'package:flutter/material.dart';
import 'package:mushaf_app/src/helpers/navigator.dart';
import 'package:mushaf_app/src/wird/controller.dart';
import 'package:mushaf_app/widgets/buttons.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

class QuranViewer extends StatefulWidget {
  static const routeName = '/quran-viewer';
  static String buildRouteName(int number, {bool forWird = false}) => Uri(
        path: routeName,
        queryParameters: {
          'number': number.toString(),
          'forWird': forWird.toString(),
        },
      ).toString();

  final int initialPageNumber;
  final bool forWird;
  const QuranViewer({
    super.key,
    required this.initialPageNumber,
    required this.forWird,
  });

  @override
  State<QuranViewer> createState() => _QuranViewerState();
}

class _QuranViewerState extends State<QuranViewer> {
  int get initialPageNumber => widget.initialPageNumber;

  late final pdfController = PdfController(
    document: PdfDocument.openAsset('assets/quran.pdf'),
    initialPage: initialPageNumber,
  );

  @override
  Widget build(BuildContext context) {
    final nextWirdPage = widget.forWird
        ? context.select<WirdController, int>(
            (controller) => controller.nextWirdPage,
          )
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('القرآن')),
      body: ValueListenableBuilder(
        valueListenable: pdfController.pageListenable,
        builder: (context, value, _) => Stack(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: PdfView(
                controller: pdfController,
                scrollDirection: Axis.horizontal,
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                onPageChanged: widget.forWird
                    ? context.read<WirdController>().onWirdCompleted
                    : null,
              ),
            ),
            if (nextWirdPage == value) const _WirdCompletedView(),
          ],
        ),
      ),
    );
  }
}

class _WirdCompletedView extends StatelessWidget {
  const _WirdCompletedView();

  @override
  Widget build(BuildContext context) {
    final nextWirdPage = context.select<WirdController, int>(
      (controller) => controller.nextWirdPage,
    );

    return Container(
      color: Theme.of(context).backgroundColor.withOpacity(.75),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'لقد أنتهى الورد اليومي',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (nextWirdPage != 604) ...[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppButton(
                      labelText: 'مواصلة القراءة',
                      style: AppButtonStyle.outline,
                      onPressed:
                          context.read<WirdController>().completeCurrentWird,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: AppButton(
                  labelText: 'إنهاء القراءة',
                  onPressed: () {
                    context.read<WirdController>().completeCurrentWird();
                    AppNavigator.pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
