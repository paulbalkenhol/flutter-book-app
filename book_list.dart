import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'db_helper.dart';
import 'book.dart';
import 'add_book_form.dart';

class BookItem {
  final String autor;
  final String titel;
  final int seiten;
  final int leseDauer;
  final String infoText;
  bool isExpanded;

  BookItem(
      {this.autor,
      this.titel,
      this.seiten,
      this.leseDauer,
      this.isExpanded,
      this.infoText});
}

class BookList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookListState();
  }
}

class _BookListState extends State<BookList>
    with SingleTickerProviderStateMixin {
  List<BookItem> _bookListe;

  _getBookItemList() async {
    List<Book> b = await DBHelper.db.getBooks();
    List<BookItem> bI = b.map((Book book) {
      BookItem item = BookItem(
        isExpanded: false,
        titel: book.title,
        seiten: book.pages,
        autor: book.author,
        leseDauer: book.readingTime,
        infoText: book.description,
      );
      return item;
    }).toList();

    setState(() {
      _bookListe = bI;
    });
  }

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getBookItemList();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bookListe == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Mein Bücherregal", style: TextStyle(color: Colors.white),),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: ExpansionPanelList(
              expansionCallback: (int index, bool expanded) {
                setState(() {
                  _bookListe[index].isExpanded = !expanded;
                });
              },
              children: _bookListe.map<ExpansionPanel>((BookItem item) {
                return ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    if (!isExpanded) {
                      return ListTile(
                        leading: Image.asset('assets/harari_cover.jpeg'),
                        title: Text(
                          item.titel,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        subtitle: Text(
                          item.autor,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    } else {
                      return ListTile(
                        title: Text(
                          item.titel,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        subtitle: Text(
                          item.autor,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    }
                  },
                  body: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'assets/harari_cover.jpeg',
                                height: 260.0,
                                width: 110.0,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            Flexible(
                              child: Container(
                                height: 260.0,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 0.0, 8.0, 0.0),
                                        child: Text(
                                          "Zusammengefasster Inhalt:",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          item.infoText,
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Text("INFORMATIONEN"),
                          alignment: Alignment.centerLeft,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 8.0),
                                  child: Text(
                                    "Dauer: ${item.leseDauer == null ? 0 : item.leseDauer ~/ 60}h ${item.leseDauer == null ? 0 : item.leseDauer % 60}min",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Text(
                                  "Seiten: ${item.seiten}",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            PopupMenuButton<String>(
                              onSelected: moreActions,
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  child: Text("Entfernen"),
                                  value: "Entfernen",
                                ),
                                PopupMenuItem<String>(
                                  child: Text("Aktualisieren"),
                                  value: "Aktualisieren",
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddBookForm()))
                .then((value) {
              setState(() {
                _getBookItemList();
              });
            });
          },
          child: Icon(Icons.add),
        ),
      );
    }
  }

  void moreActions(String auswahl) async {
    if (auswahl == "Entfernen") {
      int id;
      for (int i = 0; i < _bookListe.length; i++) {
        if (_bookListe[i].isExpanded) {
          id = i + 1;
          break;
        }
      }
      await DBHelper.db.delete(id);
      setState(() {
        _getBookItemList();
      });
    } else {
      print("Update");
    }
  }
}
