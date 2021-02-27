import 'package:flutter/material.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

///
class ThumbnailDemo extends StatefulWidget {
  @override
  _ThumbnailDemo createState() => _ThumbnailDemo();
}

class _ThumbnailDemo extends State<ThumbnailDemo> {
  static String videoID = "GmqVpskrLsQ";

  List<Map<String, dynamic>> demo = [
    {
      "videoID": videoID,
      "quality": ThumbnailQuality.max,
    },
    {
      "videoID": videoID,
      "quality": ThumbnailQuality.standard,
    },
    {
      "videoID": videoID,
      "quality": ThumbnailQuality.high,
    },
    {
      "videoID": videoID,
      "quality": ThumbnailQuality.medium,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Thumbnail Demo"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var i in demo)
                  Image.network(
                    YoutubePlayerController.getThumbnail(
                        videoId: i["videoID"],
                        quality: i["quality"],
                        webp: false),
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
