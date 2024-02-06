import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/screens/home/edit_page.dart';

import '../../db/task/task_data.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  final Box<Task> _taskBox = Hive.box<Task>("TaskBox");
  List<Task> _tasksList = [];

  @override
  Widget build(BuildContext context) {
    _tasksList = [];
    _taskBox.values.toList().forEach((element) {
      if (element.isDone) {
        _tasksList.add(element);
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Done"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: List.generate(_tasksList.length, (index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Do you want to remove this task?", style: TextStyle(fontSize: 20),),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("NO")),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _tasksList[index].delete();
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
                    MaterialPageRoute(builder: (context) => EditPage(_tasksList[index], "DonePage")),);
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
                              value: _tasksList[index].isDone,
                              onChanged: (value) {
                                setState(() {
                                  _tasksList[index].isDone = value as bool;
                                  _tasksList[index].save();
                                });
                              }),
                          Flexible(
                            flex: 20,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    _tasksList[index].title,
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
                              color: _tasksList[index].importanceLevel ==
                                  ImportanceLevel.highImportance
                                  ? Colors.red
                                  : _tasksList[index].importanceLevel ==
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
