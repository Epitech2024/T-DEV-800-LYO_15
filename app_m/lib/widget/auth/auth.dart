import 'dart:developer';

import 'package:app_m/widget/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginIn = true;
  String name = '';
  String password = '';
  String apiDomain = "http://172.18.253.185:3000";

  @override
  Widget build(BuildContext context) {
    void login() async {
      try {
        Map data = {'username': name, 'password': password};
        log(data.toString());
        http.Response response = await http.post(
            Uri.parse("$apiDomain/${loginIn ? 'login' : 'register'}"),
            headers: {"Content-Type": "application/json"},
            body: data);
        print(response);
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "Vous êtes connecté.",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          const storage = FlutterSecureStorage();
          storage.write(key: "jwt", value: response.body);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Feed(feedList: ["63fe1f17f3d7a01f38fa64b0"])),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Erreur connexion",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Erreur serveur",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Your Picts manager',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: (String value) => setState(() {
                    name = value;
                  }),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (value) => setState(() {
                    password = value;
                  }),
                ),
              ),
              this.loginIn
                  ? TextButton(
                      onPressed: () {
                        //forgot password screen
                      },
                      child: const Text(
                        'Forgot Password',
                      ),
                    )
                  : Container(
                      height: 20,
                    ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: login,
                    child: Text(loginIn ? 'login' : 'Register'),
                  )),
              loginIn
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Does not have an account?'),
                        TextButton(
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              loginIn = false;
                            });
                            //signup screen
                          },
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Already have an account ?'),
                        TextButton(
                          child: const Text(
                            'Log in',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              loginIn = true;
                            });
                            //signup screen
                          },
                        )
                      ],
                    ),
            ],
          )),
    );
  }
}
