import 'package:flutter/material.dart';
import 'create_note.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  // runApp(MyApp());
  runApp(
    MultiProvider(
      // create the provider
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  late ThemeData currentTheme;
  late bool isDark;

  ThemeData lightTheme = ThemeData(
    // brightness: Brightness.light, // LightMode
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orangeAccent,
      brightness: Brightness.light,
    ),

    useMaterial3: true,

    iconTheme: const IconThemeData(
      color: Colors.deepOrange,
    ),

    // scaffoldBackgroundColor: Colors.red,
  );

  ThemeData darkTheme_ = ThemeData(
    // brightness: Brightness.dark, // DarkMode
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.lightBlue,
      brightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(
      color: Colors.yellow,
    ),
    // scaffoldBackgroundColor: Colors.green,
  );

  ThemeProvider() {
    isDark = true;
    currentTheme = darkTheme_;
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
    currentTheme = darkTheme_;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ThemeMode themeMode = ThemeMode.dark;
  // void toggleTheme(){
  //   setState(() {
  //     themeMode = (themeMode==ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
  //     print(themeMode);
  //   });
  // }
  // MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) => MaterialApp(
        title: 'Notes',
        theme: Provider.of<ThemeProvider>(context, listen: false).currentTheme,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        // darkTheme:
        //     Provider.of<ThemeProvider>(context, listen: false).darkTheme_,
        // themeMode: Provider.of<ThemeProvider>(context, listen: false).isDark
        //     ? ThemeMode.dark
        //     : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(
          title: 'Notes',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "USA",
        child: Text("USA"),
      ),
      const DropdownMenuItem(value: "Canada", child: Text("Canada")),
      const DropdownMenuItem(value: "Brazil", child: Text("Brazil")),
      const DropdownMenuItem(value: "England", child: Text("England")),
    ];
    return menuItems;
  }

  String selectedValue = "USA";

  // ThemeMode themeMode = ThemeMode.dark;

  // void toggleTheme(bool isDark) {
  //   setState(() {

  //     // print(Theme.of(context).changeTheme(ThemeMode.light));
  //   });
  // }

  // Color c = Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          const Icon(
            Icons.dark_mode,
            size: 20,
          ),
          FractionallySizedBox(
            heightFactor: 0.7,
            child: Switch(
              inactiveTrackColor: Theme.of(context).colorScheme.surface,
              activeColor: Theme.of(context).colorScheme.surface,
              value: !Provider.of<ThemeProvider>(context, listen: false).isDark,
              onChanged: (value) => setState(() {
                Provider.of<ThemeProvider>(context, listen: false).toggleMode();
                // print(Provider.of<ThemeProvider>(context, listen: false).isDark);
              }),
            ),
          ),
          Icon(
            Icons.light_mode,
            // color: Colors.yellowAccent,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
        ],
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          children: [
            // DropdownButton(
            //   autofocus: false,
            //   items: ['A', 'B', 'C', 'D'].map((String value) {
            //     return DropdownMenuItem(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (_) {},
            // ),
            // DropdownButton(
            //   value: selectedValue,
            //   items: dropdownItems,
            //   dropdownColor: Colors.black.withOpacity(0.0),
            //   onChanged: (_) {},
            // ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                accountName: Text(
                  "Abhishek Mishra",
                  // style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("abhishekm977@gmail.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ), //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' My Course '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text(' Go Premium '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Saved Videos '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreateNotePage()));
        },
        tooltip: 'Add new note',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
