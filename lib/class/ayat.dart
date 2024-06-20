class Ayat {
  int id;
  String nomor;
  String nomorPasal;
  String text;
  String kitab;
  String title = "";
  String titleIncluded = "";
  Ayat(
      {required this.id,
      required this.nomor,
      required this.nomorPasal,
      required this.text,
      required this.kitab,
      required this.title,
      required this.titleIncluded});
}
