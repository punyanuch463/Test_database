import 'package:flutter/material.dart';
import 'package:quan_ly_benh_nhan_sqlite/data/DatabaseHelper.dart'; // Import your DatabaseHelper class
import 'package:quan_ly_benh_nhan_sqlite/models/Patient.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/login_screen.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/manager_patients.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/manager_record.dart';

import '../main.dart'; // Import your Patient class

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required Map<String, dynamic> userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  Future<void> loadPatients() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    patients = await dbHelper.getAllPatients();
    setState(() {}); // Refresh the UI after loading patients
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Handle "Home" tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Manage Patients'),
              onTap: () {
                // Handle "Manage Patients" tap
                // You can navigate to the corresponding screen or perform any action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerPatients()),
                ); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Manage Medical Records'),
              onTap: () {
                // Handle "Manage Medical Records" tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerRecord()),
                );
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Handle "Settings" tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Handle "Logout" tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
                // Implement logout logic, navigate to the login screen, etc.
              },
            ),
          ],
        ),
      ),
      body: patients.isNotEmpty
          ? ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(patients[index].name),
                  subtitle: Text(
                      'Age: ${patients[index].age}, Gender: ${patients[index].gender}'),
                  // Add more patient details as needed
                );
              },
            )
          : Center(
              child: Text('No patients available'),
            ),
    );
  }
}
