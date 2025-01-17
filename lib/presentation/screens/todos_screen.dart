import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/data/models/todo_model.dart';
import 'package:todo_app_sqflite/presentation/widgets/todo_container.dart';
import 'package:todo_app_sqflite/providers/todo_provider.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final titleController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (todoProvider.isLoading) {
          return Container(
            color: Colors.white,
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            child: Column(
              children: [
                TableCalendar(
                  onDaySelected: (selectedDay, focusedDay) {
                    todoProvider.setselectedDate(selectedDay);
                    todoProvider.filterTodosByDate();
                  },
                  onPageChanged: (focusedDay) {
                    todoProvider.setselectedDate(focusedDay);
                    todoProvider.filterTodosByDate();
                  },
                  daysOfWeekHeight: 25,
                  firstDay: DateTime.utc(2025, 01, 01),
                  lastDay: DateTime.utc(2030, 3, 15),
                  focusedDay: todoProvider.selectedDate ?? DateTime.now(),
                  calendarFormat: CalendarFormat.week,
                  selectedDayPredicate: (day) {
                    return isSameDay(todoProvider.selectedDate, day);
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.purple),
                    selectedDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 5, 95, 169),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: todoProvider.filterdTodos.length,
                    itemBuilder: (context, index) {
                      final TodoModel todo = todoProvider.filterdTodos[index];
                      return Dismissible(
                        key: Key(todo.id.toString()),
                        background: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            titleController.text = todo.title ?? "";
                            selectedDate = todo.date ?? DateTime.now();
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit Todo"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: titleController,
                                        decoration: InputDecoration(
                                          hintText: "Edit todo title",
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Text("Selected Date: "),
                                          IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            onPressed: () async {
                                              final DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2020),
                                                lastDate: DateTime(2030),
                                              );
                                              if (pickedDate != null) {
                                                selectedDate = pickedDate;
                                                (context as Element)
                                                    .markNeedsBuild();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        todoProvider.updateTodo(
                                          id: todo.id!, // Use the actual id
                                          title: titleController.text.trim(),
                                          dateTime:
                                              selectedDate.toIso8601String(),
                                        );
                                        titleController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                            return false;
                          } else if (direction == DismissDirection.endToStart) {
                            await todoProvider.removeTodo(id: todo.id!);
                            return true;
                          }
                          return false;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TodoContainer(
                            todo: todo,
                            todoProvider: todoProvider,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Add Todo"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: "Enter todo title",
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text("Selected Date: "),
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (pickedDate != null) {
                                  selectedDate = pickedDate;
                                  (context as Element).markNeedsBuild();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<TodoProvider>().addTodo(
                                title: titleController.text.trim(),
                                dateTime: selectedDate.toIso8601String(),
                                category: CategoryEnum.Exercise,
                              );
                          titleController.clear();
                          Navigator.pop(context);
                        },
                        child: Text("Add"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
