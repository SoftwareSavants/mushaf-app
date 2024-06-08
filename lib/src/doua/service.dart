import 'package:mushaf_app/src/doua/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleService {
  final _firestore = FirebaseFirestore.instance;
  late final _articlesCollection = _firestore.collection('articles');
  Future<List<Article>> getArticles({
    String? category,
    DateTime? before,
    DateTime? after,
  }) async {
    Query<Map<String, dynamic>> query =
        _articlesCollection.where('categoryId', isEqualTo: category);

    query = query.orderBy('createdAt', descending: true);

    if (after != null) query = query.startAfter([after]);

    if (before != null) {
      query = query.endBefore([before]);
    } else {
      query = query.limit(12);
    }

    final snap = await query.get();

    return snap.docs.map(Article.fromSnap).toList();
  }
}

class CategoryService {
  final _firestore = FirebaseFirestore.instance;
  late final _articlesCollection = _firestore.collection('categories');
  Stream<List<Category>> streamCategories({
    String? category,
  }) {
    Query<Map<String, dynamic>> query = _articlesCollection;
    return query
        .snapshots()
        .map((snap) => snap.docs.map(Category.fromSnap).toList());
  }
}
