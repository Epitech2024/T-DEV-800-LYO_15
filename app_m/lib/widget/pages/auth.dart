import 'dart:developer';

import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/widget/chome_page.dart';
import 'package:app_m/widget/pages/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loginIn = true;
  String name = '';
  String password = '';
  String apiDomain = dotenv.env['API']!;

  @override
  Widget build(BuildContext context) {
    Future<bool> login() async {
      try {
        final data = json.encode({'username': name, 'password': password});
        http.Response response = await http.post(
            Uri.parse(
                "http://$apiDomain/${loginIn ? 'auths/login' : 'user/register'}"),
            headers: {"Content-Type": "application/json"},
            body: data);
        if (response.statusCode == 201) {
          Fluttertoast.showToast(
            msg: "You are successfully connected.",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          const storage = FlutterSecureStorage();
          var responseBody = json.decode(response.body);
          await storage.write(key: "jwt", value: responseBody['accessToken']);
          return true;
          //try {
          //  var data = await getAlbum();
          //  await Navigator.pushReplacement(
          //    context,
          //    MaterialPageRoute<void>(
          //      builder: (BuildContext context) => Feed(feedList: data),
          //    ),
          //  );
          //} catch (e) {
          //  print(e);
          //}
          // pushReplacement(
          //           Feed(feedList: ["63fe1f17f3d7a01f38fa64b0"]));

        } else {
          Fluttertoast.showToast(
            msg: "Connexion error",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
          msg: "server error",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      return false;
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
                    onPressed: () async {
                      var state = await login();
                      if (state == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const HomePage(),
                          ),
                        );
                      } else {}
                    },
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
