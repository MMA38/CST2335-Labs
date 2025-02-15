import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:lab2/ProfilePage.dart';
import 'package:lab2/data_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Week 4'),
      routes: {
        '/profile': (context) => ProfilePage(loginName: ''),
      },
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
  final EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  final TextEditingController _controllerLogin = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final DataRepository _repository = DataRepository();

  var imageSource = "images/question.png";
  String? savedPassword;

  @override
  void initState() {
    super.initState();
    loadEncryptedPrefs();
  }

  @override
  void dispose() {
    _controllerLogin.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  void saveEncryptedPrefs() async {
    await _repository.saveLoginData(_controllerLogin.text, _controllerPassword.text);
    print("Password saved: ${_controllerPassword.text}");
    snackBar('User Name and password saved successfully');
  }


  void loadEncryptedPrefs() async {
    print("Loaded saved password: $savedPassword");
    Map<String, String> loginData = await _repository.loadLoginData();
    setState(() {
      _controllerLogin.text = loginData['loginName']!;
      _controllerPassword.text = loginData['password']!;
      savedPassword = loginData['password'];
    });

    if (loginData['loginName']!.isNotEmpty && loginData['password']!.isNotEmpty) {
      snackBar('Username and Password have been Loaded');
    }
  }

  void clearEncryptedPrefs() async {
    await _repository.clearLoginData();
    snackBar('All saved Usernames and Passwords have been removed');
  }

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.green,
      ),
    );
  }

  void promptToSavePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Would you like to save your password for future logins?"),
        action: SnackBarAction(
          label: "Yes",
          onPressed: () {
            saveEncryptedPrefs();
          },
        ),
        duration: Duration(seconds: 15),
      ),
    );
  }

  void login() async {
    String enteredPassword = _controllerPassword.text;
    Map<String, String> loginData = await _repository.loadLoginData();
    String? savedPassword = loginData['password'];

    print("Entered password: $enteredPassword");
    print("Saved password: $savedPassword");

    if (savedPassword == null || savedPassword.isEmpty) {
      // First-time login: Prompt user to save password
      promptToSavePassword();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(loginName: _controllerLogin.text),
        ),
      );
    } else if (enteredPassword == savedPassword) {
      // Successful login with stored password
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(loginName: _controllerLogin.text),
        ),
      );
    } else {
      snackBar("Incorrect password. Try again!");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controllerLogin,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Log in",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controllerPassword,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20, color: Colors.blueAccent),
              ),
            ),
            SizedBox(height: 20),
            Image.asset(imageSource, width: 300, height: 300),
          ],
        ),
      ),
    );
  }
}
