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
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class OldDemo extends StatefulWidget {
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<OldDemo> {
  late YoutubePlayerController _controller;

  var v;
  var t;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'TXobm_jJbWM',
      params: YoutubePlayerParams(
        playlist: [
          'TXobm_jJbWM',
          "MnrJzXM7a6o",
          "FTQbiNvZqaY",
          "iYKXdt0LRs8",
        ],
        startAt: Duration(seconds: 33),
        showControls: false,
        showFullscreenButton: true,
        desktopMode: false,
        autoPlay: true,
        enableCaption: true,
        showVideoAnnotations: false,
        enableJavaScript: true,
        privacyEnhanced: true,
        useHybridComposition: true,
        playsInline: true,
        pointerEvent: true,
      ),
    )..listen((value) {
        setState(() {
          v = _controller.value.position;
          t = _controller.value.metaData.duration;
        });
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
            ..hideYoutubeLogo()
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 35,
                  ),
                  child: ProgressBar(
                    progress: v ?? Duration(minutes: 0),
                    total: t ?? Duration(minutes: 0),
                    onSeek: (duration) {
                      print('User selected a new time: $duration');
                    },
                  ),
                ),
                // YoutubeValueBuilder(
                //   builder: (context, value) {
                //     return ElevatedButton(
                //         onPressed: () => {context.ytController.setSize()},
                //         child: Text("HI"));
                //   },
                // ),
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
    return Column(
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
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
