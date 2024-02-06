import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/screens/done/done_page.dart';
import 'package:task_manager/screens/home/home_page.dart';
import 'package:task_manager/screens/lists/lists_page.dart';

import 'db/list/list_data.dart';
import 'db/task/task_data.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ImportanceLevelAdapter());
  await Hive.openBox<Task>("TaskBox");
  Hive.registerAdapter(ListDataAdapter());
  await Hive.openBox<ListData>("ListBox");
  runApp(const MyApp());
}

/*

1- search
2- empty page
3- shimmer effect
4- time and date
5- edit UI

*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final Box<ListData> listBox = Hive.box<ListData>("ListBox");
    if(listBox.values.toList().isEmpty) {
      final ListData listData = ListData()..listName = "Default";
      listBox.add(listData);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(DisplayingPage.homePage),
    );
  }

}

class MainPage extends StatefulWidget {

  final DisplayingPage _displayingPage;

  const MainPage(this._displayingPage, {super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DisplayingPage displayingPage;

  @override
  void initState() {
    super.initState();
    displayingPage = widget._displayingPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        if (displayingPage == DisplayingPage.homePage) {
          return const HomePage();
        } else if (displayingPage == DisplayingPage.listsPage) {
          return const ListsPage();
        } else {
          return const DonePage();
        }
      }),
      bottomNavigationBar: BottomAppBar(
        elevation: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Builder(builder: (context) {
                if (displayingPage == DisplayingPage.homePage) {
                  return const Icon(
                    Icons.home_outlined,
                    color: Colors.blue,
                  );
                } else {
                  return const Icon(Icons.home_outlined);
                }
              }),
              onPressed: () {
                setState(() {
                  displayingPage = DisplayingPage.homePage;
                });
              },
            ),
            IconButton(
              icon: Builder(builder: (context) {
                if (displayingPage == DisplayingPage.listsPage) {
                  return const Icon(
                    Icons.list_alt_outlined,
                    color: Colors.blue,
                  );
                } else {
                  return const Icon(Icons.list_alt_outlined);
                }
              }),
              onPressed: () {
                setState(() {
                  displayingPage = DisplayingPage.listsPage;
                });
              },
            ),
            IconButton(
              icon: Builder(builder: (context) {
                if (displayingPage == DisplayingPage.donePage) {
                  return const Icon(
                    Icons.done_outline,
                    color: Colors.blue,
                  );
                } else {
                  return const Icon(Icons.done_outline);
                }
              }),
              onPressed: () {
                setState(() {
                  displayingPage = DisplayingPage.donePage;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum DisplayingPage {
  homePage,
  listsPage,
  donePage,
}
