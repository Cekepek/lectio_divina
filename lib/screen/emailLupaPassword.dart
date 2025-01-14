import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lectio_divina/model/api.dart' as api;
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/screen/login.dart';

// // class Emaillupapassword extends StatelessWidget {
// //   const Emaillupapassword({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'LECTIO DIVINA',
// //       theme: ThemeData(
// //         fontFamily: "Poppins",
// //         primaryColor: globals.colorTheme,
// //         colorScheme: ColorScheme.fromSeed(seedColor: globals.colorTheme),
// //         useMaterial3: true,
// //       ),
// //       home: const EmailLupaPasswordState(),
// //     );
// //   }
// // }

class EmailLupaPassword extends StatefulWidget {
  const EmailLupaPassword({super.key});

  @override
  State<StatefulWidget> createState() {
    return EmailLupaPasswordState();
  }
}

class EmailLupaPasswordState extends State<EmailLupaPassword> {
  TextEditingController email = TextEditingController();

  String emailErrorText = "";
  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        emailErrorText = 'Email Dibutuhkan';
      });
    } else if (!isEmailValid(value)) {
      setState(() {
        emailErrorText = 'Email tidak Valid';
      });
    } else {
      setState(() {
        emailErrorText = "";
      });
    }
  }

  bool isEmailValid(String email) {
    // Basic email validation using regex
    // You can implement more complex validation if needed
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void kirimEmail() async {
    String emailKirim = email.text;
    final response =
        await api.connectApi("/email/$emailKirim", "post", null);
    if (response.status == 200) {
      if (response.message == 'berhasil') {
        
      } else {
        setState(() {
          // error_login = "Username atau password salah";
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Lupa Password',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Lupa Password",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: email,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Masukkan Email Anda'),
                    onChanged: validateEmail,
                  ),
                ),
                Text(
                  emailErrorText,
                  style: TextStyle(color: Colors.red),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      if (emailErrorText == "") {
                        kirimEmail();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).primaryColor),
                      child: const Center(
                        child: Text(
                          "Kirim Email",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
