// import 'package:flutter/material.dart';
// import 'package:quan_ly_benh_nhan_sqlite/screens/login_screen.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) =>
//           ThemeProvider(context), // Pass context to ThemeProvider
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'My App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         primarySwatch: Colors.teal,
//         brightness: Brightness.dark,
//       ),
//       themeMode: Provider.of<ThemeProvider>(context).currentTheme,
//       home: const LoginScreen(),
//     );
//   }
// }

// class ThemeProvider with ChangeNotifier {
//   final BuildContext context; // Add context property

//   ThemeProvider(this.context); // Constructor to initialize context

//   ThemeMode _currentTheme = ThemeMode.system;

//   ThemeMode get currentTheme => _currentTheme;

//   bool get isDarkModeEnabled =>
//       _currentTheme == ThemeMode.dark ||
//       (_currentTheme == ThemeMode.system && isDarkModeSystem);

//   bool get isDarkModeSystem =>
//       MediaQuery.platformBrightnessOf(context) == Brightness.dark;

//   void toggleDarkMode() {
//     _currentTheme = isDarkModeEnabled
//         ? ThemeMode.light
//         : ThemeMode.dark; // Toggle between light and dark mode
//     notifyListeners();
//   }
// }

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({Key? key}) : super(key: key);

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Setting'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop(); // Go back to the previous screen
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Dark Mode'),
//                 Switch(
//                   value: Provider.of<ThemeProvider>(context).isDarkModeEnabled,
//                   onChanged: (value) {
//                     Provider.of<ThemeProvider>(context, listen: false)
//                         .toggleDarkMode();
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             InkWell(
//               onTap: () {
//                 // Handle logout
//                 // Example: Navigate to the login screen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               },
//               child: const Text(
//                 'Log out',
//                 style: TextStyle(
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/login_screen.dart';

// ------------ main.dart -------------
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      home: const LoginScreen(),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;

  bool get isDarkModeEnabled {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return _currentTheme == ThemeMode.dark ||
        (_currentTheme == ThemeMode.system && brightness == Brightness.dark);
  }

  void toggleDarkMode() {
    _currentTheme = isDarkModeEnabled ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

// ------------ SettingScreen -------------
class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: Provider.of<ThemeProvider>(context).isDarkModeEnabled,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleDarkMode();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // เพิ่มปุ่มไปยัง TransformCardExample
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TransformCardExample()),
                );
              },
              child: const Text(
                'Go to Transform Card',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------ TransformCardExample -------------
class TransformCardExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Transform Card Example"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(10, 10),
              child: Card(
                elevation: 0,
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox(
                  width: 250,
                  height: 150,
                ),
              ),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(0.05)
                ..scale(1.0)
                ..setEntry(2, 0, 6) // เพิ่มค่า z-axis ผิดปกติ
                ..setEntry(2, 1, 6), // เพิ่มอีกแกน
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: 250,
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Transform Card',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This card is rotated & translated!',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
