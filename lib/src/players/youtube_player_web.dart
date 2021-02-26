// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_plyr_iframe/src/enums/player_state.dart';
import 'package:youtube_plyr_iframe/src/enums/youtube_error.dart';
import 'package:youtube_plyr_iframe/src/helpers/player_fragments.dart';

import '../controller.dart';
import '../meta_data.dart';
import 'platform_view_stub.dart' if (dart.library.html) 'dart:ui' as ui;

/// A youtube player widget which interacts with the underlying iframe inorder to play YouTube videos.
///
/// Use [YoutubePlayerIFrame] instead.
class RawYoutubePlayer extends StatefulWidget {
  /// The [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// no-op
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// Creates a [MobileYoutubePlayer] widget.
  const RawYoutubePlayer({
    Key? key,
    this.controller,
    this.gestureRecognizers,
  }) : super(key: key);

  @override
  _WebYoutubePlayerState createState() => _WebYoutubePlayerState();
}

class _WebYoutubePlayerState extends State<RawYoutubePlayer> {
  late YoutubePlayerController controller;
  late Completer<IFrameElement> _iFrame;

  @override
  void initState() {
    super.initState();
    controller = widget.controller!;
    _iFrame = Completer();
    final playerIFrame = IFrameElement()
      ..srcdoc = player
      ..style.border = 'none';
    ui.platformViewRegistry.registerViewFactory(
      'youtube-player-${controller.hashCode}',
      (int id) {
        window.onMessage.listen(
          (event) {
            final Map<String, dynamic> data = jsonDecode(event.data);
            if (data.containsKey('Ready')) {
              controller.add(
                controller.value!.copyWith(isReady: true),
              );
            }

            if (data.containsKey('StateChange')) {
              switch (data['StateChange'] as int) {
                case -1:
                  controller.add(
                    controller.value!.copyWith(
                      playerState: PlayerState.unStarted,
                      isReady: true,
                    ),
                  );
                  break;
                case 0:
                  controller.add(
                    controller.value!.copyWith(
                      playerState: PlayerState.ended,
                    ),
                  );
                  break;
                case 1:
                  controller.add(
                    controller.value!.copyWith(
                      playerState: PlayerState.playing,
                      hasPlayed: true,
                      error: YoutubeError.none,
                    ),
                  );
                  break;
                case 2:
                  controller.add(
                    controller.value!.copyWith(
                      playerState: PlayerState.paused,
                    ),
                  );
                  break;
                case 3:
                  controller.add(
                    controller.value!.copyWith(
                      playerState: PlayerState.buffering,
                    ),
                  );
                  break;
                case 5:
                  controller.add(
                    controller.value!.copyWith(
                      playerState: PlayerState.cued,
                    ),
                  );
                  break;
                default:
                  throw Exception("Invalid player state obtained.");
              }
            }

            if (data.containsKey('PlaybackQualityChange')) {
              controller.add(
                controller.value!.copyWith(
                    playbackQuality: data['PlaybackQualityChange'].toString()),
              );
            }

            if (data.containsKey('PlaybackRateChange')) {
              final rate = data['PlaybackRateChange'].toNum();
              controller.add(
                controller.value!.copyWith(playbackRate: rate.toDouble()),
              );
            }

            if (data.containsKey('Errors')) {
              controller.add(
                controller.value!
                    .copyWith(error: errorEnum(data['Errors'].toInt())),
              );
            }

            if (data.containsKey('VideoData')) {
              controller.add(
                controller.value!.copyWith(
                    metaData: YoutubeMetaData.fromRawData(data['VideoData'])),
              );
            }

            if (data.containsKey('VideoTime')) {
              final position = data['VideoTime']['currentTime'].toDouble();
              final buffered = data['VideoTime']['videoLoadedFraction'].toNum();

              if (position == null || buffered == null) return;
              controller.add(
                controller.value!.copyWith(
                  position: Duration(milliseconds: (position * 1000).floor()),
                  buffered: buffered.toDouble(),
                ),
              );
            }
          },
        );
        if (!_iFrame.isCompleted) {
          _iFrame.complete(playerIFrame);
        }
        controller.invokeJavascript = _callMethod;
        return playerIFrame;
      },
    );
  }

  Future<void> _callMethod(String methodName) async {
    final iFrame = await _iFrame.future;
    iFrame.contentWindow?.postMessage(methodName, '*');
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: ObjectKey(controller),
      viewType: 'youtube-player-${controller.hashCode}',
    );
  }

  String get player => '''
    <!DOCTYPE html>
    <body>
        ${youtubeIFrameTag(controller)}
         <style>
    .highPlayer {

        position: absolute;
        height: 100%;
        width:100%;
        top:0px;
        left:0px;
        bottom:0px;
        right:10px;
    }
        #player {
        position: absolute;
        height: 100%;
        width:100%;
        top:0px;
        left:0px;
        bottom:0px;
        right:10px;
    }
    .highPlayer.ended::after {
        content:"";
        position: absolute;
        top: 0;
        left: 0;
        bottom: 0;
        right: 0;
        cursor: pointer;
        background-color: black;
        background-repeat: no-repeat;
        background-position: center; 
        background-size: 64px 64px;
        background-image: url(data:image/svg+xml;utf8;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMjgiIGhlaWdodD0iMTI4IiB2aWV3Qm94PSIwIDAgNTEwIDUxMCI+PHBhdGggZD0iTTI1NSAxMDJWMEwxMjcuNSAxMjcuNSAyNTUgMjU1VjE1M2M4NC4xNSAwIDE1MyA2OC44NSAxNTMgMTUzcy02OC44NSAxNTMtMTUzIDE1My0xNTMtNjguODUtMTUzLTE1M0g1MWMwIDExMi4yIDkxLjggMjA0IDIwNCAyMDRzMjA0LTkxLjggMjA0LTIwNC05MS44LTIwNC0yMDQtMjA0eiIgZmlsbD0iI0ZGRiIvPjwvc3ZnPg==);
    }
    .highPlayer.paused::after {
        content:"";
        position: absolute;
        top: 0px;
        left: 0;
        bottom: 0px;
        right: 0;
        cursor: pointer;
        background-color: black;
        background-repeat: no-repeat;
        background-position: center; 
        background-size: 40px 40px;
        background-image: url(data:image/svg+xml;utf8;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEiIHdpZHRoPSIxNzA2LjY2NyIgaGVpZ2h0PSIxNzA2LjY2NyIgdmlld0JveD0iMCAwIDEyODAgMTI4MCI+PHBhdGggZD0iTTE1Ny42MzUgMi45ODRMMTI2MC45NzkgNjQwIDE1Ny42MzUgMTI3Ny4wMTZ6IiBmaWxsPSIjZmZmIi8+PC9zdmc+);
    }
</style>
      <script>
    "use strict";
    document.addEventListener('DOMContentLoaded', function() {
        // Activate only if not already activated
        if (window.hideYTActivated) return;
        // Activate on all players
        let onYouTubeIframeAPIReadyCallbacks = [];
        for (let playerWrap of document.querySelectorAll(".highPlayer")) {
            let playerFrame = playerWrap.querySelector("iframe");
            
            let tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            let firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
            
            let onPlayerStateChange = function(event) {
                if (event.data == YT.PlayerState.ENDED) {
                    playerWrap.classList.add("ended");
                } else if (event.data == YT.PlayerState.PAUSED) {
                    playerWrap.classList.add("paused");
                } else if (event.data == YT.PlayerState.PLAYING) {
                    playerWrap.classList.remove("ended");
                    playerWrap.classList.remove("paused");
                }
            };
            
            let player;
            onYouTubeIframeAPIReadyCallbacks.push(function() {
                player = new YT.Player(playerFrame, {
                    events: {
                        'onStateChange': onPlayerStateChange
                    }
                });
            });
          
            playerWrap.addEventListener("click", function() {
                let playerState = player.getPlayerState();
                if (playerState == YT.PlayerState.ENDED) {
                    player.seekTo(0);
                } else if (playerState == YT.PlayerState.PAUSED) {
                    player.playVideo();
                }
            });
        }
        
        window.onYouTubeIframeAPIReady = function() {
            for (let callback of onYouTubeIframeAPIReadyCallbacks) {
                callback();
            }
        };
        
        window.hideYTActivated = true;
    });
</script>
        <script>

            $initPlayerIFrame
            var player;
            var timerId;
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('player', {
                    events: {
                      onReady: (event) => sendMessage({ 'Ready': true }),
                      onStateChange: (event) => sendPlayerStateChange(event.data),
                      onPlaybackQualityChange: (event) => sendMessage({ 'PlaybackQualityChange': event.data }),
                      onPlaybackRateChange: (event) => sendMessage({ 'PlaybackRateChange': event.data }),
                      onError: (error) => sendMessage({ 'Errors': event.data }),
                    },
                });
            }
            
            window.addEventListener('message', (event) => {
               try { eval(event.data) } catch (e) {}
            }, false);
            
            function sendMessage(message) {
              window.parent.postMessage(JSON.stringify(message), '*');
            }

            function sendPlayerStateChange(playerState) {
                clearTimeout(timerId);
                sendMessage({ 'StateChange': playerState });
                if (playerState == 1) {
                    startSendCurrentTimeInterval();
                    sendVideoData(player);
                }
            }

            function sendVideoData(player) {
                var videoData = {
                    'duration': player.getDuration(),
                    'title': player.getVideoData().title,
                    'author': player.getVideoData().author,
                    'videoId': player.getVideoData().video_id
                };
                sendMessage({ 'VideoData': videoData });
            }

            function startSendCurrentTimeInterval() {
                timerId = setInterval(function () {
                  var videoTime = {
                      'currentTime': player.getCurrentTime(),
                      'videoLoadedFraction': player.getVideoLoadedFraction()
                  };
                  sendMessage({ 'VideoTime': videoTime });
                }, 100);
            }
            
            $youtubeIFrameFunctions
        </script>
    </body>
  ''';
}
