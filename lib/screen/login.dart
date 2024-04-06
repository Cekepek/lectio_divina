import 'package:flutter/material.dart';
import 'package:lectio_divina/screen/register.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LECTIO DIVINA',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
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
    _user_id = "test";
    _user_password = "test";
    error_login = "";
    isObscured = true;
  }

  // void doLogin() async {
  //   final response = await http.post(
  //       Uri.parse("https://ubaya.fun/flutter/160420021/meme/login.php"),
  //       body: {'username': _user_id, 'password': _user_password});
  //   if (response.statusCode == 200) {
  //     Map json = jsonDecode(response.body);
  //     if (json['result'] == 'success') {
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setInt("user_id", json['userid']);
  //       main();
  //     } else {
  //       setState(() {
  //         error_login = "Incorrect user or password";
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to read API');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Lectio Divina',
      //     style: TextStyle(fontFamily: 'Poppins'),
      //     textAlign: TextAlign.center,
      //   ),
      //   backgroundColor: Colors.cyan,
      // ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context)
              .size
              .height, //Container harus dikasik fixed size apabila menggunakan singlechildscrollview!!
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 50, bottom: 10, left: 10, right: 10),
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
                  _user_id = value;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Masukkan email anda'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 0, left: 10, right: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: isObscured,
                onChanged: (value) {
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
            if (error_login != "") Text(error_login),
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
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
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
              padding: const EdgeInsets.only(
                  top: 10, bottom: 50, left: 10, right: 10),
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
      ),
    );
  }
}
