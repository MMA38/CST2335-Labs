import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:lab2/ProfilePage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{   const MyApp({super.key});

@override
Widget build(BuildContext context)
{
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(


      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const MyHomePage(title: 'Week 4'),
  routes: {
  '/profile': (context) => ProfilePage(loginName: '',)
  }
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

  EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  late TextEditingController _controllerLogin;
  late TextEditingController _controllerPassword;
  var imageSource = "images/question.png";

  @override
  void initState() {
    super.initState();
    _controllerLogin = TextEditingController();
    _controllerPassword = TextEditingController();
    //_controller.text = "The new text"; //initialize the texfield
    loadEncryptedPrefs();
  }

  @override
  void dispose() {
    _controllerLogin.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  void saveEncryptedPrefs()  {
    encryptedSharedPreferences.setString('LoginName', _controllerLogin.text).then((bool success1) {
      if (success1) {
        encryptedSharedPreferences.setString('password', _controllerPassword.text).then((bool success2) {
          if (success2) {
            snackBar('User Name and password saved successfully');
          } else {
            snackBar('Failed to save');
          }
        });
      } else {
        snackBar('Failed to save');
      }
    });
  }

  void loadEncryptedPrefs() {
    //retrieve username
    encryptedSharedPreferences.getString('LoginName').then((loginName) {
      _controllerLogin.text = loginName;
      //if username retrieved then retrieve pswd
      encryptedSharedPreferences.getString('password').then((password) {
        _controllerPassword.text = password;
        //if username and password retrieved print a succes message
        if (loginName!='' && password != '' )
          snackBar('Username and Password have been Loaded');
      });
    });
  }

  void ClearEncryptedPrefs() {
    encryptedSharedPreferences.clear().then((bool success) {
      if (success) {
        snackBar('All saved Usernames and Password have been removed');
      } else {
        snackBar('Usernames and Password have not been removed');
      }
    });
  }

  void ResetFields(){
    _controllerLogin.text ='';
    _controllerPassword.text = '';
  }

  void snackBar(String message){
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',  // Button label
        onPressed: () {
          ResetFields();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold( //modifi
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title,
          style: TextStyle(
            fontSize: 24, // Change size
            fontWeight: FontWeight.bold, // Make bold
            color: Colors.black87, // Change color
          ),
        ),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextField(controller: _controllerLogin,
                decoration: InputDecoration(
                    hintText:"",
                    border: OutlineInputBorder(),
                    labelText: "Log in"
                )
            ),

            TextField(controller: _controllerPassword,
                obscureText:true,
                decoration: InputDecoration(
                  hintText:"",
                  border: OutlineInputBorder(),
                  labelText: "Password",

                )
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');

                String password = _controllerPassword.value.text;
                setState(() {
                  if(password=="QWERTY123")
                    imageSource = "images/idea.png";
                  else
                    imageSource = "images/stop.png";

                });

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Save information ! '),
                    content: const Text('Would like to save username and password?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          saveEncryptedPrefs();
                          Navigator.pop(context);
                        },
                        child: Text('Yes', style: TextStyle(fontSize: 30, color: Colors.blueAccent)),
                      ),
                      TextButton(
                        onPressed: () {
                          ClearEncryptedPrefs();
                          Navigator.pop(context);
                        },
                        child: Text('No', style: TextStyle(fontSize: 30, color: Colors.blueAccent)),
                      ),
                    ],//action
                  ),
                );
              },
              child: Text('Login',
                  style: TextStyle(fontSize: 30, color: Colors.blueAccent)),
            ),
/*
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () => ResetFields(),
                child: Text ('Reset Fields',
                  //style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                ),
              ), //
            ),*/
            Image.asset(imageSource, width: 300, height: 300),

          ],
        ),
      ),

    );
  }
}
