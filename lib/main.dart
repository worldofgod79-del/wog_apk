import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const WogApp());
}

class WogApp extends StatelessWidget {
  const WogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WOG APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Starting point
    );
  }
}

// 1. ENTRANCE LOGO (SPLASH SCREEN)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 seconds tharvatha Home Page ki velthundi
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mee logo image ikkada replace cheyali
            Icon(Icons.auto_awesome, size: 100, color: Colors.blue), 
            SizedBox(height: 20),
            Text("WOG APP", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 2. HOME PAGE WITH SIDE MENU & BOTTOM BUTTONS
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Bottom Buttons Pages
  final List<Widget> _pages = [
    const Center(child: Text('FULL BIBLE - LOADING...')),
    const Center(child: Text('SONGS - LOADING...')),
    const Center(child: Text('BOOKS - LOADING...')),
    const Center(child: Text('LIVE - LOADING...')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WOG APP"),
        backgroundColor: Colors.blue[50],
      ),
      // SIDE MENU (DRAWER)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('WOG MENU', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _buildDrawerItem(Icons.track_changes, 'TRACKER'),
            _buildDrawerItem(Icons.audiotrack, 'AUDIO MASSAGES'),
            _buildDrawerItem(Icons.quiz, 'QUIZ'),
            _buildDrawerItem(Icons.contact_mail, 'CONTACT US'),
            _buildDrawerItem(Icons.info, 'ABOUT US'),
            _buildDrawerItem(Icons.share, 'SHARE THIS APP'),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      // BOTTOM BUTTONS
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'FULL BIBLE'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'SONGS'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'BOOKS'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'LIVE'),
        ],
      ),
    );
  }

  // Common UI for Drawer Items
  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Menu ni close chestundi
        // Specific screen ki velle logic ikkada rastam
      },
    );
  }
}
