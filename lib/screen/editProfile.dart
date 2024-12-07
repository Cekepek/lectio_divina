import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lectio_divina/class/user.dart';
import 'package:lectio_divina/main.dart';
import 'package:lectio_divina/model/api.dart' as api;
import 'package:lectio_divina/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final String edit;
  const EditProfile({Key? key, required this.edit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

var obscured;
var obscuredRepeat;

class EditProfileState extends State<EditProfile> {
  late TextEditingController editData = TextEditingController();

  late TextEditingController repeatPassword = TextEditingController();
  late String label = "";
  String error = "";

  void updateData() async {
    if (editData.text.isEmpty) {
      setState(() {
        error = "Username/Password/Nama tidak boleh kosong";
      });
    } else {
      if (widget.edit == "password") {
        if (repeatPassword.text == editData.text) {
          final body = jsonEncode({
            'id': globals.userLogin.id,
            'username': widget.edit == "username"
                ? editData.text
                : globals.userLogin.username,
            'password': widget.edit == "password"
                ? editData.text
                : globals.userLogin.password,
            'nama':
                widget.edit == "nama" ? editData.text : globals.userLogin.name,
            'foto': ""
          });
          final response = await api.connectApi("/updateUser", "put", body);
          if (response.status == 200) {
            print("UPDATED");
            print(response.data);
            if (response.message == 'berhasil') {
              final prefs = await SharedPreferences.getInstance();
              prefs.setString("userLogin", jsonEncode(response.data));
              setState(() {
                globals.userLogin = User.fromJson(response.data);
                globals.currentIndex = 4;
                Fluttertoast.showToast(
                    msg: "Data berhasil di update",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: "Profile",
                            )));
              });
            } else {
              setState(() {
                error = "Data gagal Diupdate";
              });
            }
          } else {
            throw Exception('Failed to read API');
          }
        } else {
          setState(() {
            error = "Password tidak sama";
          });
        }
      } else {
        final body = jsonEncode({
          'id': globals.userLogin.id,
          'username': widget.edit == "username"
              ? editData.text
              : globals.userLogin.username,
          'password': widget.edit == "password"
              ? editData.text
              : globals.userLogin.password,
          'nama':
              widget.edit == "nama" ? editData.text : globals.userLogin.name,
          'foto': ""
        });
        final response = await api.connectApi("/updateUser", "put", body);
        if (response.status == 200) {
          print("UPDATED");
          print(response.data);
          if (response.message == 'berhasil') {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString("userLogin", jsonEncode(response.data));
            setState(() {
              globals.userLogin = User.fromJson(response.data);
              globals.currentIndex = 4;
              Fluttertoast.showToast(
                  msg: "Data berhasil di update",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            title: "Profile",
                          )));
            });
          } else {
            setState(() {
              error = "Data gagal Diupdate";
            });
          }
        } else {
          throw Exception('Failed to read API');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.edit == "username") {
      label = "Username";
      editData.text = globals.userLogin.username;
    } else if (widget.edit == "password") {
      label = "Password";
      editData.text = globals.userLogin.password;
      repeatPassword.text = globals.userLogin.password;
    } else {
      label = "Nama Lengkap";
      editData.text = globals.userLogin.name;
    }
    obscured = true;
    obscuredRepeat = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            globals.currentIndex = 4;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          title: "Profile",
                        )));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
                "Edit data pribadi Anda, pastikan data pribadi Anda sesuai dengan data yang Anda miliki"),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: widget.edit == "password" ? obscured : false,
              controller: editData,
              onChanged: (value) => editData.text = value,
              decoration: InputDecoration(
                suffixIcon: widget.edit == 'password'
                    ? IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        icon: obscured
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: (() {
                          setState(() {
                            obscured = !obscured;
                          });
                        }))
                    : Text(""),
                labelText: label,
              ),
            ),
          ),
          widget.edit == "password"
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: obscuredRepeat,
                    controller: repeatPassword,
                    onChanged: (value) => repeatPassword.text = value,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          icon: obscured
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: (() {
                            setState(() {
                              obscuredRepeat = !obscuredRepeat;
                            });
                          })),
                      labelText: label,
                    ),
                  ),
                )
              : Container(),
          Text(
            error,
            style: TextStyle(color: Colors.red),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                updateData();
              },
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: const Center(
                  child: Text(
                    'Simpan',
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
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () {
                  globals.currentIndex = 4;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: "Profile",
                              )));
                },
                child: Text("Kembali")),
          )
        ],
      ),
    );
  }
}
