import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const WogApp());
}

class WogApp extends StatelessWidget {
  const WogApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins', 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),
      ),
      home: const MainHomePage(),
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;

  // Screens list for Navigation
  final List<Widget> _screens = [
    const HomeScreenContent(), // Index 0: Home with Notifications
    const BibleListScreen(),   // Index 1: Bible
    const PlaceholderScreen(title: "Songs"), // Index 2
    const PlaceholderScreen(title: "Books"), // Index 3
    const PlaceholderScreen(title: "Live Stream"), // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        title: const Text("WOG APP", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // BOTTOM NAVIGATION BAR (Meeru adigina buttons ikkadiki marchanu)
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Crafted by Grace Message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: Colors.white,
            child: Center(
              child: Text(
                "Crafted by God's Grace",
                style: TextStyle(color: Colors.indigo[900], fontSize: 12, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
              ),
            ),
          ),
          NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) => setState(() => _currentIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.auto_stories_rounded), label: 'Bible'),
              NavigationDestination(icon: Icon(Icons.music_note_rounded), label: 'Songs'),
              NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Books'),
              NavigationDestination(icon: Icon(Icons.sensors_rounded), label: 'Live'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1A237E)),
            accountName: Text("World of God", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            accountEmail: Text("v1.0 - Official App"),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.church, color: Color(0xFF1A237E), size: 40)),
          ),
          _drawerTile(Icons.history_edu_rounded, "Tracker"),
          _drawerTile(Icons.headset_rounded, "Audio Messages"),
          _drawerTile(Icons.emoji_events_rounded, "Bible Quiz"),
          const Spacer(),
          const Divider(),
          _drawerTile(Icons.info_outline_rounded, "About Us"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A237E)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () => Navigator.pop(context),
    );
  }
}

// HOME PAGE CONTENT (Notifications Section)
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: Text("Daily Notifications", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A237E))),
          ),
          // Notification 1
          _notifItem(Icons.bolt_rounded, Colors.redAccent, "Today's Verse", "The Lord is my Shepherd, I shall not want."),
          // Notification 2
          _notifItem(Icons.event_note_rounded, Colors.blueAccent, "Sunday Service", "Join us live at 10:00 AM this Sunday."),
          // Notification 3
          _notifItem(Icons.quiz_rounded, Colors.orangeAccent, "New Quiz", "Bible Quiz #42 is now open for participants."),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 160,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3F51B5)]),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.2), blurRadius: 15)],
      ),
      child: const Center(
        child: Text("దేవుని వాక్యం జీవమున్నది", 
          style: TextStyle(fontFamily: 'Mallanna', color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _notifItem(IconData icon, Color color, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black87)),
            Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ])),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }
}
class BibleListScreen extends StatefulWidget {
  const BibleListScreen({super.key});
  @override
  State<BibleListScreen> createState() => _BibleListScreenState();
}

class _BibleListScreenState extends State<BibleListScreen> {
  List _books = [];
  @override
  void initState() {
    super.initState();
    loadBible();
  }
  Future<void> loadBible() async {
    try {
      final String res = await rootBundle.loadString('assets/bible.json');
      final data = json.decode(res);
      setState(() => _books = data["books"]);
    } catch (e) { print(e); }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _books.length,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        child: ListTile(
          title: Text(_books[i]["name"], style: const TextStyle(fontFamily: 'Mallanna', fontSize: 24)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            VerseScreen(chapterNum: 1, verses: _books[i]["chapters"][0]["verses"]))),
        ),
      ),
    );
  }
}

class VerseScreen extends StatelessWidget {
  final int chapterNum;
  final List verses;
  const VerseScreen({super.key, required this.chapterNum, required this.verses});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chapter $chapterNum")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: verses.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "${verses[i]["number"]}. ", style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w800, fontSize: 18)),
                TextSpan(text: verses[i]["text"], style: const TextStyle(fontFamily: 'Mallanna', color: Colors.black87, fontSize: 22, height: 1.6)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("$title Coming Soon", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)));
  }
}
