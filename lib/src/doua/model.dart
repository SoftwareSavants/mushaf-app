import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final DateTime createdAt;
  final String title;
  final int? repeat;
  final String? url;
  final String description;

  const Article({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    this.repeat,
    this.url,
  });

  factory Article.fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return Article.fromMap({'categoryId': snap.id, ...snap.data()});
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['categoryId'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
      title: map['description'],
      repeat: map['repeat'],
      url: map['sous-description'],
      description: map['title'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Article(categoryId: $id, createdAt: $createdAt, title: $title, description: $repeat, repeat: $url, sous-description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Article &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.title == title &&
        other.repeat == repeat &&
        other.url == url &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        title.hashCode ^
        repeat.hashCode ^
        url.hashCode ^
        description.hashCode;
  }
}

class Category {
  final String id;
  final String name;
  final String image;

  const Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return Category.fromMap({'categoryId': snap.id, ...snap.data()});
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['categoryId'],
      name: map['name'],
      image: map['image'],
    );
  }

  @override
  String toString() {
    return 'Category(categoryId: $id, name: $name, image: $image, )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ image.hashCode;
  }
}
