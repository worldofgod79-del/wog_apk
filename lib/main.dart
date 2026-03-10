import 'package:flutter/material.dart';
import 'dart:async';
import 'bible_page.dart'; // Separate file connection

void main() => runApp(const WogApp());

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
      home: const SplashScreen(), // Splash Screen malli add chesanu
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

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const BibleStudyPage(), // Ikkada mee bible_page.dart load avthundi
    const Center(child: Text("Songs Section")),
    const Center(child: Text("Books Section")),
    const Center(child: Text("Live Section")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WOG APP", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 160, width: double.infinity, margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3F51B5)])),
            child: const Center(child: Text("దేవుని వాక్యం జీవమున్నది", style: TextStyle(fontFamily: 'Mallanna', color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold))),
          ),
          // Add your Notifications here
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

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
      print("Error: $e");
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
      setState(() => verses = selectedChapter!.findElements('VERS').toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          // Selectors
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<xml.XmlElement>(
                      isExpanded: true,
                      value: selectedBook,
                      items: books.map((b) => DropdownMenuItem(value: b, child: Text(b.getAttribute('bname') ?? '', style: const TextStyle(fontFamily: 'Mallanna', fontSize: 18)))).toList(),
                      onChanged: (val) { setState(() { selectedBook = val; _loadChapters(); }); },
                    ),
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
          // Verse List
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
      ),
      // Search Button (Meeru pampina Search Delegate logic ikkada connect cheyochu)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A237E),
        onPressed: () {}, // Meeru pampina Search functionality ni ikkada pettandi
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}
