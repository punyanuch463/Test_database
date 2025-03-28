import 'package:flutter/material.dart';

import '../data/DatabaseHelper.dart';
import '../models/User.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text;
                  String password = passwordController.text;

                  if (isValidUsername(username) && isValidPassword(password)) {
                    int userId = await signUp(username, password);

                    if (userId != -1) {
                           print(
                          'Registration successful - UserID: $userId, Username: $username, Password: $password');
                      navigateToLoginScreen();
                    } else {
                      showErrorDialog(
                          'Registration failed. The username already exists.');
                    }
                  } else {
                    showErrorDialog('Invalid username or password..');
                  }
                },
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                     navigateToLoginScreen();
                },
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValidUsername(String username) {
   
    return username.isNotEmpty;
  }

  bool isValidPassword(String password) {
 
    return password.length >= 6;
  }

  Future<int> signUp(String username, String password) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;

   
    User? existingUser = await dbHelper.loginUser(username, password);
    if (existingUser != null) {
     
      return -1;
    }

 
    User newUser = User(username: username, password: password);
    int userId = await dbHelper.registerUser(newUser);

    return userId;
  }

  void showErrorDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void navigateToLoginScreen() {
  
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
