import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mushaf_app/src/helpers/base_controller.dart';

class Recitation extends BaseModel {
  final String id;
  final int? conter;
  final String title;
  final String url;
  final int order;

  const Recitation(
      {required this.id,
      required this.title,
      required this.url,
      required this.order,
      required this.conter});

  factory Recitation.fromSnap(
      QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return Recitation(
      id: snap.id,
      title: snap.data()['title'],
      url: snap.data()['url'],
      conter: snap.data()['counter'] ?? snap.data()['order'],
      order: snap.data()['counter'] ?? snap.data()['order'],
    );
  }

  @override
  String toString() => 'Recitation(title: $title, url: $url,conter:$conter)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recitation &&
        other.id == id &&
        other.title == title &&
        other.url == url &&
        other.conter == conter;
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ url.hashCode ^ conter.hashCode;

  @override
  int get orderedBy => order;
}
