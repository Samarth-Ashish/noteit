import 'package:flutter/material.dart';
import 'package:noteit/pages/common_widgets.dart';
// import 'dart:ui';

// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../modified_packages/curved_navigation_bar_modified/curved_navigation_bar_modified.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/list_provider.dart';
import '../providers/theme_provider.dart';
import 'reminder_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // debugPrint('\n\n\n\n=====\n HOMEPAGE BUILT \n=====\n');
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.read<ThemeProvider>().isThemeDark
            ? context.read<ThemeProvider>().darkened(Colors.grey, 0.5)
            : context.read<ThemeProvider>().lightened(Colors.grey, 0.25),
        drawer: appDrawer(context),
        extendBodyBehindAppBar: true,
        appBar: CommonAppBar(context, widget.title),
        //
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: reminderListViewBuilder(context),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          shape: const CircleBorder(),
          onPressed: () {
            // showModal(context);
            showNewReminderCreationDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        //
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: Colors.blue.shade900,
          backgroundColor: Colors.transparent,
          color: Colors.blue.withOpacity(0.25),
          animationDuration: const Duration(milliseconds: 350),
          height: 55,
          items: const [
            FaIcon(FontAwesomeIcons.solidClock),
            // Icon(Icons.home),
            Icon(Icons.alarm),
            Icon(Icons.compare_arrows),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(
                  context,
                  '/homePage',
                );
                break;
              case 1:
                Navigator.pushReplacementNamed(
                  context,
                  '/timerPage',
                );
                break;
              case 2:
                Navigator.pushReplacementNamed(
                  context,
                  '/stopwatchPage',
                );
                break;
              default:
                break;
            }
          },
        ),
        //
      ),
    );
  }

  Drawer appDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.read<ThemeProvider>().isThemeDark
                  ? context.read<ThemeProvider>().darkened(Colors.grey, 0.45)
                  : context.read<ThemeProvider>().lightened(Colors.grey, 0.25),
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: context.read<ThemeProvider>().isThemeDark
                    ? context.read<ThemeProvider>().darkened(Colors.grey, 0.45)
                    : context.read<ThemeProvider>().lightened(Colors.grey, 0.25),
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
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete all reminders'),
            onTap: () {
              context.read<ListsProvider>().resetNotes();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget reminderListViewBuilder(BuildContext context) {
    // debugPrint('=====\n LISTVIEW BUILT \n=====\n');
    return ListView.builder(
      cacheExtent: 9999,
      physics: const BouncingScrollPhysics(),
      itemCount: context.select((ListsProvider L) => L.lists.length),
      itemBuilder: (context, index) {
        // debugPrint('item $index built--');
        final item = context.watch<ListsProvider>().lists[index];
        return reminderContainerFromItem(context, item, index);
      },
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
