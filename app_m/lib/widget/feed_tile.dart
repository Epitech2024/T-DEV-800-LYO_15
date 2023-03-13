import 'package:app_m/http/getImage.dart';
import 'package:app_m/widget/feed.dart';
import 'package:app_m/widget/picture_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FeedTile extends StatefulWidget {
  final String imageId;
  const FeedTile({super.key, required this.imageId});

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  @override
  Widget build(BuildContext context) {
    return PictureFrame(id: widget.imageId);
  }
}

class UnloadedFeedTile extends StatefulWidget {
  const UnloadedFeedTile({super.key});

  @override
  State<UnloadedFeedTile> createState() => _UnloadedFeedTileState();
}

class _UnloadedFeedTileState extends State<UnloadedFeedTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            //UserProfileImage
            LinearProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 94, 94, 94)),
            )
          ],
        ),
      ],
    );
  }
}
