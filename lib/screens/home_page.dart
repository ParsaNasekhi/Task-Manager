import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../db/task_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller = TextEditingController();
          showDialog(
              context: context,
              builder: (crt) => AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          if(controller.text.isNotEmpty) {
                            insertNewTask(controller.text);
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Insert")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                  ],
                  title: Text('Enter your task title'),
                  content: TextField(
                    // maxLength: isNumOnly ? 12 : null,
                    controller: controller,
                    // keyboardType: isNumOnly ? TextInputType.number : null,
                    decoration: InputDecoration(
                      labelText: "Task Title",
                      border: const OutlineInputBorder(),
                    ),
                  )));
        },
        child: Icon(Icons.add),
      ),
      body: Center(),
    );
  }
}

void insertNewTask(String text) {
  final Task task = Task()
    ..title = text;
  if(task.isInBox) {
    task.save(); // update
  } else {
    final Box<Task> box = Hive.box<Task>("TaskBox");
    box.add(task); // insert
  }
  final Box<Task> box = Hive.box<Task>("TaskBox");
  print(box.values.toList()[12].title);
}
