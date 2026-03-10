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
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        title: const Text("WOG APP", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.1)),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            
            // DAILY UPDATES SECTION
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text("Daily Updates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A237E))),
            ),
            _buildNotificationCard(),

            const Padding(
              padding: EdgeInsets.only(left: 24, top: 20, bottom: 12),
              child: Text("Explore", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A237E))),
            ),
            _buildModernGrid(context),
            const SizedBox(height: 100), 
          ],
        ),
      ),
      // PREMIUM BOTTOM NAVIGATION MESSAGE
      bottomSheet: Container(
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Center(
          child: Text(
            "Crafted by God's Grace",
            style: TextStyle(fontFamily: 'Poppins', color: Colors.indigo[900], fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
            child: const Icon(Icons.bolt_rounded, color: Colors.redAccent, size: 24),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              "Today's Verse: 'The Lord is my Shepherd...'",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF3F51B5), Color(0xFF7986CB)],
        ),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.church_rounded, color: Colors.white70, size: 40),
            const SizedBox(height: 10),
            Text("దేవుని వాక్యం జీవమున్నది", 
              style: TextStyle(fontFamily: 'Mallanna', color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black26, blurRadius: 5)])),
          ],
        ),
      ),
    );
  }
  Widget _buildModernGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          _modernMenuCard(context, "BIBLE", Icons.auto_stories_rounded, [const Color(0xFFFF9100), const Color(0xFFFFAB40)], const BibleListScreen()),
          _modernMenuCard(context, "SONGS", Icons.music_note_rounded, [const Color(0xFF2979FF), const Color(0xFF448AFF)], const CommonPlaceholder(title: "Songs")),
          _modernMenuCard(context, "BOOKS", Icons.menu_book_rounded, [const Color(0xFF00C853), const Color(0xFF69F0AE)], const CommonPlaceholder(title: "Books")),
          _modernMenuCard(context, "LIVE", Icons.sensors_rounded, [const Color(0xFFFF1744), const Color(0xFFFF5252)], const CommonPlaceholder(title: "Live Stream")),
        ],
      ),
    );
  }

  Widget _modernMenuCard(BuildContext context, String title, IconData icon, List<Color> colors, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
          boxShadow: [BoxShadow(color: colors[0].withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Stack(
          children: [
            Positioned(right: -10, bottom: -10, child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.15))),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A237E)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () {},
    );
  }
}

// BIBLE logic continues (Chapter/Verse screens with Mallanna font)
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: _books.length,
        itemBuilder: (context, i) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          color: Colors.white,
          child: ListTile(
            title: Text(_books[i]["name"], style: const TextStyle(fontFamily: 'Mallanna', fontSize: 24, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.indigo),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
              VerseScreen(chapterNum: 1, verses: _books[i]["chapters"][0]["verses"]))),
          ),
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
                TextSpan(text: verses[i]["text"], style: const TextStyle(fontFamily: 'Mallanna', color: Colors.black87, fontSize: 23, height: 1.6)),
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
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.construction_rounded, size: 60, color: Colors.indigo[200]),
        const SizedBox(height: 15),
        Text("$title Section Coming Soon", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ])),
    );
  }
}
