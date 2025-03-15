import 'package:flutter/material.dart';
import 'package:lab2/database.dart';
import 'package:lab2/todo_Dao.dart';
import 'package:lab2/todo_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var words = <TodoItem>[];

  late ToDoDAO myDAO;

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  TodoItem? selectedItem;


  @override
  void initState(){
    super.initState();

    $FloorAppDatabase.databaseBuilder('app_database.db').build().then((database){
// get the database DAO object
      myDAO = database.todoDao;
      myDAO.getAllItems().then((listOfItems) {
// add the items from the database
        setState(() {
          words.clear();
          words.addAll(listOfItems);
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;
          if (!isWideScreen && selectedItem != null) {
            return DetailsPage(
              item: selectedItem!,
              onDelete: () {
                setState(() {
                  myDAO.deleteItem(selectedItem!);
                  words.remove(selectedItem);
                  selectedItem = null;
                });
              },
              onClose: () {
                setState(() {
                  selectedItem = null;
                });
              },
            );
          }
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _itemController,
                              decoration: const InputDecoration(
                                hintText: "Type the item here",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _quantityController,
                              decoration: const InputDecoration(
                                hintText: "Type the quantity here",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
                                setState(() {
                                  var newItem = TodoItem(TodoItem.ID++, _itemController.text, _quantityController.text);
                                  myDAO.insertItem(newItem);
                                  words.add(newItem);
                                  _itemController.clear();
                                  _quantityController.clear();
                                });
                              } else {
                                const snackBar = SnackBar(content: Text("Please add item"));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                            child: const Text("Add"),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: words.length,
                          itemBuilder: (context, rowNum) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedItem = words[rowNum];
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(words[rowNum].itemName),
                                  subtitle: Text("Quantity: ${words[rowNum].quantity}"),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isWideScreen)
                Expanded(
                  flex: 1,
                  child: selectedItem == null
                      ? const Center(child: Text("Select an item to view details"))
                      : DetailsPage(
                    item: selectedItem!,
                    onDelete: () {
                      setState(() {
                        myDAO.deleteItem(selectedItem!);
                        words.remove(selectedItem);
                        selectedItem = null;
                      });
                    },
                    onClose: () {
                      setState(() {
                        selectedItem = null;
                      });
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final TodoItem item;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const DetailsPage({super.key, required this.item, required this.onDelete, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Item Name: ${item.itemName}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Quantity: ${item.quantity}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Database ID: ${item.id}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: onDelete, child: const Text("Delete")),
                ElevatedButton(onPressed: onClose, child: const Text("Close")),
              ],
            )
          ],
        ),
      ),
    );
  }//
}
