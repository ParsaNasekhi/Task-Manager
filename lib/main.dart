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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<ListData> listBox = Hive.box<ListData>("ListBox");
    if (listBox.values.toList().isEmpty) {
      final ListData listData = ListData()..listName = "Default";
      listBox.add(listData);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Colors.deepPurple.shade700,
          onPrimary: Colors.black12,
          // seedColor: Colors.indigo,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
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
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    displayingPage = widget._displayingPage;
  }

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        if (_pageController.page! >= 0 && _pageController.page! <= 0.5) {
          displayingPage = DisplayingPage.homePage;
        } else if (_pageController.page! > 0.5 &&
            _pageController.page! <= 1.5) {
          displayingPage = DisplayingPage.listsPage;
        } else if (_pageController.page! > 1.5 && _pageController.page! <= 2) {
          displayingPage = DisplayingPage.donePage;
        }
      });
    });

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          HomePage(),
          ListsPage(),
          DonePage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Builder(builder: (context) {
                if (displayingPage == DisplayingPage.homePage) {
                  return Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).primaryColor,
                  );
                } else {
                  return const Icon(Icons.home_outlined);
                }
              }),
              onPressed: () {
                setState(() {
                  displayingPage = DisplayingPage.homePage;
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeInOut);
                });
              },
            ),
            IconButton(
              icon: Builder(builder: (context) {
                if (displayingPage == DisplayingPage.listsPage) {
                  return Icon(
                    Icons.list_alt_outlined,
                    color: Theme.of(context).primaryColor,
                  );
                } else {
                  return const Icon(Icons.list_alt_outlined);
                }
              }),
              onPressed: () {
                setState(() {
                  displayingPage = DisplayingPage.listsPage;
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeInOut);
                });
              },
            ),
            IconButton(
              icon: Builder(builder: (context) {
                if (displayingPage == DisplayingPage.donePage) {
                  return Icon(
                    Icons.done_outline,
                    color: Theme.of(context).primaryColor,
                  );
                } else {
                  return const Icon(Icons.done_outline);
                }
              }),
              onPressed: () {
                setState(() {
                  displayingPage = DisplayingPage.donePage;
                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeInOut);
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
