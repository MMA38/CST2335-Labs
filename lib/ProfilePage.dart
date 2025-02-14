import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String loginName;

  const ProfilePage({Key? key, required this.loginName}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome Back, ${widget.loginName}")),
      );
    });
  }

  void loadData() async {
    firstNameController.text = await encryptedSharedPreferences.getString('firstName') ?? '';
    lastNameController.text = await encryptedSharedPreferences.getString('lastName') ?? '';
    phoneController.text = await encryptedSharedPreferences.getString('phone') ?? '';
    emailController.text = await encryptedSharedPreferences.getString('email') ?? '';
  }

  void saveData() {
    encryptedSharedPreferences.setString('firstName', firstNameController.text);
    encryptedSharedPreferences.setString('lastName', lastNameController.text);
    encryptedSharedPreferences.setString('phone', phoneController.text);
    encryptedSharedPreferences.setString('email', emailController.text);
  }

  void launchDialer() async {
    final Uri url = Uri(scheme: 'tel', path: phoneController.text);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showErrorDialog("Phone call is not supported on this device");
    }
  }

  void launchSMS() async {
    final Uri url = Uri(scheme: 'sms', path: phoneController.text);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showErrorDialog("SMS is not supported on this device");
    }
  }

  void launchEmail() async {
    final Uri url = Uri(scheme: 'mailto', path: emailController.text);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showErrorDialog("Email is not supported on this device");
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
                IconButton(icon: Icon(Icons.phone), onPressed: launchDialer),
                IconButton(icon: Icon(Icons.message), onPressed: launchSMS),
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
                IconButton(icon: Icon(Icons.email), onPressed: launchEmail),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
