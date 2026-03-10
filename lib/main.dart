import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WogApp());
}

class WogApp extends StatelessWidget {
  const WogApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WOG APK',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        // Web building error rakunda font loading style marchanu
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 100, color: Color(0xFF0D47A1)),
            const SizedBox(height: 20),
            Text("WOG APP", style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.bold, color: const Color(0xFF0D47A1))),
          ],
        ),
      ),
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WOG APP", style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
              accountName: Text("World of God", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: const Text("wogapp@official.com"),
              currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.church, color: Color(0xFF0D47A1), size: 40)),
            ),
            _drawerTile(Icons.track_changes, "TRACKER"),
            _drawerTile(Icons.audiotrack, "AUDIO MESSAGES"),
            _drawerTile(Icons.quiz, "QUIZ"),
            const Divider(),
            _drawerTile(Icons.contact_mail, "CONTACT US"),
            _drawerTile(Icons.info, "ABOUT US"),
            _drawerTile(Icons.share, "SHARE THIS APP"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)]),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Center(
                child: Text("దేవుని వాక్యం జీవమున్నది", 
                  style: GoogleFonts.mallanna(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _menuCard("BIBLE", Icons.menu_book, const Color(0xFFFF9800), const BibleListScreen()),
                  _menuCard("SONGS", Icons.music_note, const Color(0xFF2196F3), const PlaceholderScreen(title: "Songs")),
                  _menuCard("BOOKS", Icons.library_books, const Color(0xFF4CAF50), const PlaceholderScreen(title: "Books")),
                  _menuCard("LIVE", Icons.live_tv, const Color(0xFFF44336), const PlaceholderScreen(title: "Live Stream")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0D47A1)),
      title: Text(title, style: GoogleFonts.roboto(fontSize: 16)),
      onTap: () => Navigator.pop(context),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Holy Bible", style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _books.isEmpty ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, i) => ListTile(
          leading: const Icon(Icons.book, color: Color(0xFFFF9800)),
          title: Text(_books[i]["name"], style: GoogleFonts.mallanna(fontSize: 24)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            ChapterScreen(bookName: _books[i]["name"], chapters: _books[i]["chapters"]))),
        ),
      ),
    );
  }
}

class ChapterScreen extends StatelessWidget {
  final String bookName;
  final List chapters;
  const ChapterScreen({super.key, required this.bookName, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookName, style: GoogleFonts.mallanna(fontSize: 26, color: Colors.white)), backgroundColor: const Color(0xFF0D47A1), iconTheme: const IconThemeData(color: Colors.white)),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: chapters.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            VerseScreen(chapterNum: chapters[i]["chapter"], verses: chapters[i]["verses"]))),
          child: Container(
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blue.shade200)),
            child: Center(child: Text("${chapters[i]["chapter"]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
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
      appBar: AppBar(title: Text("Chapter $chapterNum", style: GoogleFonts.roboto())),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: verses.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 20, height: 1.6),
              children: [
                TextSpan(text: "${verses[i]["number"]}. ", style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: const Color(0xFF0D47A1), fontSize: 18)),
                TextSpan(text: verses[i]["text"], style: GoogleFonts.mallanna()),
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
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text("$title Section Coming Soon", style: GoogleFonts.roboto(fontSize: 18))));
  }
}
