class Book {
  int id;
  String author;
  String title;
  int readingTime;
  int pages;
  String description;

  Book(
      {this.author,
      this.title,
      this.readingTime,
      this.pages,
      this.id,
      this.description});

  Book.fromMap(Map<String, dynamic> map) {
    author = map["author"];
    title = map["title"];
    readingTime = map["readingtime"];
    pages = map["pages"];
    id = map["id"];
    description = map["despription"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "author": author,
      "title": title,
      "readingtime": readingTime,
      "pages": pages,
      "id": id,
      "despription": description,
    };
    return map;
  }
}
