library my_prj.globals;

import 'package:flutter/material.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/bacaan.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/komunitas.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/class/user.dart';

bool sinkronasiSelesai = false;
List<Kitab> kitab = [];
List<LD> MyLd = [];
List<Ayat> ayatDipilih = [];
int bacaanDipilih = -1;
String tesUsername = "tes";
String tesPassword = "tes";
User userLogin = User(id: 0, username: "", password: "", name: "", foto: "");
Color colorTheme = Color.fromRGBO(255, 141, 116, 1);
bool backgroundMusic = true;
bool autoJudul = true;
//kalau true -> bold, kalau false-> normal
bool header = true;
bool ayatBacaan = false;
bool isiAyat = false;
bool isiSabda = false;
bool isiTanggapan = false;
bool isiTindakan = false;

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

KomunitasClass komunitasTerpilih = KomunitasClass(id: 0, nama: "", bacaan: [
  Bacaan(
    id: 0,
    judulBacaan: "",
    tipeBacaan: "",
    bacaan: "",
    tanggal: DateTime.now(),
    warna: "#ffff0000",
  )
]);
Bacaan bacaanTerpilih = Bacaan(
    id: 1,
    judulBacaan: "",
    tipeBacaan: "",
    bacaan: "",
    tanggal: DateTime.now(),
    warna: "#ffff0000");
List<KomunitasClass> listKomunitas = [
  KomunitasClass(id: 1, nama: "Paroki Santa Maria Tak Bercela", bacaan: [
    Bacaan(
        id: 1,
        judulBacaan: "Test Bacaan 1",
        tipeBacaan: "Bacaan Harian",
        bacaan: "Kel 24:3-8",
        tanggal: DateTime.utc(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        warna: "#ffff0000"),
    Bacaan(
        id: 2,
        judulBacaan: "Bacaan Liturgi",
        tipeBacaan: "Bacaan I",
        bacaan: "Hos 2:13-15,18-19",
        tanggal: DateTime.utc(2024, 7, 7),
        warna: "#ffff0000"),
    Bacaan(
        id: 3,
        judulBacaan: "Test Bacaan 1",
        tipeBacaan: "Bacaan Harian",
        bacaan: "Kel 24:3-8",
        tanggal: DateTime.utc(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        warna: "#ffff0000"),
  ]),
  KomunitasClass(id: 2, nama: "Paroki Santo Marinus Yohanes", bacaan: [
    Bacaan(
      id: 1,
      judulBacaan: "Test Bacaan 1",
      tipeBacaan: "Bacaan Harian",
      bacaan: "2Ptr 1:1-7",
      tanggal: DateTime.utc(2024, 8, 7),
      warna: "#FFFF00",
    ),
    Bacaan(
      id: 2,
      judulBacaan: "Test Bacaan 2",
      tipeBacaan: "Bacaan Harian",
      bacaan: "2Ptr 1:1-7",
      tanggal: DateTime.utc(2024, 8, 7),
      warna:"#FFFF00",
    )
  ]),
  KomunitasClass(id: 3, nama: "Paroki Santo Yohanes Penginjil", bacaan: [
    Bacaan(
      id: 1,
      judulBacaan: "Test Bacaan 1",
      tipeBacaan: "Bacaan Harian",
      bacaan: "2Tim 2:8-15",
      tanggal: DateTime.now(),
      warna: "#0000FF",
    )
  ])
];
