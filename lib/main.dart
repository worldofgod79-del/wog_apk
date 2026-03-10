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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainHomePage()));
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
            Icon(Icons.auto_awesome_rounded, size: 90, color: Color(0xFF1A237E)),
            SizedBox(height: 20),
            Text("WOG APP", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1A237E), letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("WOG APP", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            
            // DAILY NOTIFICATIONS SECTION
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Latest Updates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            _buildNotificationSection(),

            const Padding(
              padding: EdgeInsets.only(left: 20, top: 15, bottom: 10),
              child: Text("Main Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            _buildGridMenu(context),
            const SizedBox(height: 80), // Space for bottom bar
          ],
        ),
      ),
      // BOTTOM BAR FOR "CREATED BY GRACE"
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Center(
          child: Text(
            "Crafted by God's Grace",
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600], fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.indigo.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.redAccent),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              "Today's Bible Quiz is Live! Participated yet?",
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3949AB)]),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: const Center(
        child: Text("దేవుని వాక్యం జీవమున్నది", 
          style: TextStyle(fontFamily: 'Mallanna', color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          _menuCard(context, "BIBLE", Icons.menu_book_rounded, const Color(0xFFFF9100), const BibleListScreen()),
          _menuCard(context, "SONGS", Icons.music_note_rounded, const Color(0xFF2979FF), const CommonPlaceholder(title: "Songs")),
          _menuCard(context, "BOOKS", Icons.import_contacts_rounded, const Color(0xFF00C853), const CommonPlaceholder(title: "Books")),
          _menuCard(context, "LIVE", Icons.sensors_rounded, const Color(0xFFFF1744), const CommonPlaceholder(title: "Live Stream")),
        ],
      ),
    );
  }
  Widget _menuCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 25, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 28)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1A237E)),
            accountName: Text("World of God", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            accountEmail: Text("wogapp@official.com"),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.church, color: Color(0xFF1A237E), size: 35)),
          ),
          _drawerTile(Icons.track_changes_rounded, "Tracker"),
          _drawerTile(Icons.audio_file_rounded, "Audio Messages"),
          _drawerTile(Icons.quiz_rounded, "Quiz"),
          const Divider(),
          _drawerTile(Icons.info_rounded, "About Us"),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A237E)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {},
    );
  }
}

// BIBLE LOGIC REMAINS SAME
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
    final String res = await rootBundle.loadString('assets/bible.json');
    final data = json.decode(res);
    setState(() => _books = data["books"]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Holy Bible"), backgroundColor: const Color(0xFF1A237E), iconTheme: const IconThemeData(color: Colors.white)),
      body: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(_books[i]["name"], style: const TextStyle(fontFamily: 'Mallanna', fontSize: 24)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            VerseScreen(chapterNum: 1, verses: _books[i]["chapters"][0]["verses"]))), // Example logic
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
        padding: const EdgeInsets.all(16),
        itemCount: verses.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "${verses[i]["number"]}. ", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
                TextSpan(text: verses[i]["text"], style: const TextStyle(fontFamily: 'Mallanna', color: Colors.black87, fontSize: 22, height: 1.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommonPlaceholder extends StatelessWidget {
  final String title;
  const CommonPlaceholder({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text("$title Section Coming Soon")));
  }
}
