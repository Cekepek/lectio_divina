import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lectio_divina/main.dart';
import 'package:lectio_divina/screen/register.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lectio_divina/model/api.dart' as api;

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});
  @override
  Widget build(BuildContext context) {
    // final theme = Provider.of<ThemeModel>(context);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MaterialApp(
      title: 'LECTIO DIVINA',
      theme: ThemeData(
        fontFamily: "Poppins",
        primaryColor: globals.colorTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: globals.colorTheme),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}

var isObscured;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  late String _user_id;
  late String _user_password;
  late String error_login;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user_id = "";
    _user_password = "";
    error_login = "";

    isObscured = true;
    globals.sinkronasiSelesai = false;
  }

  // void doLogin() {
  //   if (globals.tesUsername == _user_id &&
  //       globals.tesPassword == _user_password) {
  //     globals.userid = 1;
  //     main();
  //   } else {
  //     setState(() {
  //       error_login = "Password/Username Salah";
  //     });
  //   }
  // }
  void doLogin() async {
    if (_user_id.isEmpty || _user_password.isEmpty) {
      setState(() {
        error_login = "Username/Password tidak boleh kosong";
      });
    } else {
      final response = await api.connectApi(
          "/login?username=$_user_id&password=$_user_password", "post", null);
      if (response.status == 200) {
        if (response.message == 'berhasil') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("userLogin", jsonEncode(response.data));
          final String userLogin =
              await prefs.getString("userLogin") ?? "GAK ADA";
          print("LOGIN = $userLogin");
          setState(() {
            globals.currentIndex = 0;
            titleHome = "Lectio Divina";
            globals.MyLd.clear();
          });
          main();
        } else {
          setState(() {
            error_login = "Username atau password salah";
          });
        }
      } else {
        throw Exception('Failed to read API');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login',
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
        child: Column(children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 50, bottom: 10, left: 10, right: 10),
            child: Container(
              child: Image(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  image: AssetImage('assets/images/new_logo.png'),
                  fit: BoxFit.contain),
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
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
            child: Container(
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
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
                  error_login = "";
                });
                _user_id = value;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Masukkan username anda'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              obscureText: isObscured,
              onChanged: (value) {
                setState(() {
                  error_login = "";
                });

                _user_password = value;
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
                  border: const OutlineInputBorder(),
                  labelText: 'Kata Sandi',
                  hintText: 'Masukkan kata sandi'),
            ),
          ),
          if (error_login != "")
            Text(
              error_login,
              style: TextStyle(color: Colors.red),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Lupa kata sandi ?",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                      fontSize: 13,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    doLogin();
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child: Text(
                        'Login',
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
                const EdgeInsets.only(top: 10, bottom: 50, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Tidak punya akun ? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyRegister(),
                      ),
                    );
                  },
                  child: const Text(
                    "Buat akun sekarang",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
