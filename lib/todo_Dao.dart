// todo_dao.dart

import 'package:floor/floor.dart';
import 'todo_item.dart';

@dao
abstract class ToDoDAO{

  @Query("Select * from TodoItem")
  Future<List<TodoItem>> getAllItems();

  @insert
  Future<void> insertItem(TodoItem itm);

  @delete
  Future<void> deleteItem(TodoItem itm);

}