import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'existing_notes_provider.dart';
import 'theme_provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ListsProvider(),
        )
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
        title: 'Remindus',
        theme: Provider.of<ThemeProvider>(context, listen: false).currentTheme,
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(
          title: 'Remindus',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // actionsIconTheme: IconThemeData(opticalSize: 15),
        actions: [
          Icon(
            Icons.dark_mode,
            color: Provider.of<ThemeProvider>(context).isDark
                ? Colors.lightBlue
                : null,
            size: 20,
          ),
          SizedBox(
            width: 50,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
                activeColor: Theme.of(context).colorScheme.onPrimary,
                value:
                    !Provider.of<ThemeProvider>(context, listen: false).isDark,
                onChanged: (value) => setState(() {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleMode();
                }),
              ),
            ),
          ),
          Icon(
            Icons.light_mode,
            color: Provider.of<ThemeProvider>(context, listen: false).isDark
                ? null
                : Colors.deepOrange,
            size: 20,
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: Provider.of<ListsProvider>(context).lists.length,
          itemBuilder: (context, index) {
            final item = Provider.of<ListsProvider>(context).lists[index];
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context)
                    .colorOfThemeBrightness(
                        item['currentColor'], .2, Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        item['currentTitle'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        item['days'].keys.length,
                        (index) => Container(
                          padding: const EdgeInsets.all(1.5),
                          margin: const EdgeInsets.all(1),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item['days'][item['days']
                                    .keys
                                    .elementAt(index)] // !value
                                ? (Provider.of<ThemeProvider>(context)
                                    .colorOfAntiThemeBrightness(
                                        item['currentColor'], .2, Colors.grey))
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: FittedBox(
                              child: Text(
                                '${item['days'].keys.elementAt(index)}',
                                style: TextStyle(
                                  color: Provider.of<ThemeProvider>(context)
                                      .colorOfThemeBrightnessIfTrueAndViceVersa(
                                          item['days'][item['days']
                                              .keys
                                              .elementAt(index)],
                                          item['currentColor'],
                                          .2,
                                          Colors.grey),
                                  // fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const CreateNotePage()));
          // showModal(context);
          showAlertDialog(context);
        },
        tooltip: 'Add new note',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return const SizedBox(
          height: 200.0,
          child: Center(
            child: Text(
              'This is a modal!',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    bool isColorPickerActive = false;
    Color? currentColor;
    String currentTitle = '';
    TextEditingController titleController = TextEditingController();
    FocusNode titleFocusNode = FocusNode();

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

    Map days = {
      'Mo': false,
      'Tu': false,
      'We': false,
      'Th': false,
      'Fr': false,
      'Sa': false,
      'Su': false,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Provider.of<ThemeProvider>(context)
                  .colorOfThemeBrightness(currentColor, .2),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  PopupMenuButton(
                    //!PopupMenuButton
                    onOpened: () {
                      setState(() {
                        isColorPickerActive = true;
                      });
                    },
                    onCanceled: () {
                      setState(() {
                        isColorPickerActive = false;
                      });
                    },
                    onSelected: (value) {
                      setState(() {
                        isColorPickerActive = false;
                        debugPrint('tapped');
                      });
                    },
                    icon: Icon(
                      isColorPickerActive
                          ? Icons.palette_outlined
                          : Icons.palette,
                      color: Provider.of<ThemeProvider>(context)
                          .colorOfAntiThemeBrightness(currentColor, .2),
                      // Icons.palette,
                    ),
                    // elevation: 10,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: List.generate(
                            colorList.length,
                            (index) => IconButton(
                              onPressed: () {
                                setState(() {
                                  // print(colorList[index]);
                                  currentColor =
                                      colorList[index] == Colors.transparent
                                          ? null
                                          : colorList[index];
                                });
                              },
                              icon: colorList[index] != Colors.transparent
                                  ? Icon(
                                      Icons.circle,
                                      color: colorList[index],
                                    )
                                  : Icon(
                                      Icons.water_drop_rounded,
                                      color: Theme.of(context).highlightColor,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    offset: const Offset(0, -60),
                    // color: Colors.grey,
                    // elevation: 2,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    // color: Colors.white,
                    child: TextField(
                      onTapOutside: (event) {
                        setState(() {
                          titleFocusNode.unfocus();
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          titleFocusNode.unfocus();
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          titleFocusNode.unfocus();
                        });
                      },
                      onTap: () {
                        setState(() {});
                      },
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      focusNode: titleFocusNode,
                      controller: titleController,
                      decoration: InputDecoration(
                        border: titleFocusNode.hasFocus
                            ? const UnderlineInputBorder()
                            : InputBorder.none,
                        hintText: 'Title',
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          // color: darken(currentColor, .9),
                          // decorationColor: Colors.yellow,
                          // backgroundColor: Colors.white,
                        ),
                      ),
                      // autofocus: true,
                      onChanged: (text) => {
                        setState(() {
                          currentTitle = titleController.text;
                          debugPrint(text);
                        })
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Switch(
                        inactiveTrackColor:
                            Theme.of(context).colorScheme.onPrimary,
                        activeColor: Theme.of(context).colorScheme.onPrimary,
                        value:
                            !Provider.of<ThemeProvider>(context, listen: false)
                                .isDark,
                        onChanged: (value) => setState(() {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleMode();
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              content: FittedBox(
                fit: BoxFit.fill,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Distribute evenly
                  // mainAxisSize: MainAxisSize.min,
                  children: days.entries
                      .map(
                        (entry) => GestureDetector(
                          onTap: () {
                            setState(() {
                              days[entry.key] = !days[entry.key];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(1),
                            margin: const EdgeInsets.all(1),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: days[entry.key]
                                  ? Provider.of<ThemeProvider>(context)
                                      .colorOfAntiThemeBrightness(
                                          currentColor, .2, Colors.grey)
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: FittedBox(
                                child: Text(
                                  '${entry.key}',
                                  style: TextStyle(
                                    color: days[entry.key]
                                        ? Provider.of<ThemeProvider>(context)
                                            .colorOfThemeBrightness(
                                                currentColor, .2, Colors.grey)
                                        : Provider.of<ThemeProvider>(context)
                                            .colorOfAntiThemeBrightness(
                                                currentColor, .2, Colors.grey),
                                    // fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              // backgroundColor: Colors.grey[200],
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Close the dialog
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      // color: (Provider.of<ThemeProvider>(context).isDark
                      //     ? lighten(currentColor, .2)
                      //     : darken(currentColor, .2)),
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<ListsProvider>(context, listen: false)
                          .increment();
                      // print(Provider.of<ListsProvider>(context, listen: false)
                      // .value);
                      Provider.of<ListsProvider>(context, listen: false)
                          .addToList({
                        'currentColor': currentColor,
                        'currentTitle': currentTitle,
                        'days': days,
                      });
                      // print(Provider.of<ListsProvider>(context, listen: false)
                      // .lists);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Provider.of<ThemeProvider>(context).isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
