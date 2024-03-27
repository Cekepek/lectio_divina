import 'package:flutter/material.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LECTIO DIVINA',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

var isObscured;

class Login extends StatefulWidget {
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
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(children: [
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
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  _user_id = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter Email'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
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
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            if (error_login != "") Text(error_login),
            Padding(
              padding: EdgeInsets.only(right: 10, bottom: 10),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  child: Align(
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
                  EdgeInsets.only(top: 10, bottom: 50, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Tidak punya akun ? "),
                  GestureDetector(
                    onTap: () {
                      print("Buat");
                    },
                    child: Text(
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
        ));
  }
}
