import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CariAlkitab extends StatefulWidget {
  const CariAlkitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CariAlkitabState();
  }
}

class _CariAlkitabState extends State<CariAlkitab> {
  bool? terjemahanBaru = false;
  bool? contohTerjemahan = false;
  bool? perjanjianLama = false;
  bool? deuterokanonika = false;
  bool? perjanjianBaru = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {Navigator.pop(context)}),
        title: Text(
          'Cari',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: const Icon(
                    CupertinoIcons.search,
                    size: 24.0,
                  ),
                ),
                Expanded(
                  child: TextField(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins",
                        ),
                      ),
                      onPressed: () {
                        print("ini button Cari");
                      },
                      child: Text("Cari")),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Terjemahan Alkitab",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  child: Row(
                    children: [
                      Checkbox(
                        value: terjemahanBaru,
                        onChanged: (bool? value) {
                          setState(() {
                            terjemahanBaru = value;
                          });
                        },
                      ),
                      Text("Terjemahan Baru"),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  child: Row(
                    children: [
                      Checkbox(
                        value: contohTerjemahan,
                        onChanged: (bool? value) {
                          setState(() {
                            contohTerjemahan = value;
                          });
                        },
                      ),
                      Text("Contoh Terjemahan Alkitab"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Jenis Kitab",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  child: Row(
                    children: [
                      Checkbox(
                        value: perjanjianLama,
                        onChanged: (bool? value) {
                          setState(() {
                            perjanjianLama = value;
                          });
                        },
                      ),
                      Text("Perjanjian Lama"),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  child: Row(
                    children: [
                      Checkbox(
                        value: deuterokanonika,
                        onChanged: (bool? value) {
                          setState(() {
                            deuterokanonika = value;
                          });
                        },
                      ),
                      Text("Deuterokanonika"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: perjanjianBaru,
                      onChanged: (bool? value) {
                        setState(() {
                          perjanjianBaru = value;
                        });
                      },
                    ),
                    Text("Perjanjian Baru"),
                  ],
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
