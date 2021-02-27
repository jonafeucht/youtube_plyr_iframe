## 2.0.0-nullsafety.3
- 💪 Running with sound null safety 💪

## 2.0.0-nullsafety.2
- Relax SDK version constraints.
- Android `minSdkVersion 23` is required.

## 2.0.0-nullsafety.1
- 💪 Running with sound null safety 💪 (Almost)

## 1.3.6+1
- Added example app

## 1.3.5
- Minor fix

## 1.3.4
- Added migration guide

## 1.3.3
- Fix `type 'int' is not a subtype of type 'double' in type cast`
- Fix `The Flutter constraint should not have an upper bound.`

## 1.3.2+1
- Fix homepage and repo page

## 1.3.2
- Fixes desktop mode on iPad + nullsafety

## 1.3.0+1
- Fixes videos opening up in browser instead of inline on iOS.

## 1.2.0+2
- Added `YoutubePlayerParams.privacyEnhanced` flag.
- Exposed `gestureRecognizers` through `YoutubePlayerIFrame` widget.
- Handled internal links correctly. Tapping on video suggestion will now play it and all the buttons are enabled.
- Flutter `>=1.22.0 <2.0.0` is required.

## 1.1.0
- **Fixed** Black Screen on iOS [#302](https://github.com/sarbagyastha/youtube_player_flutter/issues/302).
- **Fixed** Minor fix for web player [#300](https://github.com/sarbagyastha/youtube_player_flutter/issues/300)
- `enableKeyboard` flag is true by default for web.

## 1.0.1
- **Fixed** Disabled navigation inside the player. This solves the issue where tapping on actions would navigate to different web pages.
- Removed `foreceHD` param, in favor of `desktopMode`. The `desktopMode` also supports changing quality in fullscreen mode.
- Added two new methods, `hideTopMenu()` and `hidePauseOverlay()`. Visit ReadMe for more detail.

## 1.0.0+4
- Minor improvements

## 1.0.0+3
- Minor Fixes

## 1.0.0
- Initial Release
