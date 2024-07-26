import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:ui';

import '../providers/theme_provider.dart';

AppBar CommonAppBar(BuildContext context, String title) {
  return AppBar(
    // backgroundColor: (context.read<ThemeProvider>().isThemeDark ? Colors.black : Colors.white).withOpacity(appBarOpacity),
    backgroundColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: blurFilter(),
    title: Text(title),
    // actionsIconTheme: const IconThemeData(opticalSize: 15),
    actions: themeSwitchWithIcons(context),
    centerTitle: true,
  );
}

ClipRect blurFilter() {
  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Container(
        color: Colors.transparent,
      ),
    ),
  );
}
