import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe_example/widgets/meta_data_section.dart';
import 'package:youtube_player_iframe_example/widgets/play_pause_button_bar.dart';
import 'package:youtube_player_iframe_example/widgets/player_state_section.dart';
import 'package:youtube_player_iframe_example/widgets/source_input_section.dart';
import 'package:youtube_player_iframe_example/widgets/volume_slider.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

///
class OldDemo extends StatefulWidget {
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<OldDemo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: 'DXHUAYxuXX8', // livestream example
      params: YoutubePlayerParams(
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
    // Uncomment below for auto rotation on fullscreen
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
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Youtube Plyr Demo'),
        ),
        body: ListView(
          children: [
            player,
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Controls pending migration to null safety.",
              ),
            ),
            //const Controls(),
          ],
        ),
      ),
    );
  }
}

///
/// Migration to null safety pending
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
          //MetaDataSection(),
          // _space,
          // SourceInputSection(),
          _space,
          // PlayPauseButtonBar(),
          _space,
          //VolumeSlider(),
          _space,
          // PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
