import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lab2/data_repo.dart';

class ProfilePage extends StatefulWidget {
  final String loginName;

  const ProfilePage({Key? key, required this.loginName}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DataRepository _repository = DataRepository();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData(); // Load stored user data on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome Back, ${widget.loginName}")),
      );
    });
  }

  void loadData() async {
    Map<String, String> data = await _repository.loadData();
    setState(() {
      firstNameController.text = data['firstName']!;
      lastNameController.text = data['lastName']!;
      phoneController.text = data['phone']!;
      emailController.text = data['email']!;
    });
  }

  void saveData() {
    _repository.saveData(
      firstNameController.text,
      lastNameController.text,
      phoneController.text,
      emailController.text,
    );
  }

  void launchUrlAction(Uri url, String errorMessage) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showErrorDialog(errorMessage);
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    saveData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome Back, ${widget.loginName}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(controller: firstNameController, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: lastNameController, decoration: InputDecoration(labelText: "Last Name")),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Phone Number"),
                  ),
                ),
                IconButton(icon: Icon(Icons.phone), onPressed: () => launchUrlAction(Uri(scheme: 'tel', path: phoneController.text), "Phone call is not supported on this device")),
                IconButton(icon: Icon(Icons.message), onPressed: () => launchUrlAction(Uri(scheme: 'sms', path: phoneController.text), "SMS is not supported on this device")),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                ),
                IconButton(icon: Icon(Icons.email), onPressed: () => launchUrlAction(Uri(scheme: 'mailto', path: emailController.text), "Email is not supported on this device")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
