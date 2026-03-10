import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

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

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const BibleStudyPage(),
    const PlaceholderScreen(title: "Songs"),
    const PlaceholderScreen(title: "Books"),
    const PlaceholderScreen(title: "Live Stream"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        title: const Text("WOG APP", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.white,
            child: const Center(
              child: Text("Crafted by God's Grace", 
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: Color(0xFF1A237E))),
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

  Widget _buildDrawer() {
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

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160, width: double.infinity, margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3F51B5)])),
            child: const Center(child: Text("దేవుని వాక్యం జీవమున్నది", style: TextStyle(fontFamily: 'Mallanna', color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold))),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text("Daily Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A237E))),
          ),
          _notifCard(Icons.bolt_rounded, "Today's Verse", "The Lord is my Shepherd, I shall not want.", Colors.orange),
          _notifCard(Icons.notifications_active_rounded, "Latest Update", "Sunday Service starts at 10 AM.", Colors.redAccent),
        ],
      ),
    );
  }

  Widget _notifCard(IconData icon, String title, String msg, Color col) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Icon(icon, color: col), const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(msg, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ]))
      ]),
    );
  }
}

class BibleStudyPage extends StatefulWidget {
  const BibleStudyPage({super.key});
  @override
  _BibleStudyPageState createState() => _BibleStudyPageState();
}

class _BibleStudyPageState extends State<BibleStudyPage> {
  List<xml.XmlElement> books = [];
  xml.XmlElement? selectedBook;
  List<xml.XmlElement> chapters = [];
  xml.XmlElement? selectedChapter;
  List<xml.XmlElement> verses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBibleData();
  }

  Future<void> loadBibleData() async {
    try {
      String xmlString = await rootBundle.loadString('assets/bible.xml');
      final document = xml.XmlDocument.parse(xmlString);
      setState(() {
        books = document.findAllElements('BIBLEBOOK').toList();
        if (books.isNotEmpty) {
          selectedBook = books.first;
          _loadChapters();
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _loadChapters() {
    if (selectedBook != null) {
      setState(() {
        chapters = selectedBook!.findElements('CHAPTER').toList();
        selectedChapter = chapters.isNotEmpty ? chapters.first : null;
        _loadVerses();
      });
    }
  }

  void _loadVerses() {
    if (selectedChapter != null) {
      setState(() {
        verses = selectedChapter!.findElements('VERS').toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButton<xml.XmlElement>(
                  isExpanded: true,
                  value: selectedBook,
                  items: books.map((b) => DropdownMenuItem(value: b, child: Text(b.getAttribute('bname') ?? '', style: const TextStyle(fontFamily: 'Mallanna', fontSize: 18)))).toList(),
                  onChanged: (val) { setState(() { selectedBook = val; _loadChapters(); }); },
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<xml.XmlElement>(
                value: selectedChapter,
                items: chapters.map((c) => DropdownMenuItem(value: c, child: Text("Ch ${c.getAttribute('cnumber')}"))).toList(),
                onChanged: (val) { setState(() { selectedChapter = val; _loadVerses(); }); },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              var v = verses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "${v.getAttribute('vnumber')}. ", style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(text: v.innerText, style: const TextStyle(fontFamily: 'Mallanna', color: Colors.black87, fontSize: 22, height: 1.6)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Center(child: Text("$title Coming Soon", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
}
