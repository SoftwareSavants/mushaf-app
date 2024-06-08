import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mushaf_app/src/helpers/base_controller.dart';
import 'package:mushaf_app/src/reciters/models.dart';

import 'models.dart';

class ReciterController extends BaseController<Recitation> {
  final Reciter reciter;
  ReciterController(this.reciter);

  @override
  get collection => FirebaseFirestore.instance
      .collection('/reciters/${reciter.id}/recitations')
      .orderBy('order');

  @override
  fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) =>
      Recitation.fromSnap(snap);
}
