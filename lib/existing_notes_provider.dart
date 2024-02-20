// import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsProvider extends ChangeNotifier {
  late List<Map<dynamic, dynamic>> lists;

  List<Color> colorList = [
    Colors.transparent,
    Colors.green,
    Colors.blue,
    // Colors.yellow,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.pink,
  ];

  ListsProvider() {
    lists = [];
    getLists();
  }

  Future<void> getLists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonLists = prefs.getString('lists');
    if (jsonLists != null) {
      final decodedLists = jsonDecode(jsonLists) as List<dynamic>; // Explicit cast
      lists = decodedLists.cast<Map<dynamic, dynamic>>();
    }
    notifyListeners();
  }

  Future<void> saveLists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonLists = jsonEncode(lists);
    await prefs.setString('lists', jsonLists);
  }

  void addToList(item) async {
    lists.add(item);
    saveLists();
    notifyListeners();
  }

  void removeFromList(item) async {
    lists.remove(item);
    saveLists();
    notifyListeners();
  }

  void resetNotes() async {
    lists = [];
    saveLists();
    notifyListeners();
  }

  void setEnable(item, value) async {
    lists[lists.indexOf(item)]['enabled']=value;
    saveLists();
    notifyListeners();
  }
}

// Color getColorFromString(String colorString) {
//   // Strip 'Colors.' prefix from the color string
//   var colorName = colorString.split('.')[1];
  
//   // Convert color name to lowercase and capitalize the first letter
//   var colorNameCapitalized =
//       colorName.substring(0, 1).toUpperCase() + colorName.substring(1).toLowerCase();
  
//   // Use reflection to access Color class from dart:ui
//   var colorClass = Color;
  
//   // Use reflection to get the color object by invoking the getter method with the color name
//   return colorClass.invokeGetter(colorNameCapitalized);
// }
