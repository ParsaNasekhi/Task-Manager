import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/screens/done_page.dart';
import 'package:task_manager/screens/home_page.dart';
import 'package:task_manager/screens/lists_page.dart';

import 'db/task_data.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>("TaskBox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Task Manager'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DisplayingPage displayingPage = DisplayingPage.homePage;

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
