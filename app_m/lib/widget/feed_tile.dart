import 'package:app_m/http/getImage.dart';
import 'package:app_m/widget/pages/feed.dart';
import 'package:app_m/widget/picture_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
          children: [
            //UserProfileImage
            SizedBox(
              width: 100.0, // Adjust the width to fit your layout
              height: 20.0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 94, 94, 94),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
