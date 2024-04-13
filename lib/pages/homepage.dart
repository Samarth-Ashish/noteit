import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../packages_/time_picker_.dart';
import '../providers/list_provider.dart';
import '../providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool isBouncingPhysics = false;
  // double appBarOpacity = 0;
  bool isAppBarBlurred = true;

  @override
  Widget build(BuildContext context) {
    print('====homepage built====');

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // backgroundColor: (context.watch<ThemeProvider>().isThemeDark ? Colors.black : Colors.white).withOpacity(appBarOpacity),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: isAppBarBlurred
              ? ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  // child: GlassContainer.frostedGlass(
                  //   height: 55,
                  //   width: MediaQuery.of(context).size.width,
                  //   // color: Colors.green.withOpacity(0),
                  //   color: Colors.transparent,
                  //   frostedOpacity: 0.1,
                  //   blur: 100,
                  //   borderWidth: 0,
                  // ),
                )
              : null,
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          // actionsIconTheme: IconThemeData(opticalSize: 15),
          actions: themeSwitchWithIcons(context),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                    // physics: (isBouncingPhysics) ? const BouncingScrollPhysics() : null,
                    // physics: ,
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: context.watch<ListsProvider>().lists.length,
                    itemBuilder: (BuildContext context, index) {
                      final item = context.watch<ListsProvider>().lists[index];
                      return reminderContainerFromItem(item);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().currentTheme.primaryColor,
                ), //BoxDecoration
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().currentTheme.primaryColor,
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
                  context.read<ListsProvider>().resetNotes();
                  Navigator.pop(context);
                },
              ),
              //
              // Row(
              //   children: [
              //     const Text("Bouncing physics:"),
              //     Switch(
              //       value: isBouncingPhysics,
              //       onChanged: (value) => {
              //         setState(() {
              //           isBouncingPhysics = value;
              //         })
              //       },
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     const Text("Appbar opacity:"),
              //     Slider(
              //       divisions: 5,
              //       min: 0,
              //       max: 1,
              //       value: appBarOpacity,
              //       onChanged: (value) {
              //         setState(() {
              //           appBarOpacity = value;
              //         });
              //       },
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     const Text("AppBar Blurred:"),
              //     Switch(
              //       value: isAppBarBlurred,
              //       onChanged: (value) => {
              //         setState(() {
              //           isAppBarBlurred = value;
              //         })
              //       },
              //     ),
              //   ],
              // )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          // shape: const CircleBorder(10),
          onPressed: () {
            // showModal(context);
            showNewReminderCreationDialog(context);
          },
          // tooltip: 'Add new note',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void showNewReminderCreationDialog(
    BuildContext context,
    //
    {
    Color? currentColor_,
    String? title_,
    bool? enabled_,
    DateTime? reminderTime_,
    Map<String, bool>? days_,
    //
  }) {
    //
    bool isColorPickerActive = false;
    final TextEditingController titleController = TextEditingController();
    final FocusNode titleFocusNode = FocusNode();

    Color? reminderColor = currentColor_;
    String title = title_ ?? '';
    bool enabled = enabled_ ?? true;
    DateTime reminderTime = reminderTime_ ?? DateTime.now();
    Map days = days_ ??
        {
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
              backgroundColor: context.watch<ThemeProvider>().colorOfThemeBrightness(reminderColor, .3),
              title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
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
                        });
                      },
                      icon: Icon(
                        isColorPickerActive ? Icons.palette_outlined : Icons.palette,
                        color: context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                              reminderColor,
                              .2,
                            ),
                        // Icons.palette,
                      ),
                      // elevation: 10,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          value: 1,
                          child: Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  // popupmenu color list
                                  context.read<ListsProvider>().colorList.length,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        reminderColor = context.read<ListsProvider>().colorList[index] == Colors.transparent
                                            ? null
                                            : context.read<ListsProvider>().colorList[index];
                                        isColorPickerActive = false;
                                        Navigator.pop(context);
                                      });
                                    },
                                    // icon: context.read<ListsProvider>().colorList[index] != Colors.transparent
                                    //     ? Icon(
                                    //         Icons.circle,
                                    //         color: context.read<ListsProvider>().colorList[index],
                                    //       )
                                    //     : Icon(
                                    //         Icons.water_drop_rounded,
                                    //         color: Theme.of(context).highlightColor,
                                    //       ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: context.read<ListsProvider>().colorList[index] != Colors.transparent
                                          ? Icon(
                                              Icons.circle,
                                              color: context.read<ListsProvider>().colorList[index],
                                              size: 25,
                                            )
                                          : Icon(
                                              Icons.water_drop_rounded,
                                              color: Theme.of(context).highlightColor,
                                              size: 25,
                                            ),
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
                              // color: darken(reminderColor, .9),
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
                        // child: themeSwitch(context),
                        child: Switch(
                          //
                          inactiveTrackColor: context.watch<ThemeProvider>().colorOfThemeBrightness(
                                reminderColor,
                                .2,
                                // Colors.grey,
                              ),
                          activeTrackColor: context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                                reminderColor,
                                .2,
                                Colors.grey.shade600,
                              ),
                          activeColor: context.watch<ThemeProvider>().colorOfThemeBrightness(
                                reminderColor,
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
                  //     child: themeSwitch(context),
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
                                  // margin: const EdgeInsets.all(1),
                                  width: 30,
                                  height: 30,
                                  // width: MediaQuery.of(context).size.width * 0.1,
                                  // height: MediaQuery.of(context).size.width * 0.1,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: days[entry.key]
                                        ? context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                                              reminderColor,
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
                                        color: context.watch<ThemeProvider>().colorOfThemeBrightnessIfTrueAndViceVersa(
                                              days[entry.key],
                                              reminderColor,
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
                      //   color: context.watch<ThemeProvider>().colorOfThemeBrightness(
                      //     reminderColor,
                      //     0.25,
                      //   ),
                      //   shape: ,
                      // ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                                reminderColor,
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
                          time: reminderTime,
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
                            color: context.watch<ThemeProvider>().colorOfThemeBrightness(
                                      reminderColor,
                                      0.3,
                                    ) ??
                                (context.watch<ThemeProvider>().isThemeDark ? Colors.grey.shade700 : Colors.grey.shade400),
                          ),
                          highlightedTextStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                                  reminderColor,
                                  0.2,
                                  Colors.blueGrey,
                                ),
                          ),
                          isForce2Digits: true,
                          onTimeChange: (dateTime) {
                            setState(() {
                              reminderTime = dateTime;
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
                      context.read<ListsProvider>().addToList(
                            colorIndexFromColor: reminderColor,
                            title: title,
                            days: days,
                            selectedTime: reminderTime,
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
                      color: context.watch<ThemeProvider>().isThemeDark ? Colors.white : Colors.black,
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

  Widget reminderContainerFromItem(Map<dynamic, dynamic> item) {
    return Stack(
      // alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: GlassContainer.frostedGlass(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context
                    .watch<ThemeProvider>()
                    .colorOfThemeBrightness(
                      (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                      .3,
                      Colors.grey,
                    )!
                    .withOpacity(0.6),
                context
                    .watch<ThemeProvider>()
                    .colorOfThemeBrightness(
                      (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                      .2,
                      Colors.grey,
                    )!
                    .withOpacity(1),
              ],
              //
            ),
            //
            // color: themeProvider
            //     .colorOfThemeBrightness(
            //       (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
            //       .3,
            //       Colors.grey,
            //     )!
            //     .withOpacity(0.5),
            //
            // blur: 15.0,
            frostedOpacity: 0.4, //0.2
            margin: const EdgeInsets.all(5),
            borderRadius: BorderRadius.circular(25),
            borderWidth: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 7,
            // duration: const Duration(milliseconds: 1000),
            child: Center(
              child: Container(
                // margin: const EdgeInsets.only(top: 5, bottom: 17, left: 8, right: 8),
                // margin: const EdgeInsets.only(left: 10,right: 10),
                padding: const EdgeInsets.all(5),
                // decoration: BoxDecoration(
                //   // color: context.watch<ThemeProvider>().colorOfThemeBrightness(
                //   //   (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                //   //   .2,
                //   //   Colors.grey,
                //   // ),
                //   borderRadius: BorderRadius.circular(25),
                // ),
                child: Center(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(item['time'])).toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                                      (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
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
                                // child: themeSwitch(context),
                                child: Switch(
                                  //
                                  inactiveTrackColor: context.watch<ThemeProvider>().colorOfThemeBrightness(
                                        (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                                        .2,
                                        Colors.grey,
                                      ),
                                  activeTrackColor: context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                                      (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                                      .2,
                                      Colors.grey.shade600),
                                  activeColor: context.watch<ThemeProvider>().colorOfThemeBrightness(
                                      (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                                      .2,
                                      Colors.grey.shade600),
                                  //
                                  value: item['enabled'] ?? false,
                                  onChanged: (value) => {context.read<ListsProvider>().setEnable(item, value)},
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
                              //       ? context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                              //           (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                              //           .2,
                              //           Colors.grey,
                              //         )
                              //       : null,
                              // ),
                              color: item['days'][item['days'].keys.elementAt(index)]
                                  ? context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                                        (item['colorIndex'] == null)
                                            ? null
                                            : context.read<ListsProvider>().colorList[item['colorIndex']].withOpacity(0.6),
                                        .3,
                                        Colors.grey,
                                      )
                                  : context
                                      .watch<ThemeProvider>()
                                      .colorOfThemeBrightness(
                                        (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
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
                                    color: context.watch<ThemeProvider>().colorOfThemeBrightnessIfTrueAndViceVersa(
                                          item['days'][item['days'].keys.elementAt(index)],
                                          (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
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
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              context.read<ListsProvider>().removeFromList(item);
            },
            icon: const FaIcon(FontAwesomeIcons.solidTrashCan),
            // color: Colors.redAccent,
            color: context.watch<ThemeProvider>().colorOfAntiThemeBrightness(
                  (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                  .2,
                  Colors.grey,
                ),
            iconSize: 20,
          ),
        ),
      ],
    );
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
