import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PilihKitab extends StatefulWidget {
  const PilihKitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PilihKitabState();
  }
}

class _PilihKitabState extends State<PilihKitab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {Navigator.pop(context)}),
        title: Text(
          'Pilih Kitab',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        debugPrint("Kejadian");
                      },
                      child: Text(
                        "Kej",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 58, 157)),
                      )),
                  TextButton(
                      onPressed: () {
                        debugPrint("Keluaran");
                      },
                      child: Text("Kel",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                  TextButton(
                      onPressed: () {
                        debugPrint("Imamat");
                      },
                      child: Text("Ima",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                  TextButton(
                      onPressed: () {
                        debugPrint("Bilangan");
                      },
                      child: Text("Bil",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                  TextButton(
                      onPressed: () {
                        debugPrint("Ulangan");
                      },
                      child: Text("Ula",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                  TextButton(
                      onPressed: () {
                        debugPrint("Yosua");
                      },
                      child: Text("Yos",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                ],
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        debugPrint("Kejadian");
                      },
                      child: Text(
                        "Hak",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 58, 157)),
                      )),
                  TextButton(
                      onPressed: () {
                        debugPrint("Keluaran");
                      },
                      child: Text("Rut",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                  TextButton(
                      onPressed: () {
                        debugPrint("Imamat");
                      },
                      child: Text("1Sam",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                  TextButton(
                      onPressed: () {
                        debugPrint("Bilangan");
                      },
                      child: Text("2Sam",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                  TextButton(
                      onPressed: () {
                        debugPrint("Ulangan");
                      },
                      child: Text("1Raj",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                  TextButton(
                      onPressed: () {
                        debugPrint("Yosua");
                      },
                      child: Text("2Raj",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
