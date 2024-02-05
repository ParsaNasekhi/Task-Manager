import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../db/list/list_data.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          children: List.generate(listBox.length, (index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 64,
                  height: MediaQuery.of(context).size.width / 2 - 64,
                  child: Card(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(listBox.values.toList()[index].listName, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20), maxLines: 3, overflow: TextOverflow.ellipsis,),
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

void insertNewList(String name) {
  final ListData listData = ListData()
    ..listName = name;
  if (!listData.isInBox) {
    final Box<ListData> box = Hive.box<ListData>("ListBox");
    box.add(listData); // insert
  }
}
