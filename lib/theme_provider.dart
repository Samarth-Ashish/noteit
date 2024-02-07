import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  late bool isDark;
  late ThemeData currentTheme;

  ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orangeAccent,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    // iconTheme: const IconThemeData(
    //   color: Colors.deepOrange,
    // ),
    // scaffoldBackgroundColor: Colors.red,
  );

  ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    // iconTheme: const IconThemeData(
    //   color: Colors.yellow,
    // ),
    // scaffoldBackgroundColor: Colors.green,
  );

  ThemeProvider() {
    isDark = true;
    currentTheme = darkTheme;
  }

  void toggleMode() async {
    isDark ? setLightMode() : setDarkmode();
    isDark = !isDark;
    notifyListeners();
  }

  void setLightMode() async {
    currentTheme = lightTheme;
    notifyListeners();
  }

  void setDarkmode() async {
    currentTheme = darkTheme;
    notifyListeners();
  }

  //

  Color? colorOfThemeBrightness(Color? color,
      [double amount = .1, Color? defaultColor]) {
    return isDark
        ? darken(color ?? defaultColor, amount)
        : lighten(color ?? defaultColor, amount);
  }

  Color? colorOfAntiThemeBrightness(Color? color,
      [double amount = .1, Color? defaultColor]) {
    return isDark
        ? lighten(color ?? defaultColor, amount)
        : darken(color ?? defaultColor, amount);
  }

  //

  Color? colorOfThemeBrightnessIfTrueAndViceVersa(bool condition, Color? color,
      [double amount = .1, Color? defaultColor]) {
    return condition
        ? colorOfThemeBrightness(color, amount, defaultColor)
        : colorOfAntiThemeBrightness(color, amount, defaultColor);
  }

  Color? colorOfAntiThemeBrightnessIfTrueAndViceVersa(
      bool condition, Color? color,
      [double amount = .1, Color? defaultColor]) {
    return condition
        ? colorOfAntiThemeBrightness(color, amount, defaultColor)
        : colorOfThemeBrightness(color, amount, defaultColor);
  }
}

// ! darken
Color? darken(Color? color, [double amount = .1]) {
  if (color == null) {
    return null;
  }

  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

// ! lighten
Color? lighten(Color? color, [double amount = .1]) {
  if (color == null) {
    return null;
  }

  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
