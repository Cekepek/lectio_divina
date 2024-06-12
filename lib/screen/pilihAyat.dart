import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/screen/alkitab.dart';
import 'package:lectio_divina/main.dart';

class PilihAyat extends StatefulWidget {
  final int kitab;
  final int bab;
  PilihAyat({Key? key, required this.kitab, required this.bab})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PilihAyatState();
  }
}

class _PilihAyatState extends State<PilihAyat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {Navigator.pop(context)}),
          title: Text(
            'Pilih Ayat',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Text(
                                        globals.kitab[widget.kitab].singkatan),
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      size: 24.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(globals.kitab[widget.kitab]
                                        .pasal[widget.bab].nomor),
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      size: 24.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      GridView.builder(
                          itemCount: globals.kitab[widget.kitab]
                              .pasal[widget.bab].ayat.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5),
                          itemBuilder: (context, index) {
                            return TextButton(
                                onPressed: () {
                                  globals.namaKitab =
                                      globals.kitab[widget.kitab].id;
                                  globals.bab = globals
                                      .kitab[widget.kitab].pasal[widget.bab].id;
                                  globals.ayat = globals.kitab[widget.kitab]
                                      .pasal[widget.bab].ayat[index].nomor;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Alkitab()));
                                },
                                child: Text(globals.kitab[widget.kitab]
                                    .pasal[widget.bab].ayat[index].nomor));
                          })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
