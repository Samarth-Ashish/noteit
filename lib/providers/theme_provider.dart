import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late bool isThemeDark;
  late ThemeData currentTheme;

  final ThemeData lightTheme = ThemeData(
    // scaffoldBackgroundColor: Colors.white70,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orangeAccent,
      brightness: Brightness.light,
      // background: Colors.redAccent,
    ),
    useMaterial3: true,
    // iconTheme: const IconThemeData(
    //   color: Colors.deepOrange,
    // ),
    // scaffoldBackgroundColor: Colors.red,
  );
  final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
      // background: Colors.redAccent,
    ),
    useMaterial3: true,
    // iconTheme: const IconThemeData(
    //   color: Colors.yellow,
    // ),
    // scaffoldBackgroundColor: Colors.green,
  );

  ThemeProvider({bool? isThemeDark = true}) {
    this.isThemeDark = isThemeDark ?? true;
    currentTheme = this.isThemeDark ? darkTheme : lightTheme;
    loadThemePreferencesFromStorage();
  }

  Future<void> loadThemePreferencesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    isThemeDark = prefs.getBool('isThemeDark') ?? true;
    currentTheme = isThemeDark ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> saveThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isThemeDark', isThemeDark);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    isThemeDark = !isThemeDark;
    isThemeDark ? setDarkTheme() : setLightTheme();
    saveThemePreferences();
    notifyListeners();
  }

  Future<void> setLightTheme() async {
    currentTheme = lightTheme;
    notifyListeners();
  }

  Future<void> setDarkTheme() async {
    currentTheme = darkTheme;
    notifyListeners();
  }

  //

  Color? colorOfThemeBrightness(
    Color? color, [
    double amount = .1,
    Color? defaultColor,
  ]) {
    return isThemeDark ? darken(color ?? defaultColor, amount) : lighten(color ?? defaultColor, amount);
  }

  Color? colorOfAntiThemeBrightness(Color? color, [double amount = .1, Color? defaultColor]) {
    return isThemeDark ? lighten(color ?? defaultColor, amount) : darken(color ?? defaultColor, amount);
  }

  //

  Color? colorOfThemeBrightnessIfTrueAndViceVersa(bool condition, Color? color, [double amount = .1, Color? defaultColor]) {
    return condition ? colorOfThemeBrightness(color, amount, defaultColor) : colorOfAntiThemeBrightness(color, amount, defaultColor);
  }

  Color? colorOfAntiThemeBrightnessIfTrueAndViceVersa(bool condition, Color? color, [double amount = .1, Color? defaultColor]) {
    return condition ? colorOfAntiThemeBrightness(color, amount, defaultColor) : colorOfThemeBrightness(color, amount, defaultColor);
  }

  //

  Color? colorFromBrightnessOf(Color? color1, {Color color2 = Colors.grey}) {
    return returnColorFromBrightnessOf(
      fromColor: color1,
      colorToConvert: color2,
    );
  }
}

// ! darken/
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

// ! returnColorFromBrightnessOf
Color? returnColorFromBrightnessOf({Color? fromColor, Color colorToConvert = Colors.grey}) {
  if (fromColor == null) {
    return null;
  }
  // colorToConvert = colorToConvert ?? Colors.grey;

  final fromColorHSL = HSLColor.fromColor(fromColor);
  final colorToConvertHSL = HSLColor.fromColor(colorToConvert);

  final hslBlended = HSLColor.fromAHSL(
    colorToConvert.alpha.toDouble(),
    colorToConvertHSL.hue,
    colorToConvertHSL.saturation,
    fromColorHSL.lightness,
  );

  return hslBlended.toColor();
}

//!themeModeSwitch
Widget themeModeSwitch(BuildContext context) {
  return Switch(
    // inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
    // activeColor: Theme.of(context).colorScheme.onPrimary,
    //
    // inactiveTrackColor: Colors.black,
    // activeTrackColor: Colors.grey,
    //
    inactiveTrackColor: Colors.blue[900],
    // hoverColor: Colors.redAccent,
    // inactiveThumbColor: Colors.grey,
    activeTrackColor: Colors.orangeAccent,
    //
    // value: !themeProvider.isThemeDark,
    value: !context.watch<ThemeProvider>().isThemeDark,
    // onChanged: (value) => themeProvider.toggleTheme(),
    onChanged: (value) => context.read<ThemeProvider>().toggleTheme(),
  );
}
