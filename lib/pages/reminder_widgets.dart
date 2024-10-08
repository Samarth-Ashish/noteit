import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:intl/intl.dart';

import 'package:bordered_text/bordered_text.dart';

import 'package:provider/provider.dart';
import '../modified_packages/time_picker_.dart';
import '../providers/list_provider.dart';
import '../providers/theme_provider.dart';

class ReminderContainerContents extends StatelessWidget {
  final Map<String, dynamic> item;
  const ReminderContainerContents({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                timeText(context),
                const SizedBox(width: 10),
                if (item['title'] != '') titleText(context),
                const SizedBox(width: 10),
                SizedBox(
                  width: 45,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: toggleReminderSwitch(context, item),
                  ),
                ),
              ],
            ),
          ),
          // weekdaysRow(item, context),
          WeekdayRow(item: item),
        ],
      ),
    );
  }

  Expanded titleText(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          item['title'],
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                offset: const Offset(0, 0),
                blurRadius: 6,
                color: context.read<ThemeProvider>().colorFromBrightnessIfConditionTrueOrElseAndIfDarkOrElse(
                      condition: item['enabled'],
                      fromColorIfTrueAndDark: context.read<ThemeProvider>().lightened(Colors.grey, 0.2)!,
                      fromColorIfFalseAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.25)!,
                      fromColorIfTrueAndLight: context.read<ThemeProvider>().darkened(Colors.grey, 0)!,
                      fromColorIfFalseAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.1)!,
                      colorToConvert:
                          (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
                    )!,
              ),
            ],
            color: context.read<ThemeProvider>().colorFromBrightnessIfConditionTrueOrElseAndIfDarkOrElse(
                  condition: item['enabled'],
                  fromColorIfTrueAndDark: context.read<ThemeProvider>().lightened(Colors.grey, 0.2)!,
                  fromColorIfFalseAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.25)!,
                  fromColorIfTrueAndLight: context.read<ThemeProvider>().darkened(Colors.grey, 0.1)!,
                  fromColorIfFalseAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.1)!,
                  colorToConvert: (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
                )!,
          ),
        ),
      ),
    );
  }

  BorderedText timeText(BuildContext context) {
    return BorderedText(
      strokeWidth: context.select((ListsProvider L) => item['enabled']) ? 6 : 0,
      strokeColor: context.select((ListsProvider L) => item['enabled'])
          ? context.read<ThemeProvider>().colorFromBrightnessIfDarkOrElse(
                fromColorIfDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.35)!,
                fromColorIfLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.23)!,
                colorToConvert: (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
              )!
          : Colors.black.withOpacity(0),
      child: Text(
        DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(item['time'])).toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: context.read<ThemeProvider>().colorFromBrightnessIfConditionTrueOrElseAndIfDarkOrElse(
                condition: item['enabled'],
                fromColorIfTrueAndDark: context.read<ThemeProvider>().lightened(Colors.grey, 0.15)!,
                fromColorIfFalseAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.35)!, //!
                fromColorIfTrueAndLight: context.read<ThemeProvider>().darkened(Colors.grey, 0.1)!,
                fromColorIfFalseAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.15)!, //!
                colorToConvert: (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
              ),
        ),
      ),
    );
  }

  Widget toggleReminderSwitch(BuildContext context, Map<String, dynamic> item) {
    return Switch(
      activeTrackColor: context.read<ThemeProvider>().colorFromBrightnessIfDarkOrElse(
            fromColorIfLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.17)!,
            fromColorIfDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.4)!,
            colorToConvert: (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
          )!,
      activeColor: context.read<ThemeProvider>().colorFromBrightnessIfDarkOrElse(
            fromColorIfLight: context.read<ThemeProvider>().darkened(Colors.grey, 0)!,
            fromColorIfDark: context.read<ThemeProvider>().lightened(Colors.grey, 0)!,
            colorToConvert: (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
          )!,
      // inactiveThumbColor: (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
      inactiveTrackColor: Colors.transparent,
      value: context.select((ListsProvider L) => item['enabled']),
      onChanged: (enabledValue) => context.read<ListsProvider>().setEnable(item, enabledValue),
    );
  }
}

class WeekdayRow extends StatelessWidget {
  final Map<String, dynamic> item;

  const WeekdayRow({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPrint('weekdays row ${item['colorIndex']}\n----');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(
        item['days'].keys.length,
        (index) => Flexible(
          // child: GlassContainer.frostedGlass( //! Selected weekdays are circle-highlighted
          //   borderWidth: 0,
          //   shape: BoxShape.circle,
          //   // padding: const EdgeInsets.all(3),
          //   padding: const EdgeInsets.all(4),
          //   // margin: const EdgeInsets.all(0.5),
          //   width: 30,
          //   height: 30,
          //   // decoration: BoxDecoration(
          //   //   shape: BoxShape.circle,
          //   //   color: item['days'][item['days'].keys.elementAt(index)]
          //   //       ? context.read<ThemeProvider>().colorOfAntiThemeBrightness(
          //   //           (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
          //   //           .2,
          //   //           Colors.grey,
          //   //         )
          //   //       : null,
          //   // ),
          //   //
          //   //
          //   // color: item['days'][item['days'].keys.elementAt(index)]
          //   //     ? context.read<ThemeProvider>().colorOfAntiThemeBrightness(
          //   //           (item['colorIndex'] == null)
          //   //               ? null
          //   //               : context.read<ListsProvider>().colorList[item['colorIndex']].withOpacity(0.6),
          //   //           .3,
          //   //           Colors.grey,
          //   //         )
          //   //     : context
          //   //         .read<ThemeProvider>()
          //   //         .colorOfThemeBrightness(
          //   //           (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
          //   //           .3,
          //   //           Colors.grey,
          //   //         )!
          //   //         .withOpacity(0),
          //   // color: item['days'][item['days'].keys.elementAt(index)]
          //   //     ? (item['colorIndex'] == null)
          //   //         ? null
          //   //         : context.read<ListsProvider>().colorList[item['colorIndex']]
          //   //     : Colors.grey,
          //   //
          //   //
          //   // blur: 2,
          //   // frostedOpacity: item['days'][item['days'].keys.elementAt(index)] ? 0.6 : 0, //*
          //   child: FittedBox(
          //     fit: BoxFit.scaleDown,
          //     child: Text(
          //       '${item['days'].keys.elementAt(index)}',
          //       style: const TextStyle(
          //         // color: context.read<ThemeProvider>().colorOfThemeBrightnessIfTrueAndViceVersa(
          //         //       item['days'][item['days'].keys.elementAt(index)],
          //         //       (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
          //         //       .3,
          //         //       Colors.grey,
          //         //     ),
          //         // overflow: TextOverflow
          //         //     .ellipsis, // Handle potential overflow
          //         fontSize: 18,
          //         // fontWeight: FontWeight.w600,
          //         fontWeight: FontWeight.bold,
          //         // backgroundColor: Colors.blue,
          //       ),
          //     ),
          //   ),
          // ),
          child: FittedBox(
            //! days row
            fit: BoxFit.scaleDown,
            child: item['days'][item['days'].keys.elementAt(index)]
                ? BorderedText(
                    strokeWidth: context.select((ListsProvider L) => item['days'][item['days'].keys.elementAt(index)])
                        ? (item['enabled'] ? 5 : 2)
                        : 0,
                    strokeColor: context.select((ListsProvider L) => item['enabled'])
                        ? context
                            .read<ThemeProvider>()
                            .colorFromBrightnessIfConditionTrueOrElseAndIfDarkOrElse(
                              condition: item['enabled'],
                              fromColorIfTrueAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.3)!,
                              fromColorIfFalseAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.35)!,
                              fromColorIfTrueAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.15)!,
                              fromColorIfFalseAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.2)!,
                              colorToConvert:
                                  (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
                            )!
                            .withOpacity(1)
                        : context
                            .read<ThemeProvider>()
                            .colorFromBrightnessIfConditionTrueOrElseAndIfDarkOrElse(
                              condition: item['enabled'],
                              fromColorIfTrueAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.3)!,
                              fromColorIfFalseAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.35)!,
                              fromColorIfTrueAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.15)!,
                              fromColorIfFalseAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.2)!,
                              colorToConvert:
                                  (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
                            )!
                            .withOpacity(1),
                    strokeJoin: StrokeJoin.round,
                    child: weekdayText(item, index, context),
                  )
                : weekdayText(item, index, context),
          ),
        ),
      ),
    );
  }

  Text weekdayText(Map<String, dynamic> item, int index, BuildContext context) {
    return Text(
      '${item['days'].keys.elementAt(index)}',
      style: TextStyle(
        // decorationThickness: 6,
        color: context.read<ThemeProvider>().colorFromBrightnessIfConditionTrueOrElseAndIfDarkOrElse(
              condition: item['days'][item['days'].keys.elementAt(index)] && item['enabled'],
              fromColorIfTrueAndDark: context.read<ThemeProvider>().lightened(Colors.grey, 0)!,
              fromColorIfFalseAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.25)!,
              fromColorIfTrueAndLight: context.read<ThemeProvider>().darkened(Colors.grey, 0.15)!,
              fromColorIfFalseAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.1)!,
              colorToConvert: (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
            ),
        fontSize: 18,
        fontWeight: item['days'][item['days'].keys.elementAt(index)] ? FontWeight.bold : FontWeight.w500,
      ),
    );
  }
}

Widget reminderContainerFromItem(BuildContext context, Map<String, dynamic> item, int index, {isFrosted = false}) {
  // debugPrint('Reminder ${item['colorIndex']} built');

  Color fromColorIfDark = context.read<ThemeProvider>().darkened(Colors.grey, 0.55)!;
  Color fromColorIfLight = context.read<ThemeProvider>().lightened(Colors.grey, 0.33)!;

  return Stack(
    // alignment: Alignment.bottomRight,
    children: [
      GestureDetector(
        onTap: () {
          showNewReminderCreationDialog(
            context,
            currentColor_: (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
            days_: (item['days'] as Map<String, dynamic>).cast<String, bool>(),
            enabled_: item['enabled'],
            reminderTime_: DateTime.fromMillisecondsSinceEpoch(item['time']),
            title_: item['title'],
            index_: index,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: item['enabled']
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(3, 3),
                        blurRadius: 10,
                        spreadRadius: -8,
                        color: context.read<ThemeProvider>().colorFromBrightnessIfConditionTrueOrElseAndIfDarkOrElse(
                              condition: true,
                              fromColorIfTrueAndDark: context.read<ThemeProvider>().lightened(Colors.grey, 0.15)!,
                              fromColorIfFalseAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.35)!, //!
                              fromColorIfTrueAndLight: context.read<ThemeProvider>().lightened(Colors.white, 0.95)!,
                              fromColorIfFalseAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.15)!, //!
                              colorToConvert:
                                  (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
                            )!,
                      ),
                      BoxShadow(
                        offset: const Offset(-3, -3), // (-3, -3)
                        blurRadius: 10, // 10
                        spreadRadius: -8, // -7
                        color: context.read<ThemeProvider>().colorFromBrightnessIfConditionTrueOrElseAndIfDarkOrElse(
                              condition: true,
                              fromColorIfTrueAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.35)!,
                              fromColorIfFalseAndDark: context.read<ThemeProvider>().darkened(Colors.grey, 0.35)!, //!
                              fromColorIfTrueAndLight: context.read<ThemeProvider>().darkened(Colors.grey, 0.3)!,
                              fromColorIfFalseAndLight: context.read<ThemeProvider>().lightened(Colors.grey, 0.15)!, //!
                              colorToConvert:
                                  (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
                            )!,
                      )
                    ],
                  )
                : null,
            child: GlassContainer.frostedGlass(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context
                      .read<ThemeProvider>()
                      .colorFromBrightnessIfDarkOrElse(
                        fromColorIfDark: fromColorIfDark,
                        fromColorIfLight: fromColorIfLight,
                        colorToConvert:
                            (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
                      )!
                      .withOpacity(1), // 0.5 default
                  context
                      .read<ThemeProvider>()
                      .colorFromBrightnessIfDarkOrElse(
                        fromColorIfDark: fromColorIfDark,
                        fromColorIfLight: fromColorIfLight,
                        colorToConvert:
                            (item['colorIndex'] == null) ? Colors.grey : context.read<ListsProvider>().colorList[item['colorIndex']],
                      )!
                      .withOpacity(0.75), // 0.8 default
                ],
              ),
              //! alternate color
              // blur: 15.0,
              frostedOpacity: 0.6, //0.2
              //*
              margin: const EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(25),
              // borderWidth: 0,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
              // duration: const Duration(milliseconds: 1000),
              child: ReminderContainerContents(item: item), //! INNER CONTENTS
            ),
          ),
          // child: reminderFrostedContainerMainContents(item, context), //* UNFROSTED
        ),
      ),
      //* stack separation - trash icon after
      // Positioned(
      //   bottom: 0,
      //   right: 0,
      //   child: IconButton(
      //     onPressed: () {
      //       context.read<ListsProvider>().removeFromList(item);
      //     },
      //     icon: const FaIcon(FontAwesomeIcons.solidTrashCan),
      //     // color: Colors.redAccent,
      //     color: context.read<ThemeProvider>().colorOfAntiThemeBrightness(
      //           (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
      //           .2,
      //           Colors.grey,
      //         ),
      //     iconSize: 20,
      //   ),
      // ),
    ],
  );
}

void showNewReminderCreationDialog(
  BuildContext context, {
  Color? currentColor_,
  String? title_,
  bool? enabled_,
  DateTime? reminderTime_,
  Map<String, bool>? days_,
  int? index_,
}) {
  //
  bool isColorPickerActive = false;
  final TextEditingController titleController = TextEditingController();
  titleController.text = title_ ?? '';
  final FocusNode titleFocusNode = FocusNode();

  Color? reminderColor = currentColor_;
  String title = title_ ?? '';
  bool enabled = enabled_ ?? true;
  DateTime reminderTime = reminderTime_ ?? DateTime.now();
  Map<String, bool> days = days_ ??
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
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: context.read<ThemeProvider>().backgroundEsqueColor(color: reminderColor ?? Colors.grey, amount: 0.4),
            title: SizedBox(
              // color: Colors.grey,
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
                      color: context.read<ThemeProvider>().colorOfAntiThemeBrightness(
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
                        inactiveTrackColor: context.read<ThemeProvider>().colorOfThemeBrightness(
                              reminderColor,
                              .2,
                              // Colors.grey,
                            ),
                        activeTrackColor: context.read<ThemeProvider>().colorOfAntiThemeBrightness(
                              reminderColor,
                              .2,
                              Colors.grey.shade600,
                            ),
                        activeColor: context.read<ThemeProvider>().colorOfThemeBrightness(
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
            titlePadding: const EdgeInsets.all(0.0),
            actionsPadding: const EdgeInsets.symmetric(vertical: 10),
            actionsAlignment: MainAxisAlignment.center,
            // ! content
            content: Container(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  context.read<ThemeProvider>().backgroundEsqueColor(color: reminderColor ?? Colors.grey, amount: 0.4),
                  context.read<ThemeProvider>().backgroundEsqueColor(color: reminderColor ?? Colors.grey, amount: 0.5),
                  context.read<ThemeProvider>().backgroundEsqueColor(color: reminderColor ?? Colors.grey, amount: 0.5),
                  context.read<ThemeProvider>().backgroundEsqueColor(color: reminderColor ?? Colors.grey, amount: 0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: Column(
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
                                    days[entry.key] = !days[entry.key]!;
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
                                    color: days[entry.key]!
                                        ? context.read<ThemeProvider>().colorOfAntiThemeBrightness(
                                              reminderColor,
                                              .2,
                                              Colors.grey,
                                            )
                                        : null,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      entry.key,
                                      style: TextStyle(
                                        color: context.read<ThemeProvider>().colorOfThemeBrightnessIfTrueAndViceVersa(
                                              days[entry.key]!,
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
                      //   color: context.read<ThemeProvider>().colorOfThemeBrightness(
                      //     reminderColor,
                      //     0.25,
                      //   ),
                      //   shape: ,
                      // ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: context.read<ThemeProvider>().colorOfAntiThemeBrightness(
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
                            color: context.read<ThemeProvider>().colorOfThemeBrightness(
                                      reminderColor,
                                      0.2,
                                    ) ??
                                (context.read<ThemeProvider>().isThemeDark ? Colors.grey.shade700 : Colors.grey.shade400),
                          ),
                          highlightedTextStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: context.read<ThemeProvider>().colorOfAntiThemeBrightness(
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
            ),
            contentPadding: const EdgeInsets.all(0.0),

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
                    (index_ == null)
                        ? context.read<ListsProvider>().addToList(
                              colorIndexFromColor: reminderColor,
                              title: title,
                              days: days,
                              selectedTime: reminderTime,
                              enabled: enabled,
                            )
                        : context.read<ListsProvider>().updateListAtIndex(
                              index: index_,
                              colorIndexFromColor: reminderColor,
                              title: title,
                              days: days,
                              selectedTime: reminderTime,
                              enabled: enabled,
                            );
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  (index_ == null) ? 'Create' : 'Update',
                  style: TextStyle(
                    color: context.read<ThemeProvider>().isThemeDark ? Colors.white : Colors.black,
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
