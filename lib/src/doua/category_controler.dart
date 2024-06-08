import 'package:mushaf_app/src/doua/model.dart';
import 'package:mushaf_app/src/doua/service.dart';
import 'package:flutter/material.dart';

class CategoryController extends ChangeNotifier {
  final _service = CategoryService();

  CategoryController() {
    startCategoriesStream();
  }
  List<Category> categories = [];
  bool loading = false;
  void startCategoriesStream() {
    loading = true;
    notifyListeners();
    _service.streamCategories().listen((newCategories) async {
      categories = newCategories;
      loading = false;
      notifyListeners();
    });
  }
}
