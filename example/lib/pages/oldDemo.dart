import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';
import '../widgets/meta_data_section.dart';
import '../widgets/play_pause_button_bar.dart';
import '../widgets/player_state_section.dart';
import '../widgets/source_input_section.dart';
import '../widgets/volume_slider.dart';

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
      initialVideoId: 'M26V1IWAP-E',
      params: YoutubePlayerParams(
        playlist: [
          'M26V1IWAP-E',
          "MnrJzXM7a6o",
          "FTQbiNvZqaY",
          "iYKXdt0LRs8",
        ],
        //startAt: Duration(minutes: 1, seconds: 5),
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        autoPlay: true,
        enableCaption: true,
        showVideoAnnotations: false,
        enableJavaScript: true,
        privacyEnhanced: true,
        useHybridComposition: true,
        playsInline: true,
      ),
    )..listen((value) {
        if (value.playerState == PlayerState.buffering) {
          String _time(Duration duration) {
            return "${duration.inMinutes}:${duration.inSeconds}";
          }

          Future.delayed(Duration(milliseconds: 1000), () {
            final bufferedTime = _controller.value.position;
            return print("${_time(bufferedTime)}");
          });
        }

        if (value.isReady && !value.hasPlayed) {
          _controller
            ..hidePauseOverlay()
            ..play()
            ..hideTopMenu();
        }
      });
    // _controller.onEnterFullscreen = () {
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.landscapeRight,
    //   ]);
    // };
    // _controller.onExitFullscreen = () {
    // };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame(
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
    );
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          brightness: Brightness.dark,
          title: const Text('Inline Demo'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (kIsWeb && constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: player),
                  const SizedBox(
                    width: 500,
                    child: SingleChildScrollView(
                      child: Controls(),
                    ),
                  ),
                ],
              );
            }
            return ListView(
              children: [
                player,
                const Controls(),
              ],
            );
          },
        ),
      ),
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
          PlayPauseButtonBar(), _space,
          //Removing from iOS until fixed
          // Builder(
          //   builder: (BuildContext context) {
          //     if (!Platform.isIOS) {
          //       return
          VolumeSlider(),
          //     } else {
          //       return SizedBox.shrink();
          //     }
          //   },
          // ),
          _space,
          PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
