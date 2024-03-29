import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'existing_notes_provider.dart';
import 'manual_packages/time_picker_edited.dart';
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
          // title: '',
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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final listsProvider = Provider.of<ListsProvider>(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(0),
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          // actionsIconTheme: IconThemeData(opticalSize: 15),
          actions: [
            Icon(
              Icons.dark_mode,
              color: themeProvider.isDark ? Colors.blueAccent : null,
              size: 20,
            ),
            SizedBox(
              width: 50,
              child: FittedBox(
                fit: BoxFit.fill,
                child: themeModeSwitch(context, themeProvider),
              ),
            ),
            Icon(
              Icons.light_mode,
              color: themeProvider.isDark ? null : Colors.orangeAccent,
              size: 20,
            ),
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Center(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: listsProvider.lists.length,
              itemBuilder: (context, index) {
                final item = listsProvider.lists[index];
                return reminderContainerFromItem(themeProvider, item, listsProvider);
              },
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: themeProvider.currentTheme.primaryColor,
                ), //BoxDecoration
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: themeProvider.currentTheme.primaryColor,
                  ),
                  accountName: const Text(
                    "Name",
                    // style: TextStyle(fontSize: 18),
                  ),
                  accountEmail: const Text("name@gmail.com"),
                  currentAccountPictureSize: const Size.square(50),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: Text(
                      "",
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
                  listsProvider.resetNotes();
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
            showNewAlertDialog(context, themeProvider, listsProvider);
          },
          tooltip: 'Add new note',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget reminderContainerFromItem(ThemeProvider themeProvider, Map<dynamic, dynamic> item, ListsProvider listsProvider) {
    return Stack(
      // alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassContainer.frostedGlass(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeProvider
                    .colorOfThemeBrightness(
                      (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                      .3,
                      Colors.grey,
                    )!
                    .withOpacity(0.4),
                themeProvider
                .colorOfThemeBrightness(
                  (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                  .3,
                  Colors.grey,
                )!
                .withOpacity(0.7),
              ],
            ),
            //
            // color: themeProvider
            //     .colorOfThemeBrightness(
            //       (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
            //       .3,
            //       Colors.grey,
            //     )!
            //     .withOpacity(0.5),
            //
            // blur: 15.0,
            frostedOpacity: 0.3,
            margin: const EdgeInsets.all(5),
            borderRadius: BorderRadius.circular(25),
            borderWidth: 0,
            width: MediaQuery.of(context).size.width,
            height: 100,
            // duration: const Duration(milliseconds: 1000),
            child: Container(
              // margin: const EdgeInsets.only(top: 5, bottom: 17, left: 8, right: 8),
              // margin: const EdgeInsets.only(left: 10,right: 10),
              padding: const EdgeInsets.all(5),
              // decoration: BoxDecoration(
              //   // color: themeProvider.colorOfThemeBrightness(
              //   //   (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
              //   //   .2,
              //   //   Colors.grey,
              //   // ),
              //   borderRadius: BorderRadius.circular(25),
              // ),
              child: Center(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:5,bottom: 10, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(item['time'])).toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: themeProvider.colorOfAntiThemeBrightness(
                                (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                                .2,
                                Colors.grey,
                              ),
                            ),
                          ),
                          if (item['title'] != '')
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          SizedBox(
                            width: 50,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              // child: themeModeSwitch(context, themeProvider),
                              child: Switch(
                                //
                                inactiveTrackColor: themeProvider.colorOfThemeBrightness(
                                  (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                                  .2,
                                  Colors.grey,
                                ),
                                activeTrackColor: themeProvider.colorOfAntiThemeBrightness(
                                    (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                                    .2,
                                    Colors.grey.shade600),
                                activeColor: themeProvider.colorOfThemeBrightness(
                                    (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                                    .2,
                                    Colors.grey.shade600),
                                //
                                value: item['enabled'] ?? false,
                                onChanged: (value) => {listsProvider.setEnable(item, value)},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                        item['days'].keys.length,
                        (index) => Flexible(
                          child: GlassContainer.frostedGlass(
                            borderWidth: 0,
                            shape: BoxShape.circle,
                            // padding: const EdgeInsets.all(3),
                            padding: const EdgeInsets.all(4),
                            // margin: const EdgeInsets.all(0.5),
                            width: 30,
                            height: 30,
                            // decoration: BoxDecoration(
                            //   shape: BoxShape.circle,
                            //   color: item['days'][item['days'].keys.elementAt(index)]
                            //       ? themeProvider.colorOfAntiThemeBrightness(
                            //           (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                            //           .2,
                            //           Colors.grey,
                            //         )
                            //       : null,
                            // ),
                            color: item['days'][item['days'].keys.elementAt(index)]
                                ? themeProvider.colorOfAntiThemeBrightness(
                                    (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']].withOpacity(0.6),
                                    .3,
                                    Colors.grey,
                                  )
                                : themeProvider
                                    .colorOfThemeBrightness(
                                      (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                                      .3,
                                      Colors.grey,
                                    )!
                                    .withOpacity(0),
                            blur: 2,
                            frostedOpacity: item['days'][item['days'].keys.elementAt(index)] ? 0.6 : 0,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${item['days'].keys.elementAt(index)}',
                                style: TextStyle(
                                  color: themeProvider.colorOfThemeBrightnessIfTrueAndViceVersa(
                                    item['days'][item['days'].keys.elementAt(index)],
                                    (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
                                    .3,
                                    Colors.grey,
                                  ),
                                  // overflow: TextOverflow
                                  //     .ellipsis, // Handle potential overflow
                                  fontSize: 18,
                                  // fontWeight: FontWeight.w600,
                                  fontWeight: FontWeight.bold,
                                  // backgroundColor: Colors.blue,
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
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              listsProvider.removeFromList(item);
            },
            icon: const FaIcon(FontAwesomeIcons.solidTrashCan),
            // color: Colors.redAccent,
            color: themeProvider.colorOfAntiThemeBrightness(
              (item['colorIndex'] == null) ? null : listsProvider.colorList[item['colorIndex']],
              .2,
              Colors.grey,
            ),
            iconSize: 20,
          ),
        ),
      ],
    );
  }

  void showNewAlertDialog(BuildContext context, ThemeProvider themeProvider, ListsProvider listsProvider) {
    // others
    TextEditingController titleController = TextEditingController();
    FocusNode titleFocusNode = FocusNode();
    bool isColorPickerActive = false;
    bool enabled = true;

    DateTime now = DateTime.now();

    Color? currentColor;
    String title = '';
    DateTime selectedTime = now;

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
              insetPadding: EdgeInsets.zero,
              backgroundColor: themeProvider.colorOfThemeBrightness(currentColor, .2),
              title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    PopupMenuButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
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
                      // onSelected: (value) {
                      //   setState(() {
                      //     isColorPickerActive = false;
                      //     debugPrint('tapped');
                      //   });
                      // },
                      icon: Icon(
                        isColorPickerActive ? Icons.palette_outlined : Icons.palette,
                        color: themeProvider.colorOfAntiThemeBrightness(
                          currentColor,
                          .2,
                        ),
                        // Icons.palette,
                      ),
                      // elevation: 10,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                listsProvider.colorList.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // print(colorList[index]);
                                      currentColor =
                                          listsProvider.colorList[index] == Colors.transparent ? null : listsProvider.colorList[index];
                                    });
                                  },
                                  // icon: listsProvider.colorList[index] != Colors.transparent
                                  //     ? Icon(
                                  //         Icons.circle,
                                  //         color: listsProvider.colorList[index],
                                  //       )
                                  //     : Icon(
                                  //         Icons.water_drop_rounded,
                                  //         color: Theme.of(context).highlightColor,
                                  //       ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: listsProvider.colorList[index] != Colors.transparent
                                        ? Icon(
                                            Icons.circle,
                                            color: listsProvider.colorList[index],
                                          )
                                        : Icon(
                                            Icons.water_drop_rounded,
                                            color: Theme.of(context).highlightColor,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      offset: const Offset(-10, -90),
                      // color: Colors.grey,
                      elevation: 10,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        alignment: Alignment.center,
                        // width: 100,
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
                            border: titleFocusNode.hasFocus ? const UnderlineInputBorder() : InputBorder.none,
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
                              title = titleController.text;
                              debugPrint(text);
                            })
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 50,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        // child: themeModeSwitch(context, themeProvider),
                        child: Switch(
                          //
                          inactiveTrackColor: themeProvider.colorOfThemeBrightness(
                            currentColor,
                            .2,
                            // Colors.grey,
                          ),
                          activeTrackColor: themeProvider.colorOfAntiThemeBrightness(
                            currentColor,
                            .2,
                            Colors.grey.shade600,
                          ),
                          activeColor: themeProvider.colorOfThemeBrightness(
                            currentColor,
                            .2,
                            Colors.grey.shade600,
                          ),
                          //
                          value: enabled,
                          onChanged: (value) => {
                            setState(() {
                              enabled = value;
                            })
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ! content
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(
                  //   width: 50,
                  //   child: FittedBox(
                  //     fit: BoxFit.contain,
                  //     child: themeModeSwitch(context, themeProvider),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: days.entries
                          .map(
                            (entry) => Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    days[entry.key] = !days[entry.key];
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(1),
                                  margin: const EdgeInsets.all(1),
                                  width: 30,
                                  height: 30,
                                  // width: MediaQuery.of(context).size.width * 0.1,
                                  // height: MediaQuery.of(context).size.width * 0.1,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: days[entry.key]
                                        ? themeProvider.colorOfAntiThemeBrightness(
                                            currentColor,
                                            .2,
                                            Colors.grey,
                                          )
                                        : null,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${entry.key}',
                                      style: TextStyle(
                                        color: themeProvider.colorOfThemeBrightnessIfTrueAndViceVersa(
                                          days[entry.key],
                                          currentColor,
                                          .2,
                                          Colors.grey,
                                        ),
                                        // fontSize: 10,
                                        fontWeight: FontWeight.w500,
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
                  FittedBox(
                    child: Container(
                      // decoration: ShapeDecoration(
                      //   color: themeProvider.colorOfThemeBrightness(
                      //     currentColor,
                      //     0.25,
                      //   ),
                      //   shape: ,
                      // ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: themeProvider.colorOfAntiThemeBrightness(
                            currentColor,
                            0.2,
                            Colors.blueGrey,
                          )!,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TimePickerSpinner(
                          //! time picker
                          time: now,
                          // spacing: 10,
                          itemHeight: 35,
                          minutesInterval: 5,
                          // alignment: Alignment.center,
                          // itemWidth: 40,
                          // separator: ':',
                          isShowSeconds: false,
                          normalTextStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.colorOfThemeBrightness(
                                  currentColor,
                                  0.3,
                                ) ??
                                (themeProvider.isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                          ),
                          highlightedTextStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.colorOfAntiThemeBrightness(
                              currentColor,
                              0.2,
                              Colors.blueGrey,
                            ),
                          ),
                          isForce2Digits: true,
                          onTimeChange: (dateTime) {
                            setState(() {
                              selectedTime = dateTime;
                              // print(selectedTime.hour);
                              // print(selectedTime.minute);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // backgroundColor: Colors.grey[200],
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Close the dialog
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      listsProvider.addToList(
                          colorIndexFromColor: currentColor, title: title, days: days, selectedTime: selectedTime, enabled: enabled);
                      // print(Provider.of<ListsProvider>(context, listen: false)
                      // .lists);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: themeProvider.isDark ? Colors.white : Colors.black,
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

  void showAlertDialogFromItem(BuildContext context, ThemeProvider themeProvider, ListsProvider listsProvider, Map item) {
    // others
    TextEditingController titleController = TextEditingController();
    FocusNode titleFocusNode = FocusNode();
    bool isColorPickerActive = false;
    bool enabled = item['enabled'];

    DateTime now = item['time'];

    Color? currentColor;
    String title = '';
    DateTime selectedTime = now;

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
              insetPadding: EdgeInsets.zero,
              backgroundColor: themeProvider.colorOfThemeBrightness(currentColor, .2),
              title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    PopupMenuButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
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
                      // onSelected: (value) {
                      //   setState(() {
                      //     isColorPickerActive = false;
                      //     debugPrint('tapped');
                      //   });
                      // },
                      icon: Icon(
                        isColorPickerActive ? Icons.palette_outlined : Icons.palette,
                        color: themeProvider.colorOfAntiThemeBrightness(
                          currentColor,
                          .2,
                        ),
                        // Icons.palette,
                      ),
                      // elevation: 10,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                listsProvider.colorList.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // print(colorList[index]);
                                      currentColor =
                                          listsProvider.colorList[index] == Colors.transparent ? null : listsProvider.colorList[index];
                                    });
                                  },
                                  // icon: listsProvider.colorList[index] != Colors.transparent
                                  //     ? Icon(
                                  //         Icons.circle,
                                  //         color: listsProvider.colorList[index],
                                  //       )
                                  //     : Icon(
                                  //         Icons.water_drop_rounded,
                                  //         color: Theme.of(context).highlightColor,
                                  //       ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: listsProvider.colorList[index] != Colors.transparent
                                        ? Icon(
                                            Icons.circle,
                                            color: listsProvider.colorList[index],
                                          )
                                        : Icon(
                                            Icons.water_drop_rounded,
                                            color: Theme.of(context).highlightColor,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      offset: const Offset(-10, -90),
                      // color: Colors.grey,
                      elevation: 10,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        alignment: Alignment.center,
                        // width: 100,
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
                            border: titleFocusNode.hasFocus ? const UnderlineInputBorder() : InputBorder.none,
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
                              title = titleController.text;
                              log(text);
                            })
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 50,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        // child: themeModeSwitch(context, themeProvider),
                        child: Switch(
                          //
                          inactiveTrackColor: themeProvider.colorOfThemeBrightness(
                            currentColor,
                            .2,
                            // Colors.grey,
                          ),
                          activeTrackColor: themeProvider.colorOfAntiThemeBrightness(
                            currentColor,
                            .2,
                            Colors.grey.shade600,
                          ),
                          activeColor: themeProvider.colorOfThemeBrightness(
                            currentColor,
                            .2,
                            Colors.grey.shade600,
                          ),
                          //
                          value: enabled,
                          onChanged: (value) => {
                            setState(() {
                              enabled = value;
                            })
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ! content
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(
                  //   width: 50,
                  //   child: FittedBox(
                  //     fit: BoxFit.contain,
                  //     child: themeModeSwitch(context, themeProvider),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: days.entries
                          .map(
                            (entry) => Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    days[entry.key] = !days[entry.key];
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(1),
                                  margin: const EdgeInsets.all(1),
                                  width: 30,
                                  height: 30,
                                  // width: MediaQuery.of(context).size.width * 0.1,
                                  // height: MediaQuery.of(context).size.width * 0.1,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: days[entry.key]
                                        ? themeProvider.colorOfAntiThemeBrightness(
                                            currentColor,
                                            .2,
                                            Colors.grey,
                                          )
                                        : null,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${entry.key}',
                                      style: TextStyle(
                                        color: themeProvider.colorOfThemeBrightnessIfTrueAndViceVersa(
                                          days[entry.key],
                                          currentColor,
                                          .2,
                                          Colors.grey,
                                        ),
                                        // fontSize: 10,
                                        fontWeight: FontWeight.w500,
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
                  FittedBox(
                    child: Container(
                      // decoration: ShapeDecoration(
                      //   color: themeProvider.colorOfThemeBrightness(
                      //     currentColor,
                      //     0.25,
                      //   ),
                      //   shape: ,
                      // ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: themeProvider.colorOfAntiThemeBrightness(
                            currentColor,
                            0.2,
                            Colors.blueGrey,
                          )!,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TimePickerSpinner(
                          //! time picker
                          time: now,
                          // spacing: 10,
                          itemHeight: 35,
                          minutesInterval: 5,
                          // alignment: Alignment.center,
                          // itemWidth: 40,
                          // separator: ':',
                          isShowSeconds: false,
                          normalTextStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.colorOfThemeBrightness(
                                  currentColor,
                                  0.3,
                                ) ??
                                (themeProvider.isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                          ),
                          highlightedTextStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.colorOfAntiThemeBrightness(
                              currentColor,
                              0.2,
                              Colors.blueGrey,
                            ),
                          ),
                          isForce2Digits: true,
                          onTimeChange: (dateTime) {
                            setState(() {
                              selectedTime = dateTime;
                              // print(selectedTime.hour);
                              // print(selectedTime.minute);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // backgroundColor: Colors.grey[200],
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Close the dialog
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      listsProvider.addToList(
                        colorIndexFromColor: currentColor,
                        title: title,
                        days: days,
                        selectedTime: selectedTime,
                        enabled: enabled,
                      );
                      // print(Provider.of<ListsProvider>(context, listen: false)
                      // .lists);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: themeProvider.isDark ? Colors.white : Colors.black,
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
}
