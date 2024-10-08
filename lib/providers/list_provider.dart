import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> lists = [];

  final List<Color> colorList = [
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
    getListsFromCache();
  }

  Future<void> getListsFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonLists = prefs.getString('lists');
      if (jsonLists != null) {
        final decodedLists = jsonDecode(jsonLists) as List<dynamic>;
        lists = decodedLists.cast<Map<String, dynamic>>();
      } else {
        lists = [];
      }
    } catch (error) {
      // Handle error if needed
      debugPrint("Error loading lists from cache: $error");
    }
    notifyListeners();
  }

  Future<void> saveLists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonLists = jsonEncode(lists);
    await prefs.setString('lists', jsonLists);
    notifyListeners();
  }

  Future<void> addToList({
    Color? colorIndexFromColor,
    String title = '',
    Map<String, bool>? days,
    DateTime? selectedTime,
    bool? enabled,
  }) async {
    lists.add({
      'colorIndex': (colorIndexFromColor == null) ? null : colorList.indexOf(colorIndexFromColor),
      'title': title,
      'days': days,
      'time': selectedTime!.millisecondsSinceEpoch,
      'enabled': enabled,
      // 'color': colorIndexFromColor,
    });
    await saveLists();
  }

  Future<void> updateListAtIndex({
    required int index,
    Color? colorIndexFromColor,
    String title = '',
    Map<String, bool>? days,
    DateTime? selectedTime,
    bool? enabled,
  }) async {
    lists[index] = {
      'colorIndex': (colorIndexFromColor == null) ? null : colorList.indexOf(colorIndexFromColor),
      'title': title,
      'days': days,
      'time': selectedTime!.millisecondsSinceEpoch,
      'enabled': enabled,
    };
    await saveLists();
  }

  Future<void> removeFromList(item) async {
    lists.remove(item);
    await saveLists();
  }

  Future<void> resetNotes() async {
    lists = [];
    await saveLists();
  }

  Future<void> setEnable(item, value) async {
    lists[lists.indexOf(item)]['enabled'] = value;
    await saveLists();
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
