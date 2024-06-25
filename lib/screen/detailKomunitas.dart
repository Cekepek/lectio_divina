import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/pasal.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/class/ayat.dart';

class DetailKomunitas extends StatefulWidget {
  const DetailKomunitas({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailKomunitasState();
  }
}

class _DetailKomunitasState extends State<DetailKomunitas> {
  List<Ayat> bacaanTerpilih = [];
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

        references.add(Ayat(
          id: 0,
          nomor: ayat.toString(),
          nomorPasal: bab.toString(),
          text: "",
          kitab: nama,
          title: "",
          titleIncluded: "",
        ));
      }
    }

    return references;
  }

  String getSabda(String ayat) {
    List<Ayat> bacaanHariIni = parseReferences(ayat);
    String sabda = "";
    int indexKitab = 0;
    int indexPasal = 0;
    for (Ayat ayatBacaan in bacaanHariIni) {
      debugPrint(ayatBacaan.nomorPasal);
      for (Kitab kitab in globals.kitab) {
        if (ayatBacaan.kitab == kitab.nama) {
          indexKitab = kitab.id;
          for (Pasal pasal in globals.kitab[indexKitab].pasal) {
            if (ayatBacaan.nomorPasal == pasal.nomor) {
              indexPasal = pasal.id;
            }
            for (Ayat ayatAlkitab
                in globals.kitab[indexKitab].pasal[indexPasal].ayat) {
              if (ayatBacaan.nomor == ayatAlkitab.nomor) {
                sabda += ayatAlkitab.text;
              }
            }
          }
        }
      }
    }
    return sabda;
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
                    globals.listKomunitas[globals.komunitasTerpilih].nama,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                "Bacaan Hari Ini :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                globals.listKomunitas[globals.komunitasTerpilih].bacaanHariIni,
                style: TextStyle(fontSize: 14),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(getSabda(globals
                    .listKomunitas[globals.komunitasTerpilih].bacaanHariIni)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
