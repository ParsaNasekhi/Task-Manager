import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../db/task_data.dart';

class EditPage extends StatefulWidget {
  final Task _task;
  final int _index;

  const EditPage(this._task, this._index, {super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  Task _task = Task();
  int? _index;

  @override
  void initState() {
    super.initState();
    _task = widget._task;
    _index = widget._index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Edit Task"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Checkbox(
                  value: _task.isDone,
                  onChanged: (value) {
                    setState(() {
                      final Box<Task> box = Hive.box<Task>("TaskBox");
                      _task.isDone = value as bool;
                      _task.save();
                      box.values.toList()[_index!].isDone = value;
                    });
                  }),
              Flexible(
                flex: 20,
                child: Row(
                  children: [
                    Text(
                        "${_task.title}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Container(
              height: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
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
                    groupValue: _task.importanceLevel,
                    onChanged: (newValue) {
                      setState(() {
                        _task.importanceLevel = newValue!;
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
                    groupValue: _task.importanceLevel,
                    onChanged: (newValue) {
                      setState(() {
                        _task.importanceLevel = newValue!;
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
                    groupValue: _task.importanceLevel,
                    onChanged: (newValue) {
                      setState(() {
                        _task.importanceLevel = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Container(
              height: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: "Option 1",
                  items: <String>['Option 1', 'Option 2', 'Option 3']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      // _selectedValue = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: TextField(
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
        ],
      ),
    );
  }
}