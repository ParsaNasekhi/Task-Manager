import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/screens/lists/a_list_page.dart';

import '../../db/list/list_data.dart';
import '../../db/task/task_data.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final TextEditingController _listNameController = TextEditingController();
  final Box<ListData> listBox = Hive.box<ListData>("ListBox");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Lists"),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "Delete all",
                  child: Text("Delete all"),
                ),
                const PopupMenuItem(
                  value: "Exit",
                  child: Text("Exit"),
                ),
              ];
            },
            onSelected: (value) {
              if (value == "Exit") {
                SystemNavigator.pop();
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Icon(Icons.delete_sweep_outlined),
                        actions: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    listBox.values.toList().forEach((element) {
                                      if (element != listBox.values.toList()[0]) {
                                        deleteList(element, false);
                                      }
                                    });
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text(
                                    "Delete all lists without their contents")),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    listBox.values.toList().forEach((element) {
                                      deleteList(
                                          element,
                                          element == listBox.values.toList()[0]
                                              ? null
                                              : true);
                                    });
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text(
                                    "Delete all lists with their contents")),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel the operation",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ),
                        ],
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                      );
                    });
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  StatefulBuilder(builder: (context, statSetter) {
                    return AlertDialog(
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                if (_listNameController.text.isNotEmpty) {
                                  setState(() {
                                    insertNewList(_listNameController.text);
                                    _listNameController.text = "";
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                              child: const Text("Add")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                        ],
                        title: const Text('Add New List'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _listNameController,
                              decoration: const InputDecoration(
                                labelText: "List Name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ));
                  }));
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Wrap(
            children: List.generate(listBox.length, (index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 64,
                  height: MediaQuery.of(context).size.width / 2 - 64,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AListPage(
                                listBox.values.toList()[index].listName)),
                      );
                    },
                    onLongPress: () {
                      if (index != 0) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Icon(Icons.delete_sweep_outlined),
                                actions: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            deleteList(
                                                listBox.values.toList()[index],
                                                false);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text(
                                            "Delete the list without its content")),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            deleteList(
                                                listBox.values.toList()[index],
                                                true);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text(
                                            "Delete the list with its content")),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel the operation",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ),
                                ],
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Icon(Icons.delete_sweep_outlined),
                                actions: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            deleteList(
                                                listBox.values.toList()[index],
                                                null);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text(
                                            "Delete the list content")),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel the operation",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ),
                                ],
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                              );
                            });
                      }
                    },
                    child: Card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            listBox.values.toList()[index].listName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: index == 0 ? Colors.blue : null),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

void insertNewList(String name) {
  final ListData listData = ListData()..listName = name;
  if (!listData.isInBox) {
    final Box<ListData> box = Hive.box<ListData>("ListBox");
    box.add(listData); // insert
  }
}

void deleteList(ListData listItem, bool? deleteWithContent) {
  final Box<Task> taskBox = Hive.box<Task>("TaskBox");
  if (deleteWithContent == null || deleteWithContent) {
    taskBox.values.toList().forEach((element) {
      if (element.listName == listItem.listName) {
        element.delete();
      }
    });
  } else {
    taskBox.values.toList().forEach((element) {
      if (element.listName == listItem.listName) {
        element.listName = "Default";
        element.save();
      }
    });
  }
  if (deleteWithContent != null) listItem.delete();
}
