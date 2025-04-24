import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'screens/complaintlist.dart';
import 'screens/upload.dart';
import 'screens/profile.dart';
import 'screens/login/loginscreen.dart'; // Import login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure the binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase before the app starts
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Help App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(), // Check authentication status
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Firebase auth stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in, show home screen
            return MyHomePage();
          } else {
            // User is not logged in, show login screen
            return LoginScreen();
          }
        }
        // While checking auth state, show loading screen
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ComplaintlistScreen(), // Home screen
    AddComplaintScreen(), // Upload screen
    ProfileScreen(), // Profile screen (you can complete this later)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Help App'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
