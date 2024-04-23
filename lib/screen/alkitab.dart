import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lectio_divina/screen/cariAlkitab.dart';

class Alkitab extends StatefulWidget {
  const Alkitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlkitabState();
  }
}

class _AlkitabState extends State<Alkitab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Container(
                        child: Text(
                      "Allah menciptakan langit dan bumi serta isinya",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("1"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Pada mulanya Allah menciptakan langit dan bumi. "),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("2"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Bumi belum berbentuk dan kosong; gelap gulita menutupi samudera raya, dan Roh Allah melayang-layang di atas permukaan air."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("3"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Berfirmanlah Allah: ”Jadilah terang.” Lalu terang itu jadi."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("4"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Allah melihat bahwa terang itu baik, lalu dipisahkan-Nyalah terang itu dari gelap."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("5"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Dan Allah menamai terang itu siang, dan gelap itu malam. Jadilah petang dan jadilah pagi, itulah hari pertama."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("6"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Berfirmanlah Allah: 'Jadilah cakrawala di tengah segala air untuk memisahkan air dari air.'"),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("7"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Maka Allah menjadikan cakrawala dan Ia memisahkan air yang ada di bawah cakrawala itu dari air yang ada di atasnya. Dan jadilah demikian."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("8"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Lalu Allah menamai cakrawala itu langit. Jadilah petang dan jadilah pagi, itulah hari kedua."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("9"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Berfirmanlah Allah: ”Hendaklah segala air yang di bawah langit berkumpul pada satu tempat, sehingga kelihatan yang kering.” Dan jadilah demikian."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("10"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Lalu Allah menamai yang kering itu darat, dan kumpulan air itu dinamai-Nya laut. Allah melihat bahwa semuanya itu baik."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("11"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Berfirmanlah Allah: ”Hendaklah tanah menumbuhkan tunas-tunas muda, tumbuh-tumbuhan yang berbiji, segala jenis pohon buah-buahan yang menghasilkan buah yang berbiji, supaya ada tumbuh-tumbuhan di bumi.” Dan jadilah demikian."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("12"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Tanah itu menumbuhkan tunas-tunas muda, segala jenis tumbuh-tumbuhan yang berbiji dan segala jenis pohon pohonan yang menghasilkan buah yang berbiji. Allah melihat bahwa semuanya itu baik."),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("13"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                            "Jadilah petang dan jadilah pagi, itulah hari ketiga."),
                      ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 56,
            color: Theme.of(context).colorScheme.inversePrimary,
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text("<",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(right: 24, left: 24),
                    child: Text("Kejadian 1",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 24,
                    ),
                    child: Text(">",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        )),
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.search,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CariAlkitab(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
