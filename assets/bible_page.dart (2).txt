import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;
import '../audio/audio_page.dart';
import '../tracker/tracker_page.dart';
import '../books/books_page.dart';

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
  xml.XmlElement? selectedVerse;

  bool isLoading = true;
  String? highlightedVerseNumber;
  final Map<String, GlobalKey> verseKeys = {};

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
      chapters = selectedBook!.findElements('CHAPTER').toList();
      if (chapters.isNotEmpty) {
        selectedChapter = chapters.first;
        _loadVerses();
      } else {
        chapters = [];
        selectedChapter = null;
        verses = [];
      }
    }
  }

  void _loadVerses() {
    if (selectedChapter != null) {
      verses = selectedChapter!.findElements('VERS').toList();
      selectedVerse = verses.isNotEmpty ? verses.first : null;
      
      verseKeys.clear();
      for (var v in verses) {
        verseKeys[v.getAttribute('vnumber') ?? ''] = GlobalKey();
      }
    } else {
      verses = [];
      selectedVerse = null;
    }
  }

  void _scrollToVerse(String vNumber) {
    setState(() {
      highlightedVerseNumber = vNumber;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (verseKeys[vNumber]?.currentContext != null) {
        Scrollable.ensureVisible(
          verseKeys[vNumber]!.currentContext!,
          duration: const Duration(milliseconds: 600),
          alignment: 0.3, 
        );
      }
    });
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => const SearchDialog(),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          selectedBook = result['book'];
          _loadChapters();
          selectedChapter = chapters.firstWhere((c) => c.getAttribute('cnumber') == result['chapter'].getAttribute('cnumber'));
          _loadVerses();
          selectedVerse = verses.firstWhere((v) => v.getAttribute('vnumber') == result['verse'].getAttribute('vnumber'));
        });
        _scrollToVerse(result['verse'].getAttribute('vnumber')!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('WORLD OF GOD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: isLoading ? null : _openSearchDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.grey[50],
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButton<xml.XmlElement>(
                          isExpanded: true,
                          value: selectedBook,
                          items: books.map((book) {
                            return DropdownMenuItem(
                              value: book,
                              child: Text(book.getAttribute('bname') ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newBook) => setState(() { selectedBook = newBook; _loadChapters(); highlightedVerseNumber = null; }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: DropdownButton<xml.XmlElement>(
                          isExpanded: true,
                          value: selectedChapter,
                          items: chapters.map((chapter) {
                            return DropdownMenuItem(
                              value: chapter,
                              child: Text('అధ్యా. ${chapter.getAttribute('cnumber') ?? ''}', style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newChapter) => setState(() { selectedChapter = newChapter; _loadVerses(); highlightedVerseNumber = null; }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: DropdownButton<xml.XmlElement>(
                          isExpanded: true,
                          value: selectedVerse,
                          items: verses.map((verse) {
                            return DropdownMenuItem(
                              value: verse,
                              child: Text('వాక్యం ${verse.getAttribute('vnumber') ?? ''}', style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newVerse) {
                            setState(() { selectedVerse = newVerse; });
                            if (newVerse != null) {
                              _scrollToVerse(newVerse.getAttribute('vnumber')!);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: verses.map((verse) {
                        String vNum = verse.getAttribute('vnumber') ?? '';
                        bool isHighlighted = highlightedVerseNumber == vNum;
                        return Container(
                          key: verseKeys[vNum],
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: isHighlighted ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: isHighlighted ? Colors.yellow.withOpacity(0.4) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isHighlighted ? Border.all(color: Colors.amber, width: 1) : null,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: '$vNum  ', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                                TextSpan(text: verse.innerText.trim(), style: const TextStyle(color: Colors.black87, fontSize: 18, height: 1.5)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) { 
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BooksPage()));
          } else if (index == 2) { 
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AudioPage()));
          } else if (index == 3) { 
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrackerPage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.my_library_books), label: 'Bible'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.headphones), label: 'Audio'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Tracker'),
        ],
      ),
    );
  }
}

// ------ సెర్చ్ ఫీచర్ కోసం ప్రత్యేకమైన డైలాగ్ క్లాస్ ------
class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchScope = 'Full Bible';
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  void _performSearch(BuildContext context) async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _hasSearched = true;
      _searchResults.clear();
    });

    // బ్యాక్ గ్రౌండ్ లో సెర్చ్ జరగడానికి చిన్న గ్యాప్
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      String xmlString = await rootBundle.loadString('assets/bible.xml');
      final document = xml.XmlDocument.parse(xmlString);
      List<xml.XmlElement> allBooks = document.findAllElements('BIBLEBOOK').toList();
      
      // ప్రస్తుతం సెలెక్ట్ అయిన పుస్తకం పేరు తెలుసుకోవడానికి యాక్సెస్ (కొంచెం ట్రిక్కీ కానీ వర్క్ అవుతుంది)
      final parentState = context.findAncestorStateOfType<_BibleStudyPageState>();
      String currentBookName = parentState?.selectedBook?.getAttribute('bname') ?? '';

      List<Map<String, dynamic>> results = [];

      for (int i = 0; i < allBooks.length; i++) {
        xml.XmlElement book = allBooks[i];
        
        // Scope ఫిల్టర్స్: 0-38 పాత నిబంధన, 39-65 క్రొత్త నిబంధన
        if (_searchScope == 'Old Testament' && i > 38) continue;
        if (_searchScope == 'New Testament' && i <= 38) continue;
        if (_searchScope == 'Current Book' && book.getAttribute('bname') != currentBookName) continue;

        var chapters = book.findElements('CHAPTER');
        for (var chapter in chapters) {
          var verses = chapter.findElements('VERS');
          for (var verse in verses) {
            if (verse.innerText.contains(query)) {
              results.add({
                'book': book,
                'chapter': chapter,
                'verse': verse,
                'text': verse.innerText.trim(),
              });
            }
          }
        }
      }

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() { _isSearching = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('వాక్యం వెతకండి', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'పదం లేదా వాక్యం టైప్ చేయండి...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blue),
                  onPressed: () => _performSearch(context),
                ),
              ),
              onSubmitted: (_) => _performSearch(context),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _searchScope,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: ['Full Bible', 'Old Testament', 'New Testament', 'Current Book'].map((String scope) {
                return DropdownMenuItem<String>(
                  value: scope,
                  child: Text(scope == 'Full Bible' ? 'మొత్తం బైబిల్' : scope == 'Old Testament' ? 'పాత నిబంధన' : scope == 'New Testament' ? 'క్రొత్త నిబంధన' : 'ప్రస్తుత పుస్తకంలో'),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) setState(() { _searchScope = newValue; });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _hasSearched && _searchResults.isEmpty
                      ? const Center(child: Text('వాక్యం దొరకలేదు', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            var res = _searchResults[index];
                            String bName = res['book'].getAttribute('bname') ?? '';
                            String cNum = res['chapter'].getAttribute('cnumber') ?? '';
                            String vNum = res['verse'].getAttribute('vnumber') ?? '';
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text('$bName $cNum:$vNum', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: Text(res['text'], maxLines: 2, overflow: TextOverflow.ellipsis),
                                onTap: () => Navigator.pop(context, res), // రిజల్ట్ ని మెయిన్ పేజీకి పంపుతుంది
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
