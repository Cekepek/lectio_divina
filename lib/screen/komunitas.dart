import 'package:flutter/material.dart';
import 'package:lectio_divina/class/komunitas.dart';

class Komunitas extends StatefulWidget {
  const Komunitas({super.key});

  @override
  State<StatefulWidget> createState() {
    return _KomunitasState();
  }
}

class _KomunitasState extends State<Komunitas> {
  List<KomunitasClass> listKomunitas = [
    KomunitasClass(
        id: 1,
        nama: "Paroki Santa Maria Tak Bercela",
        bacaanHariIni: "Kel 24:3-8")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: ScrollController(),
                  itemCount: listKomunitas.length,
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(listKomunitas[index].nama)),
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
