import 'package:app_m/http/getImage.dart';
import 'package:flutter/material.dart';

class PictureFrame extends StatefulWidget {
  final List data;
  final bool toBeselected;
  final String id;
  final Function(String) onSelectionChanged;
  const PictureFrame(
      {super.key,
      required this.data,
      required this.onSelectionChanged,
      required this.toBeselected,
      required this.id});

  @override
  State<PictureFrame> createState() => _PictureFrameState();
}

class _PictureFrameState extends State<PictureFrame> {
  late ImageSelection imageSelection;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    var imgs = getImageHttp(widget.data);
    setState(() {
      imageSelection = imgs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.toBeselected) {
            imageSelection.isSelected = !imageSelection.isSelected;
            widget.onSelectionChanged(widget.id);
          }
        });
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              image: DecorationImage(
                  scale: 0.5, image: imageSelection.image.image)),
          child: Stack(children: [
            if (imageSelection.isSelected && widget.toBeselected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
              ),
          ])),
    );
  }
}
