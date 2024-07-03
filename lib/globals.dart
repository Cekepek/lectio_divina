library my_prj.globals;

import 'package:flutter/material.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/bacaan.dart';
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

KomunitasClass komunitasTerpilih = KomunitasClass(id: 0, nama: "", bacaan: [
  Bacaan(
    id: 0,
    judulBacaan: "",
    bacaan: "",
    tanggal: DateTime.now(),
    warna: Color.fromRGBO(255, 0, 0, 1).toString(),
  )
]);
Bacaan bacaanTerpilih = Bacaan(
    id: 1,
    judulBacaan: "",
    bacaan: "",
    tanggal: DateTime.now(),
    warna: Color.fromRGBO(255, 0, 0, 1).toString());
List<KomunitasClass> listKomunitas = [
  KomunitasClass(id: 1, nama: "Paroki Santa Maria Tak Bercela", bacaan: [
    Bacaan(
        id: 1,
        judulBacaan: "Test Bacaan 1",
        bacaan: "Kel 24:3-8",
        tanggal: DateTime.now(),
        warna: Color.fromRGBO(255, 0, 0, 1).toString())
  ]),
  KomunitasClass(id: 2, nama: "Paroki Santo Marinus Yohanes", bacaan: [
    Bacaan(
      id: 1,
      judulBacaan: "Test Bacaan 1",
      bacaan: "2Ptr 1:1-7",
      tanggal: DateTime.now(),
      warna: Color.fromRGBO(255, 255, 0, 1).toString(),
    )
  ]),
  KomunitasClass(id: 3, nama: "Paroki Santo Yohanes Penginjil", bacaan: [
    Bacaan(
      id: 1,
      judulBacaan: "Test Bacaan 1",
      bacaan: "2Tim 2:8-15",
      tanggal: DateTime.now(),
      warna: Color.fromRGBO(0, 0, 255, 1).toString(),
    )
  ])
];
