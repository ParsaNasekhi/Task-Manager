import 'package:hive_flutter/hive_flutter.dart';

part 'task_data.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {

  @HiveField(0)
  String title = "";

  @HiveField(1)
  bool isDone = false;

  @HiveField(2)
  ImportanceLevel importanceLevel = ImportanceLevel.normalImportance;

  @HiveField(3)
  String listName = "";

  @HiveField(4)
  String details = "";

}

@HiveType(typeId: 1)
enum ImportanceLevel {
  @HiveField(0)
  highImportance,
  @HiveField(1)
  normalImportance,
  @HiveField(2)
  lowImportance,
}