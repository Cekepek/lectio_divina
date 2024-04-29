class Ayat {
  String id;
  String book;
  String abbr;
  String chapter;
  String verse;
  String text;
  String title;
  Ayat(
      {required this.id,
      required this.book,
      required this.abbr,
      required this.chapter,
      required this.verse,
      required this.text,
      required this.title});
  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
        id: json['id'],
        book: json['book'],
        abbr: json['abbr'],
        chapter: json['chapter'],
        verse: json['verse'],
        text: json['text'],
        title: json['title']);
  }
}
