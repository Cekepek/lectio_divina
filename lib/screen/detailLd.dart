import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/globals.dart' as globals;

class DetailLd extends StatefulWidget {
  const DetailLd({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailLdState();
  }
}

class _DetailLdState extends State<DetailLd> {
  DateFormat format = new DateFormat("dd MMMM yyyy", "id_ID");
  String tanggalLd = "";
  LD detailLd = LD(
      id: 0,
      tanggal: "",
      judul: "",
      ayat: "",
      sabda: "",
      tanggapan: "",
      tindakan: "",
      catatan: "",
      hashtag: "",
      warna: "",
      selesai: false);

  void _getLdDetail() {
    for (LD ld in globals.MyLd) {
      if (ld.id == globals.idLdDetail) {
        detailLd = ld;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLdDetail();
    DateTime dateTimeLd = DateTime.parse(detailLd.tanggal);
    print(dateTimeLd);
    tanggalLd = format.format(dateTimeLd);

    debugPrint(tanggalLd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Detail LD",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    detailLd.judul,
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  Text(
                    "LD Tanggal : " + tanggalLd + ", By : Christopher Kelvin",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              )),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ayat",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(detailLd.ayat),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sabda Tuhan Bagi Saya",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(detailLd.sabda),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggapan Saya",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(detailLd.tanggapan)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tindakan Saya",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(detailLd.tindakan)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Catatan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(detailLd.catatan),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hashtag",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(detailLd.hashtag),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person,
                            size: 24.0,
                          ),
                          Text("Pribadi")
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
