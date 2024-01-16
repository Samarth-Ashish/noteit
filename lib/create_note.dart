import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  String currentTitle = 'Title'; 
  TextEditingController titleController = TextEditingController();
  bool isTitleTextSubmitted = false;
  FocusNode focusNode = FocusNode();
  
  Container TextBox() {
    return Container(
      alignment: Alignment.center,
      // color: Colors.white,
      child: TextField(
        textAlign: TextAlign.center,
        focusNode: focusNode,
        controller: titleController,
        decoration: InputDecoration(
          border: focusNode.hasFocus
              ? const UnderlineInputBorder()
              : InputBorder.none,
          hintText: 'Enter Title...',
        ),
        onChanged: (text) => {
          setState(() {
            currentTitle = titleController.text;
            // print(text);
          })
        },
        onSubmitted: (text) {
          setState(() {
            isTitleTextSubmitted = true;
            print('submitted');
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
        title: TextBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
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
