// Copyright 2021 Jona T. Feucht. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

///
class ThumbnailDemo extends StatefulWidget {
  @override
  _ThumbnailDemo createState() => _ThumbnailDemo();
}

class _ThumbnailDemo extends State<ThumbnailDemo> {
  static String videoID = "F1B9Fk_SgI0";

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
        title: Text("Thumbnail Demo"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: new Center(
            child: Column(
              // center the children
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var e in demo)
                  Image.network(
                    YoutubePlayerController.getThumbnail(
                        videoId: e["videoID"],
                        quality: e["quality"],
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
