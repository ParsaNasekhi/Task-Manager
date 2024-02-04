import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/screens/home/edit_page.dart';

import '../../db/task_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ImportanceLevel importanceLevel = ImportanceLevel.normalImportance;
    final Box<Task> box = Hive.box<Task>("TaskBox");
    final List<Task> list = box.values.toList();
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
              builder: (context) =>
                  StatefulBuilder(builder: (context, statSetter) {
                    return AlertDialog(
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  setState(() {
                                    insertNewTask(
                                        controller.text, importanceLevel);
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                              child: const Text("Insert")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                        ],
                        title: const Text('Enter your task title'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                labelText: "Task Title",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Importance Level:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        "High Importance",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      leading: Radio(
                                        value: ImportanceLevel.highImportance,
                                        groupValue: importanceLevel,
                                        onChanged: (newValue) {
                                          statSetter(() {
                                            importanceLevel = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        "Normal Importance",
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                      leading: Radio(
                                        value: ImportanceLevel.normalImportance,
                                        groupValue: importanceLevel,
                                        onChanged: (newValue) {
                                          statSetter(() {
                                            importanceLevel = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        "Low Importance",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      leading: Radio(
                                        value: ImportanceLevel.lowImportance,
                                        groupValue: importanceLevel,
                                        onChanged: (newValue) {
                                          statSetter(() {
                                            importanceLevel = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ));
                  }));
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: List.generate(list.length, (index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Do you want to remove this task?"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("NO")),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    box.deleteAt(index);
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("YES")),
                          ],
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                        );
                      });
                },
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditPage(list[index], index)),);
                },
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height / 12,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                              value: list[index].isDone,
                              onChanged: (value) {
                                setState(() {
                                  final Box<Task> box =
                                      Hive.box<Task>("TaskBox");
                                  final Task task = box.values.toList()[index];
                                  task.isDone = value as bool;
                                  task.save();
                                  box.values.toList()[index].isDone = value;
                                });
                              }),
                          Flexible(
                            flex: 20,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    list[index].title,
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 10,
                            decoration: BoxDecoration(
                              color: list[index].importanceLevel ==
                                      ImportanceLevel.highImportance
                                  ? Colors.red
                                  : list[index].importanceLevel ==
                                          ImportanceLevel.normalImportance
                                      ? Colors.orange
                                      : Colors.green,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

void insertNewTask(String text, ImportanceLevel importanceLevel) {
  final Task task = Task()
    ..title = text
    ..importanceLevel = importanceLevel;
  if (task.isInBox) {
    task.save(); // update
  } else {
    final Box<Task> box = Hive.box<Task>("TaskBox");
    box.add(task); // insert
  }
  // print("log: ${list[0]}");
  // final Box<Task> box = Hive.box<Task>("TaskBox");
  // print(box.values.toList()[12].title);
}
