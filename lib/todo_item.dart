import 'package:floor/floor.dart';

@entity
class TodoItem{
  static int ID=1;

  @primaryKey
  final int id;
  final String itemName;
  final String quantity;

  TodoItem( this.id, this.itemName, this.quantity){
    if(id>ID)
      ID=id+1;
  }
}

