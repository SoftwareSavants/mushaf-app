import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mushaf_app/src/helpers/base_controller.dart';

class Reciter extends BaseModel {
  final String id;
  final String name;

  @override
  String get orderedBy => id;

  const Reciter({required this.id, required this.name});

  factory Reciter.fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return Reciter(
      id: snap.id,
      name: snap.data()['name'],
    );
  }

  @override
  String toString() => 'Reciter(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reciter && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
