import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/common/extensions/string_ext.dart';
import 'package:todo_app_sqflite/common/utils/typdefs.dart';

class TodoModel {
  final int? id;
  final String? title;
  final DateTime? date;
  final CategoryEnum? category;
  final int? status;

  TodoModel(
    this.id,
    this.title,
    this.date,
    this.category,
    this.status,
  );

  // fromJson to read data coming from local or remote
  factory TodoModel.fromJson(DataMap json) => TodoModel(
        json["id"],
        json["title"],
        DateTime.tryParse(json["date"]),
        json["category"].toString().fromStringToCategoryEnum(),
        json["status"],
      );

  // toJson method
  DataMap toJson(TodoModel todo) => {
        "id": todo.id,
        "title": todo.title,
        "date": todo.date,
        "category": todo.category,
        "status": todo.status,
      };
}
