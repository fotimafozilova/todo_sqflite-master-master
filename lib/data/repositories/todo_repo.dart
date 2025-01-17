import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/common/utils/typdefs.dart';
import 'package:todo_app_sqflite/data/local_datasource/local_data_source.dart';

class TodoRepo {
  final LocalDataSource localDataSource;

  TodoRepo({
    required this.localDataSource,
  });

  // get todos
  Future<List<DataMap>> fetchTodos() async {
    return await localDataSource.getTodos();
  }

  // add new todo
  Future<bool> addNewTodo({
    required String title,
    required String dateTime,
    required CategoryEnum category,
  }) async {
    return await localDataSource.addTodo(
      title: title,
      dateTime: dateTime,
      category: category,
    );
  }

  // update todo
  Future<bool> updateTodo({
    required int id,
    required String title,
    required String dateTime,
  }) async {
    return await localDataSource.updateTodo(
      id: id,
      title: title,
      dateTime: dateTime,
    );
  }

  // remove todo
  Future<void> removeTodo({required int id}) async {
    await localDataSource.deleteTodo(id);
  }
}
