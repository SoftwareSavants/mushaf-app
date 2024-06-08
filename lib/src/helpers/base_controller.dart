import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class BaseController<T extends BaseModel> extends ChangeNotifier {
  final scrollController = ScrollController();

  bool loading = false;
  List<T> items = [];

  Query<Map<String, dynamic>> get collection;
  T fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap);

  BaseController() {
    getItems();
    scrollController.addListener(() {
      if (scrollController.offset + 100 >=
          scrollController.position.maxScrollExtent) {
        getItems();
      }
    });
  }

  void getItems() async {
    if (loading) return;
    loading = true;
    notifyListeners();

    Query<Map<String, dynamic>> query = collection;
    if (items.isNotEmpty) query = query.startAfter([items.last.orderedBy]);
    final newItems = await query.limit(20).get();

    items.addAll(newItems.docs.map(fromSnap));
    loading = false;
    notifyListeners();
  }
}

abstract class BaseModel {
  dynamic get orderedBy;

  const BaseModel();
}
