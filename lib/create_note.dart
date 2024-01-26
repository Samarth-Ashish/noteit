import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:popover/popover.dart';
// import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'main.dart';
import 'package:provider/provider.dart';

Color? darken(Color? color, [double amount = .1]) {
  if (color == null) {
    return null;
  }

  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color? lighten(Color? color, [double amount = .1]) {
  if (color == null) {
    return null;
  }

  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  String currentTitle = '';
  TextEditingController titleController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isColorPickerActive = false;
  Color? currentColor;
  List<Color> colorList = [
    Colors.transparent,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.pink,
    // Colors.orange
  ];

  Container titleTextField() {
    return Container(
      alignment: Alignment.center,
      // color: Colors.white,
      child: TextField(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        focusNode: focusNode,
        controller: titleController,
        decoration: InputDecoration(
          border: focusNode.hasFocus
              ? const UnderlineInputBorder()
              : InputBorder.none,
          hintText: 'Title',
          hintStyle: const TextStyle(
            fontSize: 20,
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
    );
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      debugPrint(focusNode.hasFocus ? 'in' : 'out');
      setState(() {});
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: (currentColor != null)
          ? ThemeData(
              //!Usual
              // primarySwatch: MaterialColor(1, ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: currentColor!,
                background: currentColor!,
                brightness: Provider.of<ThemeProvider>(context).isDark
                    ? Brightness.dark
                    : Brightness.light,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: currentColor!,
                actionsIconTheme: IconThemeData(
                  color: darken(currentColor, .5),
                ),
                iconTheme: IconThemeData(
                  color: darken(currentColor, .5),
                ),
              ),
            )
          : Provider.of<ThemeProvider>(context).currentTheme,
      // // ),
      // data: FlexThemeData.dark(// !FlexThemeData
      //     // scheme: FlexScheme.mallardGreen,
      //     // colors: FlexColorScheme.createPrimarySwatch(Colors.blue),
      //     // blendLevel: 1,
      //     ),
      //
      child: Scaffold(
        // backgroundColor: currentColor,
        // extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: titleTextField(),
          // leading: IconButton(
          //   onPressed: () {
          //     showPopover(//!showPopover
          //       context: context,
          //       bodyBuilder: (context) => Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 8),
          //         child: ListView(
          //           padding: const EdgeInsets.all(8),
          //           children: [
          //             InkWell(
          //               // onTap: () {
          //               //   Navigator.of(context)
          //               //     ..pop()
          //               //     ..push(
          //               //       MaterialPageRoute<SecondRoute>(
          //               //         builder: (context) => SecondRoute(),
          //               //       ),
          //               //     );
          //               // },
          //               child: Container(
          //                 height: 50,
          //                 color: Colors.amber[100],
          //                 child: const Center(child: Text('Entry A')),
          //               ),
          //             ),
          //             const Divider(),
          //             Container(
          //               height: 50,
          //               color: Colors.amber[200],
          //               child: const Center(child: Text('Entry B')),
          //             ),
          //             const Divider(),
          //             Container(
          //               height: 50,
          //               color: Colors.amber[300],
          //               child: const Center(child: Text('Entry C')),
          //             ),
          //           ],
          //         ),
          //       ),
          //       onPop: () => print('Popover was popped!'),
          //       direction: PopoverDirection.bottom,
          //       width: 200,
          //       height: 400,
          //       arrowHeight: 15,
          //       arrowWidth: 30,
          //     );
          //   },
          //   icon: const Icon(
          //     Icons.palette,
          //   ),
          // ),
          leading: PopupMenuButton(
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
              isColorPickerActive ? Icons.palette_outlined : Icons.palette,
            ),
            // elevation: 10,
            itemBuilder: (context) => [
              PopupMenuItem(
                // value: 1,
                child: Row(
                  children: List.generate(
                    colorList.length,
                    (index) => IconButton(
                      onPressed: () {
                        setState(() {
                          print(colorList[index]);
                          currentColor = colorList[index] == Colors.transparent
                              ? null
                              : colorList[index].withOpacity(0.5);
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
            offset: const Offset(0, 60),
            // color: Colors.grey,
            // elevation: 2,
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.more_vert),
            //   onPressed: () {},
            // )
            PopupMenuButton(
              itemBuilder: (context) => [
                // popupmenu item 1
                const PopupMenuItem(
                  value: 1,
                  // row has two child icon and text.
                  child: Row(
                    children: [
                      Icon(Icons.star),
                      SizedBox(
                        // sized box with width 10
                        width: 10,
                      ),
                      Text("Get The App")
                    ],
                  ),
                ),
                // popupmenu item 2
                const PopupMenuItem(
                  value: 2,
                  // row has two child icon and text
                  child: Row(
                    children: [
                      Icon(Icons.chrome_reader_mode),
                      SizedBox(
                        // sized box with width 10
                        width: 10,
                      ),
                      Text("About")
                    ],
                  ),
                ),
              ],
              // offset: const Offset(0, 100),
              // color: Colors.grey,
              // elevation: 2,
            ),
          ],
        ),
        body: const SizedBox(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.amber,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note',
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: currentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
