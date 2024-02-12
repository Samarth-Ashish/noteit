// import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsProvider extends ChangeNotifier {
  int value = 0;
  List<Map> lists = [];
  // List<Map<dynamic, dynamic>> lists = [];

  List<Color> colorList = [
      Colors.transparent,
      Colors.green,
      Colors.blue,
      // Colors.yellow,
      Colors.red,
      Colors.purple,
      // Colors.pink,
      Colors.orange
    ];

    

  ListsProvider() {
    getLists();
    // print(lists);
  }

  // Save the lists to SharedPreferences
  Future<void> saveLists() async {
    final prefs = await SharedPreferences.getInstance();
    // print('saving ${lists}');
    final jsonLists = jsonEncode(lists);
    await prefs.setString('lists', jsonLists);
  }

  // Retrieve the lists from SharedPreferences
  Future<void> getLists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonLists = prefs.getString('lists');
    if (jsonLists != null) {
      // Deserialize the JSON string to List<Map<dynamic, dynamic>>
      lists = (jsonDecode(jsonLists) as List).cast<Map<dynamic, dynamic>>();
    }
    notifyListeners(); // Notify listeners after updating the lists
  }

  void increment() {
    value++;
    notifyListeners();
  }

  void addToList(value) {
    lists.add(value);
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
