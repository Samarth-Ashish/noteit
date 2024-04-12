// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:popover/popover.dart';
// // import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'main.dart';
// import 'package:provider/provider.dart';

// Color? darken(Color? color, [double amount = .1]) {
//   if (color == null) {
//     return null;
//   }

//   assert(amount >= 0 && amount <= 1);

//   final hsl = HSLColor.fromColor(color);
//   final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

//   return hslDark.toColor();
// }

// Color? lighten(Color? color, [double amount = .1]) {
//   if (color == null) {
//     return null;
//   }

//   assert(amount >= 0 && amount <= 1);

//   final hsl = HSLColor.fromColor(color);
//   final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

//   return hslLight.toColor();
// }

// class CreateNotePage extends StatefulWidget {
//   const CreateNotePage({super.key});

//   @override
//   State<CreateNotePage> createState() => _CreateNotePageState();
// }

// class _CreateNotePageState extends State<CreateNotePage> {
//   late String currentTitle;
//   late Color? currentColor;
//   late bool isColorPickerActive;
//   late TextEditingController titleController;

//   late FocusNode titleFocusNode;

//   List<Color> colorList = [
//     Colors.transparent,
//     Colors.green,
//     Colors.blue,
//     // Colors.yellow,
//     Colors.red,
//     Colors.pink,
//     // Colors.orange
//   ];

//   @override
//   void initState() {
//     super.initState();

//     currentTitle = '';
//     currentColor = null;
//     isColorPickerActive = false;
//     titleFocusNode = FocusNode();
//     titleController = TextEditingController();

//     titleFocusNode.addListener(() {
//       print(titleFocusNode.hasFocus ? 'in' : 'out');
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     titleFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: (currentColor != null)
//           ? ThemeData(
//               //!Usual
//               // primarySwatch: MaterialColor(1, ),
//               colorScheme: ColorScheme.fromSeed(
//                 seedColor: currentColor!,
//                 background: Provider.of<ThemeProvider>(context).isThemeDark
//                     ? darken(currentColor!)
//                     : lighten(currentColor!),
//                 // background: currentColor!,
//                 // inversePrimary: currentColor,
//                 brightness: Provider.of<ThemeProvider>(context).isThemeDark
//                     ? Brightness.dark
//                     : Brightness.light,
//               ),
//               appBarTheme: AppBarTheme(
//                 // backgroundColor: currentColor!,
//                 // backgroundColor: Theme.of(context).colorScheme.background,
//                 backgroundColor: Provider.of<ThemeProvider>(context).isThemeDark
//                     ? darken(currentColor!, .15)
//                     : lighten(currentColor!, .15),
//                 actionsIconTheme: IconThemeData(
//                   color: Provider.of<ThemeProvider>(context).isThemeDark
//                       ? lighten(currentColor!, .3)
//                       : darken(currentColor!, .3),
//                 ),
//                 iconTheme: IconThemeData(
//                   color: Provider.of<ThemeProvider>(context).isThemeDark
//                       ? lighten(currentColor!, .3)
//                       : darken(currentColor!, .3),
//                 ),
//               ),
//             )
//           : Provider.of<ThemeProvider>(context).currentTheme,
//       // // ),
//       // data: FlexThemeData.dark(// !FlexThemeData
//       //     // scheme: FlexScheme.mallardGreen,
//       //     // colors: FlexColorScheme.createPrimarySwatch(Colors.blue),
//       //     // blendLevel: 1,
//       //     ),
//       //
//       child: Scaffold(
//         // backgroundColor: currentColor,
//         // extendBody: true,
//         appBar: AppBar(
//           centerTitle: true,
//           automaticallyImplyLeading: false,
//           title: titleTextField(),
//           // leading: IconButton(
//           //   onPressed: () {
//           //     showPopover(//!showPopover
//           //       context: context,
//           //       bodyBuilder: (context) => Padding(
//           //         padding: const EdgeInsets.symmetric(vertical: 8),
//           //         child: ListView(
//           //           padding: const EdgeInsets.all(8),
//           //           children: [
//           //             InkWell(
//           //               // onTap: () {
//           //               //   Navigator.of(context)
//           //               //     ..pop()
//           //               //     ..push(
//           //               //       MaterialPageRoute<SecondRoute>(
//           //               //         builder: (context) => SecondRoute(),
//           //               //       ),
//           //               //     );
//           //               // },
//           //               child: Container(
//           //                 height: 50,
//           //                 color: Colors.amber[100],
//           //                 child: const Center(child: Text('Entry A')),
//           //               ),
//           //             ),
//           //             const Divider(),
//           //             Container(
//           //               height: 50,
//           //               color: Colors.amber[200],
//           //               child: const Center(child: Text('Entry B')),
//           //             ),
//           //             const Divider(),
//           //             Container(
//           //               height: 50,
//           //               color: Colors.amber[300],
//           //               child: const Center(child: Text('Entry C')),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //       onPop: () => print('Popover was popped!'),
//           //       direction: PopoverDirection.bottom,
//           //       width: 200,
//           //       height: 400,
//           //       arrowHeight: 15,
//           //       arrowWidth: 30,
//           //     );
//           //   },
//           //   icon: const Icon(
//           //     Icons.palette,
//           //   ),
//           // ),
//           leading: PopupMenuButton(
//             //!PopupMenuButton
//             onOpened: () {
//               setState(() {
//                 isColorPickerActive = true;
//               });
//             },
//             onCanceled: () {
//               setState(() {
//                 isColorPickerActive = false;
//               });
//             },
//             onSelected: (value) {
//               setState(() {
//                 isColorPickerActive = false;
//                 debugPrint('tapped');
//               });
//             },
//             icon: Icon(
//               isColorPickerActive ? Icons.palette_outlined : Icons.palette,
//             ),
//             // elevation: 10,
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 1,
//                 child: Row(
//                   children: List.generate(
//                     colorList.length,
//                     (index) => IconButton(
//                       onPressed: () {
//                         setState(() {
//                           print(colorList[index]);
//                           currentColor = colorList[index] == Colors.transparent
//                               ? null
//                               : colorList[index];
//                         });
//                       },
//                       icon: colorList[index] != Colors.transparent
//                           ? Icon(
//                               Icons.circle,
//                               color: colorList[index],
//                             )
//                           : Icon(
//                               Icons.water_drop_rounded,
//                               color: Theme.of(context).highlightColor,
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//             offset: const Offset(0, 60),
//             // color: Colors.grey,
//             // elevation: 2,
//           ),
//           actions: [
//             // IconButton(
//             //   icon: const Icon(Icons.more_vert),
//             //   onPressed: () {},
//             // )
//             PopupMenuButton(
//               onOpened: () {},
//               itemBuilder: (context) => [
//                 // popupmenu item 1
//                 const PopupMenuItem(
//                   value: 1,
//                   child: Row(
//                     children: [
//                       Icon(Icons.star),
//                       SizedBox(
//                         // sized box with width 10
//                         width: 10,
//                       ),
//                       Text("Get The App")
//                     ],
//                   ),
//                 ),
//                 // popupmenu item 2
//               ],
//               // offset: const Offset(0, 100),
//               // color: Colors.grey,
//               // elevation: 2,
//             ),
//           ],
//         ),
//         body: SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           // color: Colors.amber,
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 optionsMenu(),
//                 const TextField(
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Note',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           // backgroundColor: currentColor,
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Icon(Icons.check),
//         ),
//       ),
//     );
//   }

//   Row optionsMenu() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         // Container(
//         //   width: 10,
//         //   height: 10,
//         //   color: Colors.blue,
//         // ),
//         const Icon(
//           Icons.notification_add,
//         ),
//         // Icon(
//         //   Icons.notifications_active,
//         // ),
//         Switch(
//           inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
//           activeColor: Theme.of(context).colorScheme.onPrimary,
//           value: !Provider.of<ThemeProvider>(context, listen: false).isThemeDark,
//           onChanged: (value) => setState(() {
//             Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
//             // print(Provider.of<ThemeProvider>(context, listen: false).isThemeDark);
//           }),
//         )
//       ],
//     );
//   }

//   Container titleTextField() {
//     return Container(
//       alignment: Alignment.center,
//       // color: Colors.white,
//       child: TextField(
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//         textAlign: TextAlign.center,
//         focusNode: titleFocusNode,
//         controller: titleController,
//         decoration: InputDecoration(
//           border: titleFocusNode.hasFocus
//               ? const UnderlineInputBorder()
//               : InputBorder.none,
//           hintText: 'Title',
//           hintStyle: const TextStyle(
//             fontSize: 18,
//             // color: darken(currentColor, .9),
//             // decorationColor: Colors.yellow,
//             // backgroundColor: Colors.white,
//           ),
//         ),
//         // autofocus: true,
//         onChanged: (text) => {
//           setState(() {
//             currentTitle = titleController.text;
//             debugPrint(text);
//           })
//         },
//       ),
//     );
//   }
// }
