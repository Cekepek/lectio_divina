class Bacaan {
  int id = 0;
  String judulBacaan = "";
  String tipeBacaan = "";
  String bacaan = "";
  DateTime tanggal = DateTime.now();
  String warna = "";
  Bacaan(
      {required this.id,
      required this.bacaan,
      required this.judulBacaan,
      required this.tipeBacaan,
      required this.tanggal,
      required this.warna});
}
