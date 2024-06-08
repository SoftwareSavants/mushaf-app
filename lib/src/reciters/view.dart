import 'package:flutter/material.dart';
import 'package:mushaf_app/src/helpers/navigator.dart';
import 'package:mushaf_app/src/reciter/view.dart';
import 'package:mushaf_app/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'models.dart';

class RecitersTab extends StatefulWidget {
  const RecitersTab({super.key});

  @override
  State<RecitersTab> createState() => _RecitersTabState();
}

class _RecitersTabState extends State<RecitersTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = context.watch<RecitersController>();

    return Scaffold(
      appBar: AppBar(title: const Text('القراء')),
      body: controller.loading
          ? const LoadingWidget()
          : ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.items.length,
              padding: EdgeInsets.only(
                bottom: 100 + MediaQuery.of(context).padding.bottom,
              ),
              itemBuilder: (context, index) => _ReciterCard(
                reciter: controller.items[index],
              ),
            ),
      bottomSheet: const CurrentRecitationIndicator(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ReciterCard extends StatelessWidget {
  final Reciter reciter;
  const _ReciterCard({required this.reciter});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => AppNavigator.push(
        ReciterView.routeName,
        arguments: reciter,
      ),
      title: Text(reciter.name),
      trailing: const RotatedBox(
        quarterTurns: 2,
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }
}

class CurrentRecitationIndicator extends StatelessWidget {
  const CurrentRecitationIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RecitersController>();
    final currentRecitation = controller.currentRecitation;
    final currentReciter = controller.currentReciter;
    final currentRecitationDuration = controller.currentRecitationDuration;

    if (currentRecitation == null || currentReciter == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentRecitation.title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      currentReciter.name,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              if (currentRecitationDuration == null)
                const LoadingWidget(height: 24, width: 24)
              else
                StreamBuilder(
                  stream: controller.player.playingStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data != null && snapshot.data!;
                    return IconButton(
                      onPressed: () => controller.playRecitation(
                        reciter: currentReciter,
                        recitation: currentRecitation,
                      ),
                      icon: Icon(
                        playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      iconSize: 32,
                    );
                  },
                ),
              IconButton(
                onPressed: controller.stopCurrentRecitation,
                icon: const Icon(Icons.close),
              ),
              const SizedBox(width: 5),
            ],
          ),
          StreamBuilder(
            stream: controller.player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = controller.player.duration ?? Duration.zero;
              if (position == duration) {
                controller.player.pause();
                controller.player.seek(Duration.zero);
              }
              final value = duration.inMilliseconds == 0
                  ? 0.0
                  : position.inMilliseconds / duration.inMilliseconds;

              return Slider(
                value: value,
                onChangeEnd: (value) => controller.player.seek(
                  Duration(
                    milliseconds: (duration.inMilliseconds * value).toInt(),
                  ),
                ),
                onChanged: (_) {},
              );
            },
          ),
        ],
      ),
    );
  }
}
