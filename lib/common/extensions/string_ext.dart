import 'package:todo_app_sqflite/common/enums/category_enum.dart';

extension StringExt on String {
  CategoryEnum fromStringToCategoryEnum() {
    switch (this) {
      case "Cooking":
        return CategoryEnum.Cooking;
      case "Exercise":
        return CategoryEnum.Exercise;
      default:
        return CategoryEnum.Exercise;
    }
  }
}
