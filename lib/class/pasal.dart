import 'package:lectio_divina/class/ayat.dart';

class Pasal {
  int id = 0;
  String nomor;
  int id_kitab;
  List<Ayat> ayat;
  Pasal(
      {required this.id,
      required this.nomor,
      required this.id_kitab,
      required this.ayat});
}
