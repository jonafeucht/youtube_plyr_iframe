// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

///
class MetaDataSection extends StatelessWidget {
  double? v = 1.0;
  @override
  Widget build(BuildContext context) {
    return YoutubeValueBuilder(builder: (context, value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Text('Title', value.metaData.title),
          const SizedBox(height: 10),
          _Text('Channel', value.metaData.author),
          const SizedBox(height: 10),
          _Text(
            'Playback Quality',
            value.playbackQuality ?? '',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _Text('Video Id', value.metaData.videoId),
            ],
          ),
          Row(
            children: <Widget>[
              const Text(
                "Speed",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              Expanded(
                child: Slider(
                  inactiveColor: Colors.transparent,
                  value: value.playbackRate,
                  min: 0.25,
                  max: 2.0,
                  divisions: 7,
                  label: '$v',
                  onChanged: (double? newValue) {
                    if (newValue != null) {
                      v = newValue;
                      context.ytController.setPlaybackRate(newValue);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _Text extends StatelessWidget {
  final String title;
  final String value;

  const _Text(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
