import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PilihBabKitab extends StatefulWidget {
  const PilihBabKitab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _PilihBabKitabState();
  }
}

class _PilihBabKitabState extends State<PilihBabKitab> {
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // for(int i=1; i<=50; i++) if(i%5==0)
            ],
          ),
        ),
      ),
    );
  }
}
