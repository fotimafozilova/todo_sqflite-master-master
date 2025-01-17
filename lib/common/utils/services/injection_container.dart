import 'package:get_it/get_it.dart';
import 'package:todo_app_sqflite/data/local_datasource/local_data_source.dart';
import 'package:todo_app_sqflite/data/repositories/todo_repo.dart';
import 'package:todo_app_sqflite/providers/todo_provider.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt
    ..registerLazySingleton<LocalDataSource>(
      () => LocalDataSource(),
    )
    ..registerLazySingleton<TodoRepo>(
      () => TodoRepo(localDataSource: getIt()),
    )
    ..registerLazySingleton<TodoProvider>(
      () => TodoProvider(getIt()),
    );
}
