import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/data/models/todo_model.dart';
import 'package:todo_app_sqflite/data/repositories/todo_repo.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepo todoRepo;

  bool isLoading = false;
  List<TodoModel> todos = [];
  List<TodoModel> filterdTodos = [];

  DateTime selectedDate = DateTime.now();

  // setter for selected date
  void setselectedDate(DateTime date) {
    selectedDate = date;
    log("set date called.....");
    filterTodosByDate(); // Ensure filter is applied when date changes
    notifyListeners();
  }

  TodoProvider(this.todoRepo);

  Future<void> filterTodosByDate() async {
    filterdTodos = todos.where((element) {
      log(isSameDay(element.date, selectedDate).toString());
      return isSameDay(element.date, selectedDate);
    }).toList();
    log("filtering : $filterdTodos");
    notifyListeners();
  }

  // get todos
  Future<void> getTodos() async {
    isLoading = true;
    notifyListeners();
    final todosData = await todoRepo.fetchTodos();
    todos = todosData
        .map(
          (todo) => TodoModel.fromJson(todo),
        )
        .toList();
    filterTodosByDate(); // Filter todos right after fetching
    isLoading = false;
    notifyListeners();
  }

  // add new todo
  Future<void> addTodo({
    required String title,
    required String dateTime,
    required CategoryEnum category,
  }) async {
    isLoading = true;
    notifyListeners();
    await todoRepo.addNewTodo(
      title: title,
      dateTime: dateTime,
      category: category,
    );
    isLoading = false;
    await getTodos();
    notifyListeners();
  }

  // update todo
  Future<void> updateTodo({
    required int id,
    required String title,
    required String dateTime,
  }) async {
    isLoading = true;
    notifyListeners();
    await todoRepo.updateTodo(
      id: id,
      title: title,
      dateTime: dateTime,
    );
    isLoading = false;
    await getTodos();
    notifyListeners();
  }

  // remove todo
  Future<void> removeTodo({required int id}) async {
    await todoRepo.removeTodo(id: id);
  }
}
