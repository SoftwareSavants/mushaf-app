import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mushaf_app/src/helpers/base_controller.dart';
import 'package:mushaf_app/src/reciter/models.dart';

import 'models.dart';

class RecitersController extends BaseController<Reciter> {
  @override
  get collection => FirebaseFirestore.instance.collection('reciters');

  @override
  fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) =>
      Reciter.fromSnap(snap);

  Reciter? currentReciter;
  Recitation? currentRecitation;
  Duration? currentRecitationDuration;
  final player = AudioPlayer();

  void playRecitation({
    required Reciter reciter,
    required Recitation recitation,
  }) async {
    if (currentRecitation?.id == recitation.id) {
      if (player.position == player.duration) player.seek(Duration.zero);
      player.playing ? player.pause() : player.play();
      return;
    }

    currentReciter = reciter;
    currentRecitation = recitation;
    notifyListeners();

    if (player.playing) await player.stop();
    currentRecitationDuration = await player.setUrl(recitation.url);
    player.play();
    notifyListeners();
  }

  void stopCurrentRecitation() async {
    currentReciter = null;
    currentRecitation = null;
    currentRecitationDuration = null;
    notifyListeners();
    await player.stop();
  }
}
