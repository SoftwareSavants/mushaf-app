import 'dart:async';
import 'package:mushaf_app/src/doua/model.dart';
import 'package:mushaf_app/src/doua/service.dart';
import 'package:flutter/material.dart';

class ArticlesController extends ChangeNotifier {
  final _service = ArticleService();
  final Category category;
  ArticlesController(this.category) {
    fetchArticlesDown();
  }

  List<Article> articles = [];
  bool categoriesLoading = false;
  bool articlesLoading = false;

  Future<void> fetchArticlesUp() async {
    final newArticles = await _service.getArticles(
      before: articles.first.createdAt,
      category: category.id,
    );
    articles.insertAll(0, newArticles);
    notifyListeners();
  }

  void fetchArticlesDown() async {
    if (articlesLoading) return;
    articlesLoading = true;
    notifyListeners();
    final newArticles = await _service.getArticles(
      after: articles.isNotEmpty ? articles.last.createdAt : null,
      category: category.id,
    );
    articles.addAll(newArticles);
    articlesLoading = false;
    notifyListeners();
  }
}
