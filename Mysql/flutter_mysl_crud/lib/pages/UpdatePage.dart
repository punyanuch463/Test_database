import 'package:flutter/material.dart';
import 'package:flutter_mysl_crud/DatabaseHelper.dart';

class UpdatePage extends StatefulWidget {
  final String username;
  final String email;
  final String age;

  const UpdatePage({
    super.key,
    required this.username,
    required this.email,
    required this.age,
  });

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController emailController;
  late TextEditingController ageController;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
    ageController = TextEditingController(text: widget.age);

    // บังคับให้ email TextField ได้รับโฟกัส
    Future.delayed(Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(emailFocusNode);
    });
  }

  void _updateUser() async {
    bool success = await DatabaseHelper.updateUser(
      widget.username,
      emailController.text,
      ageController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
      Navigator.pop(context, true); // ส่งค่า true กลับไปที่ UserListPage
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update user')));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    ageController.dispose();
    emailFocusNode.dispose();
    ageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              focusNode: emailFocusNode, // เพิ่ม FocusNode
              decoration: const InputDecoration(labelText: 'New Email'),
            ),
            TextField(
              controller: ageController,
              focusNode: ageFocusNode, // เพิ่ม FocusNode
              decoration: const InputDecoration(labelText: 'New Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}
