import 'package:lectio_divina/class/bacaan.dart';

class KomunitasClass {
  int id = 0;
  String nama = "";
  List<Bacaan> bacaan = [];
  KomunitasClass(
      {required this.id, required this.nama, required this.bacaan});
}
