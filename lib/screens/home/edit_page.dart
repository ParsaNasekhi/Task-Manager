import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/db/list/list_data.dart';
import 'package:task_manager/main.dart';

import '../../db/task/task_data.dart';

class EditPage extends StatefulWidget {
  final Task _task;

  const EditPage(this._task, {super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Task _task = Task();

  late final TextEditingController _taskNameController =
      TextEditingController();
  late final TextEditingController _taskDetailsController =
      TextEditingController();
  final TextEditingController _listNameController = TextEditingController();

  final Task _helperTask = Task();

  final Box<ListData> listBox = Hive.box<ListData>("ListBox");
  final List<String> listNameList = [];

  @override
  void initState() {
    super.initState();
    _task = widget._task;
    _helperTask
      ..title = _task.title
      ..isDone = _task.isDone
      ..importanceLevel = _task.importanceLevel
      ..details = _task.details
      ..listName = _task.listName;
    _taskDetailsController.text = _helperTask.details;
    listBox.values.toList().forEach((element) {
      listNameList.add(element.listName);
    });
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = _helperTask.title;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const MainPage(
                    title: 'Task Manager',
                  )),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Edit Task"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                        value: _helperTask.isDone,
                        onChanged: (value) {
                          setState(() {
                            _helperTask.isDone = value as bool;
                          });
                        }),
                    Flexible(
                      flex: 20,
                      child: Row(
                        children: [
                          Text(
                            _helperTask.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                            builder: (context, statSetter) {
                                          return AlertDialog(
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (_taskNameController
                                                          .text.isNotEmpty) {
                                                        setState(() {
                                                          _helperTask.title =
                                                              _taskNameController
                                                                  .text;
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      }
                                                    },
                                                    child: const Text("Apply")),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Cancel")),
                                              ],
                                              title: const Text(
                                                  'Edit your task title'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: _taskNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Task Title",
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                        }));
                              },
                              icon: const Icon(Icons.edit)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                child: Container(
                  height: 0.5,
                  color: Colors.grey.shade500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Importance Level:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    ListTile(
                      title: const Text(
                        "High Importance",
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: Radio(
                        value: ImportanceLevel.highImportance,
                        groupValue: _helperTask.importanceLevel,
                        onChanged: (newValue) {
                          setState(() {
                            _helperTask.importanceLevel = newValue!;
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
                        groupValue: _helperTask.importanceLevel,
                        onChanged: (newValue) {
                          setState(() {
                            _helperTask.importanceLevel = newValue!;
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
                        groupValue: _helperTask.importanceLevel,
                        onChanged: (newValue) {
                          setState(() {
                            _helperTask.importanceLevel = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: Container(
                  height: 0.5,
                  color: Colors.grey.shade500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: _helperTask.listName,
                      items: listNameList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _helperTask.listName = newValue!;
                        });
                      },
                    ),
                    ElevatedButton(onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                              builder: (context, statSetter) {
                                return AlertDialog(
                                    actionsAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            if (_listNameController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                insertNewList(_listNameController.text);
                                                listNameList.add(_listNameController.text);
                                                _listNameController.text = "";
                                                Navigator.of(context)
                                                    .pop();
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
                                    title: const Text(
                                        'Add New List'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _listNameController,
                                          decoration:
                                          const InputDecoration(
                                            labelText: "List Name",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    ));
                              }));
                    }, child: Text("New List"))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: TextField(
                  controller: _taskDetailsController,
                  maxLines: 8,
                  // controller: controller,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: "Details",
                    labelStyle: TextStyle(),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      _task
                        ..title = _helperTask.title
                        ..isDone = _helperTask.isDone
                        ..importanceLevel = _helperTask.importanceLevel
                        ..details = _taskDetailsController.text
                        ..listName = _helperTask.listName;
                      _task.save();
                    },
                    child: const Text("Save Changes"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void insertNewList(String name) {
  final ListData listData = ListData()
    ..listName = name;
  if (!listData.isInBox) {
    final Box<ListData> box = Hive.box<ListData>("ListBox");
    box.add(listData); // insert
  }
  // print("log: ${list[0]}");
  // final Box<Task> box = Hive.box<Task>("TaskBox");
  // print(box.values.toList()[12].title);
}