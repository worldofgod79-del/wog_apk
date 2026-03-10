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
        scaffoldBackgroundColor: Colors.grey[100],
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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text("WOG APP", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
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
        title: const Text("WOG APP", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      // SIDE MENU (IMAGE LO UNNATTE)
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[800]),
              accountName: const Text("World of God", style: TextStyle(fontSize: 20)),
              accountEmail: const Text("wogapp@official.com"),
              currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 50)),
            ),
            _drawerItem(Icons.track_changes, "TRACKER"),
            _drawerItem(Icons.audiotrack, "AUDIO MESSAGES"),
            _drawerItem(Icons.quiz, "QUIZ"),
            const Divider(),
            _drawerItem(Icons.contact_mail, "CONTACT US"),
            _drawerItem(Icons.info, "ABOUT US"),
            _drawerItem(Icons.share, "SHARE THIS APP"),
          ],
        ),
      ),
      body: _buildHomeBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'BIBLE'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'SONGS'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'LIVE'),
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // BANNER AREA
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue[700]!, Colors.blue[400]!]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: const Center(child: Text("WELCOME TO WOG", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
          ),
          
          // GRID MENU (4 BUTTONS)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _menuCard("BIBLE", Icons.menu_book, Colors.orange, const BibleListScreen()),
                _menuCard("SONGS", Icons.music_note, Colors.blue, const CommonPlaceholder(title: "Songs")),
                _menuCard("BOOKS", Icons.library_books, Colors.green, const CommonPlaceholder(title: "Books")),
                _menuCard("LIVE", Icons.live_tv, Colors.red, const CommonPlaceholder(title: "Live Stream")),
              ],
            ),
          ),
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
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 30, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 30)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () => Navigator.pop(context),
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
      appBar: AppBar(title: const Text("HOLY BIBLE")),
      body: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, i) => ListTile(
          leading: const Icon(Icons.book_online, color: Colors.orange),
          title: Text(_books[i]["name"]),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            ChapterScreen(bookName: _books[i]["name"], chapters: _books[i]["chapters"]))),
        ),
      ),
    );
  }
}

// 4. CHAPTERS & VERSES (Previous Logic kept same)
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
          leading: Text("${verses[i]["number"]}.", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          title: Text(verses[i]["text"]),
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
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text("$title Section Under Construction")));
  }
}
