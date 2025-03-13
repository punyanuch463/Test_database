import 'package:flutter/material.dart';
import 'package:flutter_mysl_crud/DatabaseHelper.dart';
import 'package:flutter_mysl_crud/pages/DeletePage.dart';
import 'package:flutter_mysl_crud/pages/FetchPage.dart';
import 'package:flutter_mysl_crud/pages/InserPage.dart';
import 'package:flutter_mysl_crud/pages/UpdatePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<Map<String, String>>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = DatabaseHelper.fetchUsers();
  }

  void refreshUserList() {
    setState(() {
      futureUsers = DatabaseHelper.fetchUsers();
    });
  }

  Future<void> deleteUser(String username) async {
    await DatabaseHelper.deleteUser(username);
    refreshUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: FutureBuilder<List<Map<String, String>>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var user = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user['username'] ?? ''),
                  subtitle: Text('${user['email']} - Age: ${user['age']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => UpdatePage(
                                    username: user['username'] ?? '',
                                    email: user['email'] ?? '',
                                    age: user['age'] ?? '',
                                  ),
                            ),
                          ).then((updated) {
                            if (updated == true) {
                              refreshUserList();
                              setState(() {});
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: const Text(
                                    "Are you sure you want to delete this user?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteUser(user['username'] ?? '');
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertPage()),
          ).then((_) => refreshUserList());
        },
        tooltip: 'Add User',
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
