class Ayat {
  int id;
  String nomor;
  String nomorPasal;
  String tipe;
  String text;
  String kitab;
  String title = "";
  String titleIncluded = "";
  Ayat(
      {required this.id,
      required this.nomor,
      required this.nomorPasal,
      required this.tipe,
      required this.text,
      required this.kitab,
      required this.title,
      required this.titleIncluded});
}
