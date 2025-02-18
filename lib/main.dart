import 'package:flutter/material.dart';

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

  var words = <String>[];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo Home Page "),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          children: [

            Row(children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: InputDecoration(hintText: "type the item here",
                    border: OutlineInputBorder(),),),
              ),
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(hintText: "type the quantity here",
                    border: OutlineInputBorder(),),
                ),
              ),

              ElevatedButton(onPressed: (){
                if(_itemController.value.text.isNotEmpty && _quantityController.text.isNotEmpty) {
                  setState(() {
                    words.add("${_itemController.text} quantity: ${_quantityController.text}");
                    _itemController.text = "";  // empty the field after adding item
                    _quantityController.text = "";
                  });
                }else{
                  const snackBar= SnackBar(content: Text("Please add item"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                };
              }, child: Text("Click here"))
            ],),

            Expanded(
                child: ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, rowNum) {
                      return GestureDetector(
                        onLongPress: (){
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: Text("Delete?"),
                              content: Text ("Are you sure you want to delete the item?"),
                              actions: [
                                ElevatedButton(onPressed: (){
                                  setState(() {
                                    words.removeAt(rowNum);
                                    Navigator.pop(context);
                                  });
                                },
                                  child: Text("Yes"),),
                                ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                                },
                                  child: Text("No"),)
                              ],
                            );
                          });
                        },
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Text("${rowNum + 1}:"),
                            Text(words[rowNum])
                          ],),
                      );
                    }
                )
            )],
        ),
      ),
    );
  }
}
