import 'package:flutter/material.dart';
import 'package:flutter_mysl_crud/DatabaseHelper.dart';

class FetchPage extends StatelessWidget {
  const FetchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fetch Users')),
      body: FutureBuilder<List<Map<String, String>>>(
        future: DatabaseHelper.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          return ListView(
            children:
                snapshot.data!.map((user) {
                  return ListTile(
                    title: Text(user['username'] ?? ''),
                    subtitle: Text('${user['email']} - Age: ${user['age']}'),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
