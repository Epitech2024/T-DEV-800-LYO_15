import 'dart:developer';
import 'dart:io';

import 'package:app_m/http/getAlbum.dart';
import 'package:app_m/http/postImage.dart';
import 'package:app_m/widget/auth/auth.dart';
import 'package:app_m/widget/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "lib/.env");

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  int _counter = 0;
  ImagePicker _picker = ImagePicker();

  String? codeDialog;
  String? valueText;
  Future<void> addPhoto() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? path = image!.path;
      File imageFile = File(path);

      bool posted = await postImageHttp(imageFile);
      if (posted == true) {
        log("Post successful");
      } else {
        log("Post failed");
      }
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Name for your photo'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    valueText = '';
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () async {
                  setState(() {
                    codeDialog = valueText;
                  });
                  print(valueText);
                  if (valueText != null) {
                    await addPhoto();
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                      msg: "Choose a name before sending !",
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
            ],
          );
        });
  }

  Future<bool> checkToken() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'jwt');
    return (token != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getAlbum(), //remplace by getFeed
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            Future<Widget> buildWidget() async {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (await checkToken()) {
                    return Feed(feedList: snapshot.data!);
                  } else {
                    return const AuthPage();
                  }
                case ConnectionState.waiting:
                case ConnectionState.none:
                default:
                  return const UnloadedFeed();
              }
            }

            return FutureBuilder<Widget>(
              future: buildWidget(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data!;
                } else {
                  return const UnloadedFeed();
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        tooltip: 'add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
