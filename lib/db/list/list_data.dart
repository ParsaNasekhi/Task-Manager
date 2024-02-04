import 'package:hive_flutter/hive_flutter.dart';

part 'list_data.g.dart';

@HiveType(typeId: 2)
class ListData extends HiveObject {

  @HiveField(0)
  String listName = "";

}