import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_manager/screens/home/edit_page.dart';

import '../../db/task/task_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final Box<Task> _taskBox = Hive.box<Task>("TaskBox");
  List<Task> _tasksList = [];

  bool? _isPageEmpty;
  ImportanceLevel? _filteredImportanceLevel;

  @override
  Widget build(BuildContext context) {
    ImportanceLevel importanceLevel = ImportanceLevel.normalImportance;

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _tasksList = [];
        _taskBox.values.toList().forEach((element) {
          if (!element.isDone && _searchController.text.isEmpty) {
            if (_filteredImportanceLevel == null) {
              _tasksList.add(element);
            } else if (_filteredImportanceLevel ==
                ImportanceLevel.highImportance) {
              if (element.importanceLevel == ImportanceLevel.highImportance) {
                _tasksList.add(element);
              }
            } else if (_filteredImportanceLevel ==
                ImportanceLevel.normalImportance) {
              if (element.importanceLevel == ImportanceLevel.normalImportance) {
                _tasksList.add(element);
              }
            } else if (_filteredImportanceLevel ==
                ImportanceLevel.lowImportance) {
              if (element.importanceLevel == ImportanceLevel.lowImportance) {
                _tasksList.add(element);
              }
            }
          } else if (!element.isDone) {
            if (_filteredImportanceLevel == null) {
              if (element.title.startsWith(_searchController.text)) {
                _tasksList.add(element);
              }
            } else if (_filteredImportanceLevel ==
                ImportanceLevel.highImportance) {
              if (element.importanceLevel == ImportanceLevel.highImportance) {
                if (element.title.startsWith(_searchController.text)) {
                  _tasksList.add(element);
                }
              }
            } else if (_filteredImportanceLevel ==
                ImportanceLevel.normalImportance) {
              if (element.importanceLevel == ImportanceLevel.normalImportance) {
                if (element.title.startsWith(_searchController.text)) {
                  _tasksList.add(element);
                }
              }
            } else if (_filteredImportanceLevel ==
                ImportanceLevel.lowImportance) {
              if (element.importanceLevel == ImportanceLevel.lowImportance) {
                if (element.title.startsWith(_searchController.text)) {
                  _tasksList.add(element);
                }
              }
            }
          }
        });
        if (_tasksList.isEmpty) {
          _isPageEmpty = true;
        } else {
          _isPageEmpty = false;
        }
      });
    });

    final int length = _tasksList.length;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Home"),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: "Filter",
                    child: Text("Filter"),
                  ),
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
                } else if (value == "Delete all") {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            "Do you want to remove all tasks?",
                            style: TextStyle(fontSize: 20),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("NO")),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    for (var element in _tasksList) {
                                      element.delete();
                                    }
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("YES")),
                          ],
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, statSetter) {
                            return AlertDialog(
                                title: const Text("Importance Level:"),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: const Text(
                                                "High Importance",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              leading: Radio(
                                                value: ImportanceLevel
                                                    .highImportance,
                                                groupValue:
                                                    _filteredImportanceLevel,
                                                onChanged: (newValue) {
                                                  statSetter(() {
                                                    _filteredImportanceLevel =
                                                        newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text(
                                                "Normal Importance",
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              ),
                                              leading: Radio(
                                                value: ImportanceLevel
                                                    .normalImportance,
                                                groupValue:
                                                    _filteredImportanceLevel,
                                                onChanged: (newValue) {
                                                  statSetter(() {
                                                    _filteredImportanceLevel =
                                                        newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text(
                                                "Low Importance",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              leading: Radio(
                                                value: ImportanceLevel
                                                    .lowImportance,
                                                groupValue:
                                                    _filteredImportanceLevel,
                                                onChanged: (newValue) {
                                                  statSetter(() {
                                                    _filteredImportanceLevel =
                                                        newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text("No Filter"),
                                              leading: Radio(
                                                value: null,
                                                groupValue:
                                                    _filteredImportanceLevel,
                                                onChanged: (newValue) {
                                                  statSetter(() {
                                                    _filteredImportanceLevel =
                                                        newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ));
                          }));
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _taskController = TextEditingController();
            showDialog(
                context: context,
                builder: (context) =>
                    StatefulBuilder(builder: (context, statSetter) {
                      return AlertDialog(
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  if (_taskController.text.isNotEmpty) {
                                    setState(() {
                                      insertNewTask(_taskController.text,
                                          importanceLevel);
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
                          title: const Text('Add your task'),
                          content: SingleChildScrollView(
                            child: Container(
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 4),
                                    TextField(
                                      controller: _taskController,
                                      decoration: const InputDecoration(
                                        labelText: "Task Title",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                style:
                                                    TextStyle(color: Colors.orange),
                                              ),
                                              leading: Radio(
                                                value:
                                                    ImportanceLevel.normalImportance,
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
                                ),
                              ),
                            ),
                          ));
                    }));
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Card(
                  color: Colors.deepPurple.shade100,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded),
                          const SizedBox(width: 8),
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                _searchController.text = value;
                              },
                              controller: _searchController,
                              decoration: const InputDecoration(
                                labelText: "Search here",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _isPageEmpty == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                              ),
                            ),
                          ),
                        ],
                      ))
                  : _isPageEmpty != null && _isPageEmpty == false
                      ? Column(
                          children: List.generate(length, (index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Do you want to remove this task?",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("NO")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _tasksList[
                                                            length - index - 1]
                                                        .delete();
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: const Text("YES")),
                                          ],
                                          actionsAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                        );
                                      });
                                },
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => EditPage(
                                            _tasksList[length - index - 1],
                                            "HomePage")),
                                  );
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
                                    height:
                                        MediaQuery.sizeOf(context).height / 12,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                              value:
                                                  _tasksList[length - index - 1]
                                                      .isDone,
                                              onChanged: (value) {
                                                setState(() {
                                                  _tasksList[length - index - 1]
                                                      .isDone = value as bool;
                                                  _tasksList[length - index - 1]
                                                      .save();
                                                });
                                              }),
                                          Flexible(
                                            flex: 20,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    _tasksList[
                                                            length - index - 1]
                                                        .title,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: _tasksList[length -
                                                              index -
                                                              1]
                                                          .importanceLevel ==
                                                      ImportanceLevel
                                                          .highImportance
                                                  ? Colors.red
                                                  : _tasksList[length -
                                                                  index -
                                                                  1]
                                                              .importanceLevel ==
                                                          ImportanceLevel
                                                              .normalImportance
                                                      ? Colors.orange
                                                      : Colors.green,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(12),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(12),
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
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Icon(
                            Icons.no_backpack_outlined,
                            size: 256,
                          ),
                        )
            ],
          ),
        ));
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
}
