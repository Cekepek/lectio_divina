import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lectio_divina/model/api.dart' as api;
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/screen/login.dart';

class MyRegister extends StatelessWidget {
  const MyRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LECTIO DIVINA',
      theme: ThemeData(
        fontFamily: "Poppins",
        primaryColor: globals.colorTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: globals.colorTheme),
        useMaterial3: true,
      ),
      home: const Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

var isObscuredRegister;
var isObscuredRepeatPassword;

class _RegisterState extends State<Register> {
  late String username;
  late String password;
  late String name;
  late String repeat_password;
  late String error_register;
  TextEditingController email = TextEditingController();
  TextEditingController noHp = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = "";
    password = "";
    name = "";
    repeat_password = "";
    error_register = "";
    isObscuredRegister = true;
    isObscuredRepeatPassword = true;
  }

  void createAccount() async {
    if (username.isEmpty || password.isEmpty || name.isEmpty) {
      setState(() {
        error_register = "Username/Password/Nama tidak boleh kosong";
      });
    } else {
      if (repeat_password == password) {
        final body = jsonEncode({
          'username': username,
          'password': password,
          'nama': name,
          'foto': "",
          'email': email.text,
          'no_hp': noHp.text,
        });
        final response = await api.connectApi("/user", "post", body);
        if (response.status == 200) {
          print("MASUK");
          print(response.data);
          if (response.message == 'berhasil') {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyLogin(),
                  ));
            });
          } else {
            setState(() {
              error_register = "Akun gagal Dibuat";
            });
          }
        } else {
          throw Exception('Failed to read API');
        }
      } else {
        setState(() {
          error_register = "Password tidak sama";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Register',
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 10, right: 10),
                child: Container(
                  child: Image(
                      width: MediaQuery.of(context).size.width,
                      image: AssetImage('assets/images/Logo.png'),
                      fit: BoxFit.fill),
                ),
              ), //CONTAINER UNTUK LOGO
              const Padding(
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
                padding: const EdgeInsets.only(
                    top: 10, bottom: 0, left: 10, right: 10),
                child: Container(
                  child: const Align(
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
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      error_register = "";
                    });
                    name = value;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama',
                      hintText: 'Masukkan nama anda'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: email,
                  onChanged: (value) {
                    setState(() {
                      error_register = "";
                    });
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Masukkan Email anda'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: noHp,
                  onChanged: (value) {
                    setState(() {
                      error_register = "";
                    });
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'No Handphone',
                      hintText: 'Masukkan no HP anda'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      error_register = "";
                    });
                    username = value;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'username',
                      hintText: 'Masukkan username anda'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 0, left: 10, right: 10),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  obscureText: isObscuredRegister,
                  onChanged: (value) {
                    setState(() {
                      error_register = "";
                    });
                    password = value;
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          icon: isObscuredRegister
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: (() {
                            setState(() {
                              isObscuredRegister = !isObscuredRegister;
                            });
                          })),
                      border: const OutlineInputBorder(),
                      labelText: 'Kata Sandi',
                      hintText: 'Masukkan kata sandi anda'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 0, left: 10, right: 10),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  obscureText: isObscuredRepeatPassword,
                  onChanged: (value) {
                    setState(() {
                      error_register = "";
                    });
                    repeat_password = value;
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          icon: isObscuredRepeatPassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: (() {
                            setState(() {
                              isObscuredRepeatPassword =
                                  !isObscuredRepeatPassword;
                            });
                          })),
                      border: const OutlineInputBorder(),
                      labelText: 'Ulang Kata Sandi',
                      hintText: 'Masukkan ulang kata sandi anda'),
                ),
              ),
              if (error_register != "")
                Text(
                  error_register,
                  style: TextStyle(color: Colors.red),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        createAccount();
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(
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
                padding: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah memiliki akun ? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyLogin(),
                          ),
                        );
                      },
                      child: const Text(
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
        ));
  }
}
