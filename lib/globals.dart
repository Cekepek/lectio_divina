library my_prj.globals;

import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/ld.dart';

List<Kitab> kitab = [];
List<LD> MyLd = [];
List<Ayat> ayatDipilih = [];

int currentIndex = 0;
// Alkitab selectKitab = Alkitab(kitab: 0, bab: 0, ayat: "0");

int namaKitab = 0;
int bab = 0;
String ayat = "0";

DateTime waktuSaatIni = DateTime.now();
DateTime tanggalTerpilih =
    DateTime(waktuSaatIni.year, waktuSaatIni.month, waktuSaatIni.day);

int idLdDetail = 0;

int idLdEdit = 0;
