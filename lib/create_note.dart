import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:popover/popover.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  String currentTitle = '';
  TextEditingController titleController = TextEditingController();
  // bool isTitleTextSubmitted = false;
  FocusNode focusNode = FocusNode();
  bool isColorPickerActive = false;

  Container textBox() {
    return Container(
      alignment: Alignment.center,
      // color: Colors.white,
      child: TextField(
        style: const TextStyle(
          fontSize: 20,
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
          ),
        ),
        // autofocus: true,
        onChanged: (text) => {
          setState(() {
            currentTitle = titleController.text;
            print(text);
          })
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      print(focusNode.hasFocus ? 'in' : 'out');
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: textBox(),
        // leading: IconButton(
        //   onPressed: () {
        //     showPopover(
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
          // onSelected: (value) {
          //   setState(() {
          //     print('tapped');
          //   });
          // },
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
          ),
          // elevation: 10,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.yellow,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.pink,
                    ),
                  )
                ],
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
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //         onPressed: () {
            //           setState(() {});
            //         },
            //         icon: const Icon(
            //           Icons.palette,
            //         ))
            //   ],
            // ),

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
