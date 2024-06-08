import 'package:flutter/material.dart';
import 'package:mushaf_app/src/reciter/models.dart';
import 'package:mushaf_app/src/reciters/controller.dart';
import 'package:mushaf_app/src/reciters/models.dart';
import 'package:mushaf_app/src/reciters/view.dart';
import 'package:mushaf_app/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'controller.dart';

class ReciterView extends StatelessWidget {
  static const routeName = '/reciter';
  const ReciterView({super.key});

  @override
  Widget build(BuildContext context) {
    final reciter = ModalRoute.of(context)!.settings.arguments as Reciter;
    return ChangeNotifierProvider(
      create: (context) => ReciterController(reciter),
      child: const _ReciterViewBody(),
    );
  }
}

class _ReciterViewBody extends StatelessWidget {
  const _ReciterViewBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReciterController>();

    return Scaffold(
      appBar: AppBar(title: Text(controller.reciter.name)),
      body: controller.loading && controller.items.isEmpty
          ? const LoadingWidget()
          : ListView.separated(
              controller: controller.scrollController,
              itemCount: controller.items.length + 1,
              padding: EdgeInsets.only(
                bottom: 100 + MediaQuery.of(context).padding.bottom,
              ),
              itemBuilder: (context, index) {
                if (index == controller.items.length) {
                  if (!controller.loading) return const SizedBox.shrink();
                  return const LoadingWidget();
                }
                return _RecitationCard(
                  reciter: controller.reciter,
                  recitation: controller.items[index],
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(
          bottom: 20 + MediaQuery.of(context).padding.bottom,
        ),
        child: const CurrentRecitationIndicator(),
      ),
    );
  }
}

class _RecitationCard extends StatelessWidget {
  final Reciter reciter;
  final Recitation recitation;
  const _RecitationCard({required this.reciter, required this.recitation});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RecitersController>();

    return InkWell(
      onTap: () => controller.playRecitation(
        reciter: reciter,
        recitation: recitation,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${recitation.conter} ${recitation.title}",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            StreamBuilder(
              stream: controller.player.playingStream,
              builder: (context, snapshot) {
                final playing =
                    controller.currentRecitation?.id == recitation.id &&
                        snapshot.data != null &&
                        snapshot.data!;
                return Icon(
                  playing
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  color: Theme.of(context).primaryColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
