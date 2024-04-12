import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/existing_notes_provider.dart';

import 'pages/homepage.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<ListsProvider>(create: (_) => ListsProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // return Consumer<ThemeProvider>(
    //   builder: (context, theme, _) => MaterialApp(
    //     title: 'Remindus',
    //     theme: Provider.of<ThemeProvider>(context, listen: false).currentTheme,
    //     debugShowCheckedModeBanner: false,
    //     home: const HomePage(
    //       title: 'Noter',
    //     ),
    //   ),
    // );
    // NEW way ig
    return MaterialApp(
      title: 'Noter',
      // theme: Provider.of<ThemeProvider>(context, listen: false).currentTheme,
      theme: context.watch<ThemeProvider>().currentTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(
        title: 'Noter',
      ),
    );
  }
}
