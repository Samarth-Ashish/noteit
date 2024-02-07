import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

class ListsProvider extends ChangeNotifier {
  int value = 0;
  List lists = [];

  void increment() {
    value++;
    notifyListeners();
  }

  void addToList(value){
    lists.add(value);
    notifyListeners();
  }
}
