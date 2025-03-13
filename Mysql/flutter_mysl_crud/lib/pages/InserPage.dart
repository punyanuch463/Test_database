import 'package:flutter/material.dart';
import 'package:flutter_mysl_crud/DatabaseHelper.dart';

class InsertPage extends StatelessWidget {
  const InsertPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Insert User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.insertUser(
                  usernameController.text,
                  emailController.text,
                  ageController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User inserted successfully!')),
                );
              },
              child: const Text('Insert User'),
            ),
          ],
        ),
      ),
    );
  }
}
