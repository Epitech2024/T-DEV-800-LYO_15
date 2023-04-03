import 'package:app_m/http/getImage.dart';
import 'package:flutter/material.dart';

class PictureFrame extends StatefulWidget {
  final String id;
  const PictureFrame({super.key, required this.id});

  @override
  State<PictureFrame> createState() => _PictureFrameState();
}

class _PictureFrameState extends State<PictureFrame> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImageHttp(widget.id),
        builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
          switch (snapshot.connectionState) {
            //case ConnectionState.active:
            //  break;
            case ConnectionState.done:
              return Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.black, width: 1),
                      image: DecorationImage(
                          scale: 0.5, image: snapshot.data!.image)),
                  child: const Text(" "));
            case ConnectionState.waiting:
            case ConnectionState.none:
            default:
              return Container(
                width: MediaQuery.of(context).size.width * (1 / 3),
                height: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.cyanAccent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
          }
        });
  }
}
