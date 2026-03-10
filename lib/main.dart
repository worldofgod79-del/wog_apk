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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text("WOG APP", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 2. REAL HOME PAGE (As per your structure)
class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WOG HOME"), centerTitle: true),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOP BANNER
            Container(
              margin: const EdgeInsets.all(15),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Text("BANNER / IMAGE SLIDER")),
            ),
            
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("CHOOSE A SECTION", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // GRID MENU (4 Main Buttons)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.all(15),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _homeButton(context, "BIBLE", Icons.menu_book, Colors.orange, const BibleListScreen()),
                _homeButton(context, "SONGS", Icons.music_note, Colors.blue, const PlaceholderScreen(title: "Songs")),
                _homeButton(context, "BOOKS", Icons.library_books, Colors.green, const PlaceholderScreen(title: "Books")),
                _homeButton(context, "LIVE", Icons.live_tv, Colors.red, const PlaceholderScreen(title: "Live Stream")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton(BuildContext context, String label, IconData icon, Color color, Widget nextScreen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen)),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(decoration: BoxDecoration(color: Colors.blue), child: Text("WOG MENU", style: TextStyle(color: Colors.white, fontSize: 24))),
          ListTile(leading: const Icon(Icons.track_changes), title: const Text("TRACKER"), onTap: () {}),
          ListTile(leading: const Icon(Icons.audiotrack), title: const Text("AUDIO MESSAGES"), onTap: () {}),
          ListTile(leading: const Icon(Icons.quiz), title: const Text("QUIZ"), onTap: () {}),
          const Divider(),
          ListTile(leading: const Icon(Icons.info), title: const Text("ABOUT US"), onTap: () {}),
        ],
      ),
    );
  }
}

// 3. BIBLE LIST SCREEN
class BibleListScreen extends StatefulWidget {
  const BibleListScreen({super.key});
  @override
  State<BibleListScreen> createState() => _BibleListScreenState();
}

class _BibleListScreenState extends State<BibleListScreen> {
  List _bibleBooks = [];

  @override
  void initState() {
    super.initState();
    loadBible();
  }

  Future<void> loadBible() async {
    final String response = await rootBundle.loadString('assets/bible.json');
    final data = await json.decode(response);
    setState(() { _bibleBooks = data["books"]; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HOLY BIBLE")),
      body: _bibleBooks.isEmpty 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _bibleBooks.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(_bibleBooks[i]["name"]),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
                ChapterScreen(bookName: _bibleBooks[i]["name"], chapters: _bibleBooks[i]["chapters"]))),
            ),
          ),
    );
  }
}

// (ChapterScreen and VerseScreen logic ikkade untundi - code length limit valla kindha extend chesthunna...)

class ChapterScreen extends StatelessWidget {
  final String bookName;
  final List chapters;
  const ChapterScreen({super.key, required this.bookName, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookName)),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: chapters.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            VerseScreen(chapterNum: chapters[i]["chapter"], verses: chapters[i]["verses"]))),
          child: Card(color: Colors.blue[50], child: Center(child: Text("${chapters[i]["chapter"]}"))),
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
        itemCount: verses.length,
        itemBuilder: (context, i) => ListTile(
          leading: Text("${verses[i]["number"]}.", style: const TextStyle(fontWeight: FontWeight.bold)),
          title: Text(verses[i]["text"]),
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
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text("$title Screen Coming Soon")));
  }
}
