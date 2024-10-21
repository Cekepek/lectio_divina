import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/screen/editLd.dart';
import 'package:share_plus/share_plus.dart';

class DetailLd extends StatefulWidget {
  const DetailLd({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailLdState();
  }
}

class _DetailLdState extends State<DetailLd> {
  DateFormat format = new DateFormat("EEEE dd MMMM yyyy", "id_ID");
  String tanggalLd = "";
  LD detailLd = LD(
      id: 0,
      tanggal: DateTime.now(),
      judul: "",
      ayat: "",
      sabda: "",
      sabdaBagiSaya: "",
      tanggapan: "",
      tindakan: "",
      catatan: "",
      hashtag: "",
      warna: "",
      shareable: false,
      selesai: false,
      user_id: 0);

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
    DateTime dateTimeLd = detailLd.tanggal;
    tanggalLd = format.format(dateTimeLd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Detail LD",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (result) {
                if (result == 0) {
                  globals.idLdEdit = globals.idLdDetail;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditLd()),
                  );
                }
                if (result == 1) {
                  Share.share("*" +
                      detailLd.judul +
                      "*\n\n" +
                      "*" +
                      tanggalLd +
                      "*\n\n" +
                      "*Ayat : " +
                      detailLd.ayat +
                      "*\n\n" +
                      detailLd.sabda +
                      "\n\n*Sabda Tuhan Bagi Saya :*\n" +
                      detailLd.sabdaBagiSaya +
                      "\n\n*Tanggapan :*\n" +
                      detailLd.tanggapan +
                      "\n\n*Tindakan :*\n" +
                      detailLd.tindakan +
                      "\n\n*Catatan :*\n" +
                      detailLd.catatan);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(value: 0, child: Text("Edit LD")),
                  PopupMenuItem(value: 1, child: Text("Bagikan"))
                ];
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              detailLd.judul,
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Tanggal : " + tanggalLd,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            "Sabda Tuhan",
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
                            "Sabda Tuhan Bagi Saya",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(detailLd.sabdaBagiSaya),
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
