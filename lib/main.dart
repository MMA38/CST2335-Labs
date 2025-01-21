import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

    );
  }
}
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  String imageSource = 'images/question.png'; // Initial Image

  void _checkPassword() {
    setState(() {
      if (_passwordController.text == 'QWERTY123') {
        imageSource = 'images/idea.png'; // Light Bulb Image
      } else {
        imageSource = 'images/stop.png'; // Stop Sign Image
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Flutter Demo Home Page")),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             TextField(
                decoration: InputDecoration(labelText: 'Login'),
            ),
              TextField(
                 controller: _passwordController,
                 obscureText: true,
                 decoration: InputDecoration(labelText: 'Password'),
            ),

            ElevatedButton(
              onPressed: _checkPassword,
              child: Text('Login'),
            ),

            Image.asset(
              imageSource,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
