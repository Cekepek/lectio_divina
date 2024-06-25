library my_prj.globals;

import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/komunitas.dart';
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

int komunitasTerpilih = 0;
List<KomunitasClass> listKomunitas = [
  KomunitasClass(
      id: 1,
      nama: "Paroki Santa Maria Tak Bercela",
      bacaanHariIni: "Kel 24:3-8"),
  KomunitasClass(
      id: 2, nama: "Paroki Santo Marinus Yohanes", bacaanHariIni: "2Ptr 1:1-7"),
  KomunitasClass(
      id: 3,
      nama: "Paroki Santo Yohanes Penginjil",
      bacaanHariIni: "2Tim 2:8-15")
];
