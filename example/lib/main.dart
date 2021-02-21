// Copyright 2021 Jona T. Feucht. All rights reserved.

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe_example/pages/oldDemo.dart';
import 'package:youtube_player_iframe_example/pages/thumbnailDemo.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

import 'widgets/meta_data_section.dart';
import 'widgets/play_pause_button_bar.dart';
import 'widgets/player_state_section.dart';
import 'widgets/source_input_section.dart';
import 'widgets/volume_slider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(YoutubeApp());
}

///
class YoutubeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Plyr Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      home: YoutubeAppDemo(),
    );
  }
}

///
class YoutubeAppDemo extends StatefulWidget {
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '5qap5aO4i9A', // livestream example
      params: YoutubePlayerParams(
        playlist: [
          'F1B9Fk_SgI0',
          "MnrJzXM7a6o",
          "FTQbiNvZqaY",
          "iYKXdt0LRs8",
        ],

        //startAt: Duration(minutes: 1, seconds: 5),
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false, // false for platform design
        autoPlay: false,
        enableCaption: true,
        showVideoAnnotations: false,
        enableJavaScript: true,
        privacyEnhanced: true,
        playsInline: true, // iOS only - Auto fullscreen or not
      ),
    )..listen((value) {
        if (value.isReady && !value.hasPlayed) {
          _controller
            ..hidePauseOverlay()
            // Uncomment below to start autoplay on iOS
            //..play()
            ..hideTopMenu();
        }
      });
    //Uncomment below for auto rotation on fullscreen
    // _controller.onEnterFullscreen = () {
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.landscapeRight,
    //   ]);
    //   log('Entered Fullscreen');
    // };
    // _controller.onExitFullscreen = () {
    //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //   Future.delayed(const Duration(seconds: 1), () {
    //     _controller.play();
    //   });
    //   Future.delayed(const Duration(seconds: 5), () {
    //     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //   });
    //   log('Exited Fullscreen');
    // };
  }

  @override
  Widget build(BuildContext context) {
    // return object of type Dialog
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: _controller,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: new Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: new Column(
                  // center the children
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        ElevatedButton(
                          child: Text("Old Demo"),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OldDemo()),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          child: Text("Thumbnail Demo"),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ThumbnailDemo()),
                          ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _showDialog();
                        },
                        child: Card(
                          child: Container(
                              height: 300,
                              width: MediaQuery.of(context).size.width / 2,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: new DecorationImage(
                                  colorFilter: new ColorFilter.mode(
                                      Colors.black.withOpacity(0.7),
                                      BlendMode.dstATop),
                                  image: NetworkImage(
                                    YoutubePlayerController.getThumbnail(
                                        videoId: "F1B9Fk_SgI0",
                                        quality: ThumbnailQuality.max,
                                        webp: false),
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.brown,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Stack(
                                  fit: StackFit.expand,
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        Icons.play_circle_filled,
                                        color: Colors.white,
                                        size: 55.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Controls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final player = YoutubePlayerIFrame();
        // return object of type Dialog
        return YoutubePlayerControllerProvider(
          // Passing controller to widgets below.
          controller: _controller,
          child: AlertDialog(
            title: new Text("Demo Video"),
            content: player,
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          MetaDataSection(),
          _space,
          SourceInputSection(),
          _space,
          PlayPauseButtonBar(),
          _space,
          VolumeSlider(),
          _space,
          PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
