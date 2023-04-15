import 'package:app_m/http/getImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImageThumbnail extends StatelessWidget {
  final List<dynamic> images;
  final String albumId;
  const ImageThumbnail(
      {super.key, required this.images, required this.albumId});
  @override
  Widget build(BuildContext context) {
    print(images[0]['img']['data'].runtimeType);
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.3,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(
          images.length,
          (index) => images[index] != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: getImageHttp(images[index]['img']['data'])
                          .image
                          .image,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
