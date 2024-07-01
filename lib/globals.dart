library my_prj.globals;

import 'package:flutter/material.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/bacaan.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/komunitas.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/screen/komunitas.dart';

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
      sabdaTuhanBagiSaya: "")
]);
Bacaan bacaanTerpilih = Bacaan(
    id: 1,
    judulBacaan: "",
    bacaan: "",
    tanggal: DateTime.now(),
    warna: Color.fromRGBO(255, 0, 0, 1).toString(),
    sabdaTuhanBagiSaya: "");
List<KomunitasClass> listKomunitas = [
  KomunitasClass(id: 1, nama: "Paroki Santa Maria Tak Bercela", bacaan: [
    Bacaan(
        id: 1,
        judulBacaan: "Test Bacaan 1",
        bacaan: "Kel 24:3-8",
        tanggal: DateTime.now(),
        warna: Color.fromRGBO(255, 0, 0, 1).toString(),
        sabdaTuhanBagiSaya:
            "Proin eu sollicitudin risus. Etiam tortor mi, euismod ut elementum sed, blandit eu neque. Duis vel libero ut dui egestas maximus. Nullam finibus orci id orci sodales, sit amet porta urna elementum. Donec finibus dignissim pellentesque. Etiam placerat iaculis justo, et rhoncus leo pretium ut. Praesent suscipit ligula mauris, vitae finibus erat lobortis in.")
  ]),
  KomunitasClass(id: 2, nama: "Paroki Santo Marinus Yohanes", bacaan: [
    Bacaan(
        id: 1,
        judulBacaan: "Test Bacaan 1",
        bacaan: "2Ptr 1:1-7",
        tanggal: DateTime.now(),
        warna: Color.fromRGBO(255, 255, 0, 1).toString(),
        sabdaTuhanBagiSaya:
            "Vivamus nibh elit, vestibulum quis semper sed, lacinia in ligula. Suspendisse potenti. Cras quis sem quis eros fringilla auctor. Phasellus vitae dolor tellus. Vestibulum vel metus gravida, bibendum lectus eu, facilisis quam. Proin quis massa est. Mauris mollis, justo sed dapibus hendrerit, mi mauris laoreet mi, ac placerat justo ex sed elit. Maecenas vel libero dolor. Quisque egestas leo ante, et mollis mauris maximus id. Nam tempor fermentum ex, a dignissim eros pulvinar nec. Phasellus ornare laoreet lorem a aliquam. Etiam ultricies elit nec fringilla fermentum. Nullam vel libero eget risus sodales luctus. Mauris sit amet nibh sit amet mi faucibus efficitur. Sed non urna vel quam aliquam luctus. Praesent ullamcorper, leo ac scelerisque ultrices, orci nibh interdum dui, nec varius est ligula ac neque.")
  ]),
  KomunitasClass(id: 3, nama: "Paroki Santo Yohanes Penginjil", bacaan: [
    Bacaan(
        id: 1,
        judulBacaan: "Test Bacaan 1",
        bacaan: "2Tim 2:8-15",
        tanggal: DateTime.now(),
        warna: Color.fromRGBO(0, 0, 255, 1).toString(),
        sabdaTuhanBagiSaya:
            "Fusce dignissim condimentum erat sagittis eleifend. Nulla facilisi. Etiam in rutrum risus. Sed laoreet id lacus non convallis. Morbi sollicitudin tellus vitae neque consectetur imperdiet. Duis tempor fringilla sagittis. Proin dapibus nibh vitae odio laoreet, vitae cursus augue placerat. Integer molestie massa et cursus euismod. Mauris congue rhoncus est, quis eleifend libero maximus ut. Quisque finibus dui non nisi dapibus, ut semper elit aliquet. Etiam tempus lectus sit amet vestibulum fermentum. Nullam sed tellus egestas, dignissim nulla in, tempor urna. Nunc orci arcu, ultrices vel posuere at, luctus vel quam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Morbi quis justo id nulla sollicitudin finibus non facilisis nisi.")
  ])
];
