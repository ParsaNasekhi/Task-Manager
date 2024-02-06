import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/db/list/list_data.dart';
import 'package:task_manager/main.dart';

import '../../db/task/task_data.dart';

class DoneTaskInfoPage extends StatelessWidget {
  final Task _task;

  late final TextEditingController _taskNameController =
      TextEditingController();
  late final TextEditingController _taskDetailsController =
      TextEditingController();

  final Task _helperTask = Task();

  final Box<ListData> listBox = Hive.box<ListData>("ListBox");
  final List<String> listNameList = [];

  DoneTaskInfoPage(this._task, {super.key});

  @override
  Widget build(BuildContext context) {
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

    _taskNameController.text = _helperTask.title;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const MainPage(DisplayingPage.donePage)),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Task Info"),
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
                    Checkbox(value: _helperTask.isDone, onChanged: (value) {}),
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
                        onChanged: (newValue) {},
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
                        onChanged: (newValue) {},
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
                        onChanged: (newValue) {},
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
                      items: [_helperTask.listName]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: TextField(
                  enabled: false,
                  controller: _taskDetailsController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: "Details",
                    labelStyle: TextStyle(),
                    border: OutlineInputBorder(),
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

