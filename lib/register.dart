import 'package:flutter/material.dart';
import 'package:lectio_divina/login.dart';

class MyRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LECTIO DIVINA',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

var isObscured;

class _RegisterState extends State<Register> {
  late String email;
  late String password;
  late String name;
  late String error_register;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = "";
    password = "";
    name = "";
    error_register = "";
    isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        // title: const Text("Dashboard"),
        // actions: const [],
        // ),
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 50, bottom: 10, left: 10, right: 10),
              child: Container(
                color: Colors.grey,
                width: 128.0,
                height: 128.0,
              ),
            ), //CONTAINER UNTUK LOGO
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Lectio Divina",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
              child: Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama',
                    hintText: 'Masukkan nama anda'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Masukkan email anda'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: isObscured,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        icon: isObscured
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: (() {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        })),
                    border: OutlineInputBorder(),
                    labelText: 'Kata Sandi',
                    hintText: 'Masukkan kata sandi anda'),
              ),
            ),
            if (error_register != "") Text(error_register),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      print("p");
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 50, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sudah memiliki akun ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyLogin(),
                        ),
                      );
                    },
                    child: Text(
                      "Login sekarang",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
