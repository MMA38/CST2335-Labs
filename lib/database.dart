// database.dart

// required package imports
import 'dart:async';
import 'package:lab2/todo_Dao.dart';

import 'todo_Dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'todo_item.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [TodoItem])
abstract class AppDatabase extends FloorDatabase{
  ToDoDAO get todoDao;
}