# iosu!

## Introduction
This is an ios port of the rhythm game [osu!](https://osu.ppy.sh). It is written in Swift based on [SpriteKit](https://developer.apple.com/spritekit/) framework. **It is just a hobby project**. So don't expect that I can make it full functional in a short time. Most importantly, I'm using a hackintosh for developing. So if it stops working, I cannot continue developing until it is fixed. Also, I don't have much time to spend on this project. But you can still watch the progress.

## What has been done
 - Scan beatmaps imported by iTunes
 - Decode .osu file (partly)
 - Timing
 - Render background image & Background dim
 - Draw Plain HitCircle & Judge
 - Draw Sliders & Judge
 - **Play backgound video**
 - **Play StoryBoard**

## Installation
### Through XCode
1. Install the latest version of XCode.
2. Compile and install this project on your device **(DO NOT USE SIMULATOR!)**.

### Through Cydia Impactor (Not recommended)
1. Download [Cydia Impactor](http://www.cydiaimpactor.com/).
2. Download latest [ipa artifact](https://github.com/imxieyi/iosu/releases).
3. Connect your iDevice and run Cydia Impactor.
4. Drag .ipa file to Cydia Impactor window.
5. Input your Apple ID info.
6. Wait until it finishes.

## Import Beatmap
![](screenshots/import.png)

4. Run the application.

## Notice
1. Currently there is no database, so please do not import too many beatmaps.
2. I don't know if the timing is accurate because I always get "100" on hit circles! :)
3. I only have an iPhone6s to test, so it may render terribly on devices with different resolutions.
4. If the framerate drops under 10, the timing will be inaccurate. So do not try to run it in the simulator. If that happens on your device, maybe you can consider update it because of low performance.
5. I have modified the SpriteKitEasingSwift framework to meet the need of osu! storyboard. The [modified version](https://github.com/imxieyi/SpriteKitEasingSwift) can also be installed by CocoaPods.
6. Now with the help of image buffer, you can load any complicated storyboard. **But be sure to correct storyboard image paths because in Unix-like system file name is case sensitive.** Also, there is still some bugs in the render and processor. But in most of the time it works well.
7. StoryBoard support for [Cheat Sheet](https://osu.ppy.sh/wiki/Storyboard_Scripting/Cheat_Sheet) is incomplete. Loading such storyboards might crash the application.
8. Both the osu game and StoryBoard player are unfinished.
9. I'm new to iOS development, Swift and SpriteKit. And I don't like to insert a lot of comments. So please tolerate my awful code.

## GamePlay Screenshot

**With background image:**

![](screenshots/p_run.png)

beatmap: [Kanjou Chemistry (Drum 'n' Bass Remix)](https://osu.ppy.sh/s/92509)

**With background video:**

![](screenshots/v_run.png)

beatmap: [Hatsune Miku - SPiCa](https://osu.ppy.sh/s/16226)

## StoryBoard Screenshot

![](screenshots/sbplayer1.png)

beatmap: [Tatsumi Megumi featured by Sano Hiroaki - Tsubomi (Long Version)](https://osu.ppy.sh/s/311064)

![](screenshots/sbplayer2.png)

![](screenshots/sbplayer3.png)

beatmap: [Kana Nishino - Sweet Dreams (11t dnb mix)](https://osu.ppy.sh/s/499488)

![](screenshots/sbplayer4.png)

beatmap: [DM vs. POCKET - uNDeRWoRLD MoNaRCHy](https://osu.ppy.sh/s/412938)

## Gameplay Demo Video

[http://www.bilibili.com/video/av10522729/](http://www.bilibili.com/video/av10522729/)

beatmap: [GhostFinal - Gan Xie](https://osu.ppy.sh/s/84520)

## StoryBoard Demo Videos

Notice: The following videos are outdated. If you want to see the latest version, please clone and install this repository on your device.

[http://www.bilibili.com/video/av9580463/](http://www.bilibili.com/video/av9580463/)

[http://www.bilibili.com/video/av9582040/](http://www.bilibili.com/video/av9582040/)

[http://www.bilibili.com/video/av9582174/](http://www.bilibili.com/video/av9582174/)

[http://www.bilibili.com/video/av9582511/](http://www.bilibili.com/video/av9582511/)

## Credit
 - [osu!](https://osu.ppy.sh)
 - [opsu!](https://github.com/itdelatrisu/opsu)
 - [osu-parser](https://github.com/nojhamster/osu-parser)
 - [SpriteKitEasingSwift](https://github.com/craiggrummitt/SpriteKitEasingSwift)
 - [KSYMediaPlayer_iOS](https://github.com/ksvc/KSYMediaPlayer_iOS)
 - [SQLite.swift](https://github.com/stephencelis/SQLite.swift)
 - [UIBezierPath-Length](https://github.com/ImJCabus/UIBezierPath-Length)
 - [Stack Overflow](http://stackoverflow.com)
 - [Apple Developer Documentation](https://developer.apple.com/reference/)
