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
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const SplashScreen(),
    );
  }
}

// 1. SPLASH SCREEN
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainHomePage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 80, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            const Text("WOG APP", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF1A237E))),
          ],
        ),
      ),
    );
  }
}

// 2. MAIN HOME PAGE
class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WOG APP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // SIDE MENU (EXACTLY AS PER YOUR IMAGE)
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1565C0)),
              accountName: Text("World of God", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: Text("Contact: wogapp@official.com"),
              currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.church, color: Color(0xFF1565C0), size: 40)),
            ),
            _drawerItem(Icons.track_changes, "TRACKER"),
            _drawerItem(Icons.audiotrack, "AUDIO MESSAGES"),
            _drawerItem(Icons.quiz, "QUIZ"),
            const Divider(thickness: 1),
            _drawerItem(Icons.contact_mail, "CONTACT US"),
            _drawerItem(Icons.info_outline, "ABOUT US"),
            _drawerItem(Icons.share, "SHARE THIS APP"),
          ],
        ),
      ),
      body: _buildHomeBody(),
    );
  }

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PRO BANNER AREA
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF64B5F6)]),
              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: const Stack(
              children: [
                Positioned(
                  bottom: 20, left: 20,
                  child: Text("Today's Verse\nGod is Love", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Positioned(top: 20, right: 20, child: Icon(Icons.format_quote, color: Colors.white54, size: 50)),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("Main Menu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
          ),

          // GRID MENU (4 MAIN CARDS)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _menuCard("BIBLE", Icons.menu_book_rounded, const Color(0xFFFF9800), const BibleListScreen()),
                _menuCard("SONGS", Icons.music_video_rounded, const Color(0xFF2196F3), const CommonPlaceholder(title: "Songs")),
                _menuCard("BOOKS", Icons.library_books_rounded, const Color(0xFF4CAF50), const CommonPlaceholder(title: "Books")),
                _menuCard("LIVE", Icons.live_tv_rounded, const Color(0xFFF44336), const CommonPlaceholder(title: "Live Stream")),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuCard(String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF444444))),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1565C0)),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () => Navigator.pop(context),
    );
  }
}

// 3. BIBLE LIST SCREEN (With Better List Design)
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
      appBar: AppBar(
        title: const Text("Holy Bible", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        itemCount: _books.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, i) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const CircleAvatar(backgroundColor: Color(0xFFFF9800), child: Icon(Icons.book, color: Colors.white, size: 20)),
          title: Text(_books[i]["name"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            ChapterScreen(bookName: _books[i]["name"], chapters: _books[i]["chapters"]))),
        ),
      ),
    );
  }
}

// 4. CHAPTERS & VERSES
class ChapterScreen extends StatelessWidget {
  final String bookName;
  final List chapters;
  const ChapterScreen({super.key, required this.bookName, required this.chapters});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookName)),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 15, crossAxisSpacing: 15),
        itemCount: chapters.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            VerseScreen(chapterNum: chapters[i]["chapter"], verses: chapters[i]["verses"]))),
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade200)),
            child: Center(child: Text("${chapters[i]["chapter"]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
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
        padding: const EdgeInsets.all(16),
        itemCount: verses.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 18, height: 1.5),
              children: [
                TextSpan(text: "${verses[i]["number"]}. ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                TextSpan(text: verses[i]["text"]),
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
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text("$title Section Coming Soon", style: const TextStyle(fontSize: 18))));
  }
}
