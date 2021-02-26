// Copyright 2021 Jona T. Feucht. All rights reserved.

import 'dart:developer';

import 'package:flutter/material.dart';

import '../controller.dart';
import '../player_value.dart';
import 'youtube_value_provider.dart';

class YoutubeValueBuilder extends StatefulWidget {
  const YoutubeValueBuilder({
    Key key,
    this.controller,
    @required this.builder,
  }) : super(key: key);

  final YoutubePlayerController controller;
  final Widget Function(BuildContext, YoutubePlayerValue) builder;

  _YoutubeValueBuilderState createState() => _YoutubeValueBuilderState();
}

class _YoutubeValueBuilderState extends State<YoutubeValueBuilder> {
  // @override
  // void dispose() {
  //   widget.controller.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final _controller = widget.controller ?? context.ytController;
    return StreamBuilder<YoutubePlayerValue>(
      stream: _controller,
      initialData: _controller.value,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.builder(context, snapshot.data);
        } else if (snapshot.hasError) {
          log(snapshot.error.toString());
        }
        return const SizedBox();
      },
    );
  }
}
