import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/bacaan.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/pasal.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/screen/detailBacaan.dart';

class DetailKomunitas extends StatefulWidget {
  const DetailKomunitas({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailKomunitasState();
  }
}

class _DetailKomunitasState extends State<DetailKomunitas> {
  int bacaanTerpilih = -1;
  List<DateTime> listTanggalBacaan = [];

  DateFormat formatMonth = new DateFormat("MMMM yyyy", "id_ID");
  DateFormat formatDay = new DateFormat("dd MMMM yyyy", "id_ID");

  List<Bacaan> monthBacaan = [];

  DateTime focusedDay = DateTime.now();

  List<Bacaan> _getBacaanForMonth(int year, int month) {
    return globals.komunitasTerpilih.bacaan
        .where((bacaan) =>
            bacaan.tanggal.year == year && bacaan.tanggal.month == month)
        .toList();
  }

  List<Bacaan> _getBacaanForDay(int year, int month, int day) {
    List<Bacaan> bacaanHari = [];
    bacaanHari = globals.komunitasTerpilih.bacaan
        .where((bacaan) =>
            bacaan.tanggal.year == year &&
            bacaan.tanggal.month == month &&
            bacaan.tanggal.day == day)
        .toList();
    return bacaanHari;
  }

  List<DateTime> getTanggalBacaan(List<Bacaan> listBacaan) {
    List<DateTime> listTanggal = [];
    for (Bacaan bacaan in listBacaan) {
      if (!listTanggal.contains(bacaan.tanggal)) {
        listTanggal.add(bacaan.tanggal);
      }
    }
    listTanggal.sort((a, b) => b.compareTo(a));
    return listTanggal;
  }

  @override
  void initState() {
    super.initState();
    monthBacaan = _getBacaanForMonth(focusedDay.year, focusedDay.month);
    listTanggalBacaan = getTanggalBacaan(monthBacaan);
  }

  void _goToPreviousMonth() {
    setState(() {
      focusedDay = DateTime(
        focusedDay.year,
        focusedDay.month - 1,
        1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      focusedDay = DateTime(
        focusedDay.year,
        focusedDay.month + 1,
        1,
      );
    });
    debugPrint(focusedDay.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Komunitas",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    globals.komunitasTerpilih.nama,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Topik Bacaan",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            size: 24.0,
                          ),
                          onTap: () {
                            _goToPreviousMonth();
                            monthBacaan = _getBacaanForMonth(
                                focusedDay.year, focusedDay.month);
                            listTanggalBacaan = getTanggalBacaan(monthBacaan);
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            formatMonth.format(focusedDay),
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            size: 24.0,
                          ),
                          onTap: () {
                            _goToNextMonth();
                            monthBacaan = _getBacaanForMonth(
                                focusedDay.year, focusedDay.month);
                            listTanggalBacaan = getTanggalBacaan(monthBacaan);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: ScrollController(),
                  itemCount: listTanggalBacaan.length,
                  itemBuilder: (context, index) {
                    // setState(() {
                    //   dayBacaan = _getBacaanForDay(
                    //       listTanggalBacaan[index].year,
                    //       listTanggalBacaan[index].month,
                    //       listTanggalBacaan[index].day);
                    // });
                    return Column(
                      children: [
                        Text(formatDay.format(listTanggalBacaan[index])),
                        ListViewBacaan(
                            bacaanHariIni: _getBacaanForDay(
                                listTanggalBacaan[index].year,
                                listTanggalBacaan[index].month,
                                listTanggalBacaan[index].day)),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ListViewBacaan extends StatefulWidget {
  final List<Bacaan> bacaanHariIni;

  const ListViewBacaan({required this.bacaanHariIni});

  @override
  State<StatefulWidget> createState() {
    return _ListViewBacaanState();
  }
}

class _ListViewBacaanState extends State<ListViewBacaan> {
  int bacaanTerpilih = -1;
  late List<Bacaan> bacaanHariIni = widget.bacaanHariIni;

  List<Ayat> ayatBacaan = [];

  List<Ayat> parseReferences(String input) {
    List<Ayat> references = [];
    List<String> parts = input.split(';');

    for (String part in parts) {
      part = part.trim();
      RegExp regExp =
          RegExp(r'(\S+)\s(\d+):(\d+(-\d+)?(,\d+(-\d+)?)*)([a-z]*)');
      Iterable<Match> matches = regExp.allMatches(part);

      for (Match match in matches) {
        String nama = match.group(1)!.trim();
        int bab = int.parse(match.group(2)!);
        List<int> ayat = [];

        String ayatStr = match.group(3)!;
        List<String> ayatParts = ayatStr.split(',');

        for (String ayatPart in ayatParts) {
          if (ayatPart.contains('-')) {
            List<String> range = ayatPart.split('-');
            int start = int.parse(range[0]);
            int end = int.parse(range[1]);
            ayat.addAll(
                List.generate(end - start + 1, (index) => start + index));
          } else {
            ayat.add(int.parse(ayatPart));
          }
        }
        for (int nomorAyat in ayat) {
          references.add(Ayat(
            id: 0,
            nomor: nomorAyat.toString(),
            nomorPasal: bab.toString(),
            text: "",
            kitab: nama,
            title: "",
            titleIncluded: "",
          ));
        }
      }
    }

    return references;
  }

  List<Ayat> getBacaan(String ayat) {
    List<Ayat> bacaanHariIni = parseReferences(ayat);
    List<Ayat> isiBacaan = [];
    int indexKitab = 0;
    int indexPasal = 0;
    for (Ayat ayatBacaan in bacaanHariIni) {
      for (Kitab kitab in globals.kitab) {
        if (ayatBacaan.kitab == kitab.singkatan) {
          indexKitab = kitab.id;
          for (Pasal pasal in globals.kitab[indexKitab].pasal) {
            if (ayatBacaan.nomorPasal == pasal.nomor) {
              indexPasal = pasal.id;
              for (Ayat ayatAlkitab
                  in globals.kitab[indexKitab].pasal[indexPasal].ayat) {
                if (ayatBacaan.nomor == ayatAlkitab.nomor) {
                  isiBacaan.add(ayatAlkitab);
                }
              }
            }
          }
        }
      }
    }
    debugPrint(indexKitab.toString());
    return isiBacaan;
  }

  String convertUnicode(String input) {
    // Membuat daftar kode Unicode menggunakan metode codeUnits
    List<int> codeUnits = input.runes.toList();

    // Menggunakan StringBuffer untuk menggabungkan karakter yang dikonversi
    StringBuffer buffer = StringBuffer();

    // Melakukan iterasi pada setiap kode Unicode
    for (int codeUnit in codeUnits) {
      // Mengkonversi kode Unicode menjadi karakter dan menambahkannya ke buffer
      buffer.write(String.fromCharCode(codeUnit));
    }

    // Mengembalikan string hasil konversi
    return buffer.toString();
  }

  String convertSpecialString(String input) {
    // Membuat peta konversi untuk karakter khusus
    Map<String, String> conversionMap = {
      '<t \/>':
          '', // Ganti 'Teks setelah konversi' dengan string yang diinginkan
      // Tambahkan entri lain jika diperlukan
    };

    // Melakukan konversi berdasarkan peta
    conversionMap.forEach((key, value) {
      input = input.replaceAll(key, value);
    });

    return input;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: ScrollController(),
        itemCount: bacaanHariIni.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        ayatBacaan = getBacaan(bacaanHariIni[index].bacaan);
                        bacaanTerpilih == bacaanHariIni[index].id
                            ? bacaanTerpilih = -1
                            : bacaanTerpilih = bacaanHariIni[index].id;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                              ),
                              child: Container(
                                width: 10.0,
                                color: Color(int.parse(
                                    bacaanHariIni[index]
                                        .warna
                                        .split('(0x')[1]
                                        .split(')')[0],
                                    radix: 16)),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bacaanHariIni[index].judulBacaan,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      bacaanHariIni[index].tipeBacaan,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(bacaanHariIni[index].bacaan),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: bacaanTerpilih == bacaanHariIni[index].id
                                  ? Icon(
                                      Icons.arrow_drop_down,
                                      size: 24.0,
                                    )
                                  : Icon(
                                      Icons.arrow_drop_up,
                                      size: 24.0,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bacaanTerpilih == bacaanHariIni[index].id
                    ? Container(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              controller: ScrollController(),
                              itemCount: ayatBacaan.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      globals.ayatDipilih
                                              .contains(ayatBacaan[index])
                                          ? globals.ayatDipilih
                                              .remove(ayatBacaan[index])
                                          : globals.ayatDipilih
                                              .add(ayatBacaan[index]);
                                      globals.ayatDipilih
                                          .sort((a, b) => a.id.compareTo(b.id));
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      globals.ayatDipilih
                                          .remove(ayatBacaan[index]);
                                    });
                                  },
                                  child: Container(
                                    color: globals.ayatDipilih
                                            .contains(ayatBacaan[index])
                                        ? Colors.blue
                                        : null,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            ayatBacaan[index].nomor,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            convertSpecialString(convertUnicode(
                                                ayatBacaan[index].text)),
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    : Container()
              ],
            ),
          );
        });
  }
}
