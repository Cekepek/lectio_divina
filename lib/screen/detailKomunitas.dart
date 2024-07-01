import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/bacaan.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/pasal.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/screen/detailBacaan.dart';
import 'package:lectio_divina/screen/komunitas.dart';
import 'package:lectio_divina/screen/tambahLd.dart';

class DetailKomunitas extends StatefulWidget {
  const DetailKomunitas({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailKomunitasState();
  }
}

class _DetailKomunitasState extends State<DetailKomunitas> {
  List<Ayat> bacaanTerpilih = [];

  DateFormat formatMonth = new DateFormat("MMMM yyyy", "id_ID");
  List<Bacaan> monthBacaan = [];

  DateTime focusedDay = DateTime.now();
  List<Ayat> parseReferences(String input) {
    List<Ayat> references = [];
    List<String> parts = input.split(';');

    for (String part in parts) {
      part = part.trim();
      RegExp regExp =
          RegExp(r'(\D+)\s(\d+):(\d+(-\d+)?(,\d+(-\d+)?)*)([a-z]*)');
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

  void getBacaan(String ayat) {
    List<Ayat> bacaanHariIni = parseReferences(ayat);
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
                  globals.ayatDipilih.add(ayatAlkitab);
                }
              }
            }
          }
        }
      }
    }
  }

  List<Bacaan> _getLDForMonth(int year, int month) {
    return globals.komunitasTerpilih.bacaan
        .where((bacaan) =>
            bacaan.tanggal.year == year && bacaan.tanggal.month == month)
        .toList();
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
  }
  // String getSabda(String ayat) {
  //   List<Ayat> bacaanHariIni = parseReferences(ayat);
  //   String sabda = "";
  //   int indexKitab = 0;
  //   int indexPasal = 0;
  //   for (Ayat ayatBacaan in bacaanHariIni) {
  //     for (Kitab kitab in globals.kitab) {
  //       if (ayatBacaan.kitab == kitab.singkatan) {
  //         indexKitab = kitab.id;
  //         for (Pasal pasal in globals.kitab[indexKitab].pasal) {
  //           if (ayatBacaan.nomorPasal == pasal.nomor) {
  //             indexPasal = pasal.id;
  //             for (Ayat ayatAlkitab
  //                 in globals.kitab[indexKitab].pasal[indexPasal].ayat) {
  //               if (ayatBacaan.nomor == ayatAlkitab.nomor) {
  //                 sabda += ayatAlkitab.nomor + " " + ayatAlkitab.text + " ";
  //                 globals.ayatDipilih.add(ayatAlkitab);
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //   // debugPrint(sabda);
  //   return sabda;
  // }

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
                            monthBacaan = _getLDForMonth(
                                focusedDay.year, focusedDay.month);
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
                            monthBacaan = _getLDForMonth(
                                focusedDay.year, focusedDay.month);
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
                  itemCount: globals.komunitasTerpilih.bacaan.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
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
                                        globals.komunitasTerpilih.bacaan[index]
                                            .warna
                                            .split('(0x')[1]
                                            .split(')')[0],
                                        radix: 16)),
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        globals.komunitasTerpilih.bacaan[index]
                                            .judulBacaan,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(globals.komunitasTerpilih
                                          .bacaan[index].bacaan),
                                    ],
                                  ),
                                )),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz),
                                      onSelected: (result) {
                                        if (result == 0) {
                                          setState(() {
                                            globals.bacaanTerpilih = globals
                                                .komunitasTerpilih
                                                .bacaan[index];
                                            getBacaan(globals.komunitasTerpilih
                                                .bacaan[index].bacaan);
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailBacaan()),
                                          );
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            value: 0,
                                            child: Text("Detail"),
                                          ),
                                        ];
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
