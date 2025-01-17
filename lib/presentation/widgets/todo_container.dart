// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app_sqflite/data/models/todo_model.dart';
import 'package:todo_app_sqflite/providers/todo_provider.dart';

class TodoContainer extends StatelessWidget {
  final TodoModel todo;
  final TodoProvider todoProvider;
  const TodoContainer({
    super.key,
    required this.todo,
    required this.todoProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.teal,
          ),
          child: Row(
            children: [
              Checkbox(
                value: todo.status == 1,
                onChanged: (value) {
                  // TODO implement checkbox change behavior
                },
              ),
              Text(todo.title.toString()),
            ],
          ),
        );
      },
    );
  }
}
