import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bordered_text/bordered_text.dart';

import 'package:provider/provider.dart';
import '../providers/list_provider.dart';
import '../providers/theme_provider.dart';

class ReminderContainer extends StatelessWidget {
  final Map<String, dynamic> item;

  const ReminderContainer({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BorderedText(
                  strokeWidth: context.select((ListsProvider L) => item['enabled']) ? 4 : 0,
                  strokeColor: context.select((ListsProvider L) => item['enabled'])
                      ? context.read<ThemeProvider>().colorOfThemeBrightness(
                            (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                            .3, // 0.3
                            Colors.grey,
                          )!
                      : Colors.transparent,
                  child: Text(
                    DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(item['time'])).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: context.read<ThemeProvider>().colorOfAntiThemeBrightness(
                            (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                            .2,
                            Colors.grey,
                          ),
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
                    child: ToggleReminderSwitch(item: item),
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
}




class ToggleReminderSwitch extends StatelessWidget {
  final Map<String, dynamic> item;

  const ToggleReminderSwitch({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Switch ${item['colorIndex']} built \n ----------- \n');

    return Switch(
      activeTrackColor: context.read<ThemeProvider>().colorOfAntiThemeBrightness(
            (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
            .2,
            Colors.grey.shade600,
          ),
      activeColor: context.read<ThemeProvider>().colorOfThemeBrightness(
            (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
            .2,
            Colors.grey.shade600,
          ),
      // inactiveThumbColor: (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
      inactiveTrackColor: Colors.transparent,
      value: context.select((ListsProvider L) => item['enabled']),
      onChanged: (value) => context.read<ListsProvider>().setEnable(item, value),
    );
  }
}




class WeekdayRow extends StatelessWidget {
  final Map<String, dynamic> item;

  const WeekdayRow({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('weekdays row ${item['colorIndex']}\n----');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(
        item['days'].keys.length,
        (index) => Flexible(
          // child: GlassContainer.frostedGlass(
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
            fit: BoxFit.scaleDown,
            child: item['days'][item['days'].keys.elementAt(index)]
                ? BorderedText(
                    strokeWidth: context.select((ListsProvider L) => item['enabled'])
                        ? (item['days'][item['days'].keys.elementAt(index)] ? 6 : 0)
                        : (item['days'][item['days'].keys.elementAt(index)] ? 3.5 : 0),
                    strokeColor: context.select((ListsProvider L) => item['enabled'])
                        ? context.read<ThemeProvider>().colorOfThemeBrightnessIfTrueAndViceVersa(
                              item['days'][item['days'].keys.elementAt(index)],
                              (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                              .3, // 0.3
                              Colors.grey,
                            )!.withOpacity(1)
                        : context.read<ThemeProvider>().colorOfThemeBrightnessIfTrueAndViceVersa(
                              item['days'][item['days'].keys.elementAt(index)],
                              (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                              0.4, // 0.3
                              Colors.grey,
                            )!.withOpacity(0.7),
                    // strokeColor: context.select((ListsProvider L) => item['enabled'])
                    //     ? context.read<ThemeProvider>().colorOfAntiThemeBrightnessIfTrueAndViceVersa(
                    //           item['days'][item['days'].keys.elementAt(index)],
                    //           (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                    //           .3, // 0.3
                    //           Colors.grey,
                    //         )!.withOpacity(1)
                    //     : context.read<ThemeProvider>().colorOfThemeBrightnessIfTrueAndViceVersa(
                    //           item['days'][item['days'].keys.elementAt(index)],
                    //           (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
                    //           0.3, // 0.3
                    //           Colors.grey,
                    //         )!.withOpacity(0.5),
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
        decorationThickness: 6,
        // color: context.read<ThemeProvider>().colorOfThemeBrightnessIfTrueAndViceVersa(
        //       item['days'][item['days'].keys.elementAt(index)],
        //       (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
        //       0.1, // 0.3
        //       Colors.grey,
        //     ),
        color: context.read<ThemeProvider>().colorOfAntiThemeBrightness(
              (item['colorIndex'] == null) ? null : context.read<ListsProvider>().colorList[item['colorIndex']],
              0.1, // 0.3
              Colors.grey,
            ),
        fontSize: 18,
        fontWeight: item['days'][item['days'].keys.elementAt(index)] ? FontWeight.bold : FontWeight.w500,
      ),
    );
  }
}
