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
    // scaffoldBackgroundColor: Colors.grey.shade700,
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
    loadThemePreferencesFromCache();
  }

  Future<void> loadThemePreferencesFromCache() async {
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
    await saveThemePreferences();
  }

  Future<void> setLightTheme() async {
    currentTheme = lightTheme;
  }

  Future<void> setDarkTheme() async {
    currentTheme = darkTheme;
  }

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

  Color? colorFromBrightnessIfDarkOrElse({required Color fromColorIfDark, required Color fromColorIfLight, required Color colorToConvert}) {
    return isThemeDark
        ? returnColorFromBrightnessOf(
            fromColor: fromColorIfDark,
            colorToConvert: colorToConvert,
          )
        : returnColorFromBrightnessOf(
            fromColor: fromColorIfLight,
            colorToConvert: colorToConvert,
          );
  }

  Color? colorFromBrightness({required Color fromColor, required Color colorToConvert}) {
    return returnColorFromBrightnessOf(
      fromColor: fromColor,
      colorToConvert: colorToConvert,
    );
  }

  Color? darkened(Color? color, [double amount = .1]) {
    return darken(color, amount);
  }

  Color? lightened(Color? color, [double amount = .1]) {
    return lighten(color, amount);
  }
}


// ======================================================================================

//  darken
Color? darken(Color? color, [double amount = .1]) {
  if (color == null) {
    return null;
  }
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

// lighten
Color? lighten(Color? color, [double amount = .1]) {
  if (color == null) {
    return null;
  }
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

//  returnColorFromBrightnessOf
Color? returnColorFromBrightnessOf({required Color fromColor, required Color colorToConvert}) {
  // colorToConvert = colorToConvert ?? Colors.grey;

  final fromColorHSL = HSLColor.fromColor(fromColor);
  final colorToConvertHSL = HSLColor.fromColor(colorToConvert);

  final hslBlended = HSLColor.fromAHSL(
    colorToConvert.alpha.toDouble() / 255,
    colorToConvertHSL.hue,
    colorToConvertHSL.saturation,
    fromColorHSL.lightness,
  );

  return hslBlended.toColor();
}

// ======================================================================================

//themeSwitch
Widget themeSwitch(BuildContext context) {
  return Switch(
    // inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
    // activeColor: Theme.of(context).colorScheme.onPrimary,
    //
    // inactiveTrackColor: Colors.black,
    // activeTrackColor: Colors.grey,
    //
    inactiveTrackColor: const Color.fromARGB(255, 0, 36, 90),
    // hoverColor: Colors.redAccent,
    // inactiveThumbColor: Colors.grey,
    activeTrackColor: Colors.orangeAccent,
    //
    value: !context.watch<ThemeProvider>().isThemeDark,
    // onChanged: (value) => themeProvider.toggleTheme(),
    onChanged: (value) => context.read<ThemeProvider>().toggleTheme(),
  );
}

List<Widget> themeSwitchWithIcons(BuildContext context) {
  return [
    Icon(
      Icons.dark_mode,
      color: context.watch<ThemeProvider>().isThemeDark ? Colors.blueAccent : null,
      size: 20,
    ),
    SizedBox(
      width: 50,
      child: FittedBox(
        fit: BoxFit.fill,
        child: themeSwitch(context),
      ),
    ),
    Icon(
      Icons.light_mode,
      color: context.watch<ThemeProvider>().isThemeDark ? null : Colors.orangeAccent,
      size: 20,
    ),
  ];
}
