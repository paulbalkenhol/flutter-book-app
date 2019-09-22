import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'book.dart';

class AddBookForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddBookFormState();
  }
}

class AddBookFormState extends State<AddBookForm> {
  TextEditingController autorController = TextEditingController();
  TextEditingController titelController = TextEditingController();
  TextEditingController seitenController = TextEditingController();
  TextEditingController dauerController = TextEditingController();
  TextEditingController inhaltController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  int id;

  @override
  void dispose() {
    super.dispose();
    inhaltController.dispose();
    autorController.dispose();
    titelController.dispose();
    seitenController.dispose();
    dauerController.dispose();
  }

  @override
  void initState() {
    _getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buch hinzufügen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Titel",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  controller: titelController,
                  validator: (value) =>
                      value.isEmpty ? "Please enter some text" : null,
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Autor",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  controller: autorController,
                  validator: (value) =>
                      value.isEmpty ? "Please enter some text" : null,
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Anzahl der Seiten",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  controller: seitenController,
                  validator: (value) {
                    if (value.isEmpty || (int.tryParse(value) == null)) {
                      if (value.isEmpty) {
                        return "Please enter some text";
                      } else {
                        return "Please enter a valid input";
                      }
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Lesedauer (in Minuten)",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  controller: dauerController,
                  validator: (value) {
                    if (value.isEmpty || (int.tryParse(value) == null)) {
                      if (value.isEmpty) {
                        return "Please enter some text";
                      } else {
                        return "Please enter a valid input";
                      }
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: "Kurze Inhaltsangabe",
                  ),
                  controller: inhaltController,
                  validator: (value) =>
                      value.isEmpty ? "Please enter some text" : null,
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          Book newBook = Book(
                              author: autorController.text,
                              title: titelController.text,
                              pages: int.parse(seitenController.text),
                              readingTime: int.parse(dauerController.text),
                              description: inhaltController.text,
                              id: id);
                          DBHelper.db.insertBook(newBook);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "HINZUFÜGEN",
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("ABBRECHEN"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getId() async {
    int idData = await DBHelper.db.entriesCount();
    id = idData + 1;
  }
}
