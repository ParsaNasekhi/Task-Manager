import 'package:hive_flutter/adapters.dart';

part 'task_data.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {

  @HiveField(0)
  String title = "";

}
