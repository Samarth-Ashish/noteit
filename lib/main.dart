import 'package:flutter/material.dart';
import 'package:noteit/pages/stopwatch_page.dart';
import 'package:noteit/pages/timer_page.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/list_provider.dart';

import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),
        ChangeNotifierProvider<ListsProvider>(create: (context) => ListsProvider())
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
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) => MaterialApp(

          // title: 'Wakey',
          title: context.select((ThemeProvider T) => 'Wakey'),
          theme: theme.currentTheme,
          debugShowCheckedModeBanner: false,
          home: const HomePage(
            title: 'Wakey',
          ),
          // initialRoute: '/',
          routes: {
            '/homePage': (context) => const HomePage(title: 'Wakey'),
            '/timerPage': (context) => const TimerPage(),
            '/stopwatchPage': (context) => const StopwatchPage(),
          }),
    );
  }
}
