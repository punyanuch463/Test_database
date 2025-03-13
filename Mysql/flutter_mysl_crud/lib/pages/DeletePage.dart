import 'package:flutter/material.dart';
import 'package:flutter_mysl_crud/DatabaseHelper.dart';

class DeletePage extends StatelessWidget {
  const DeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Delete User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.deleteUser(usernameController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User deleted successfully!')),
                );
              },
              child: const Text('Delete User'),
            ),
          ],
        ),
      ),
    );
  }
}
