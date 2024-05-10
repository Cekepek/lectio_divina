import 'package:lectio_divina/class/pasal.dart';

class Kitab {
  int id = 0;
  String singkatan;
  String nama = "";
  List<Pasal> pasal;
  Kitab(
      {required this.id,
      required this.singkatan,
      required this.nama,
      required this.pasal});
}
