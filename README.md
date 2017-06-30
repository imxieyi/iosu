# iosu!

[![Build Status](https://travis-ci.org/imxieyi/iosu.svg?branch=master)](https://travis-ci.org/imxieyi/iosu)

## Introduction
This is an ios port of the rhythm game [osu!](https://osu.ppy.sh). It is written in Swift 3 based on [SpriteKit](https://developer.apple.com/spritekit/) framework. **It is just a hobby project**. So don't expect that I can make it full functional in a short time. More importantly, I'm using a hackintosh for developing. So if it stops working, I cannot continue developing until it is fixed. Also, I don't have much time to spend on this project. But you can still watch the progress.

## What has been done
 - Scan beatmaps imported by iTunes
 - Decode .osu file (partly)
 - Timing with Quartz
 - Render background image & Background dim
 - Draw Plain HitCircle & Judge
 - Draw Sliders & Judge
 - **Play with backgound video**
 - **Play with StoryBoard**
 - **Play with skin in beatmap bundle**

## Installation
### Through XCode
1. Install the latest version of XCode.
2. Compile and install this project on your device **(DO NOT USE SIMULATOR!)**.

### Through Cydia Impactor (Not recommended) (iOS 10.0+ required)
1. Download [Cydia Impactor](http://www.cydiaimpactor.com/).
2. Download latest [ipa artifact](https://git.imxieyi.com/xieyi/iosu/tags) from my personal gitlab server.
3. Connect your iDevice and run Cydia Impactor.
4. Drag .ipa file to Cydia Impactor window.
5. Input your Apple ID info.
6. Wait until it finishes.

## Import Beatmap
![](screenshots/import.png)

## Notice
0. This project is still at **super early stage**, there are plenty of bugs among the whole application. So don't worry if it crashes constantly on your device. If you want to report, please attach **the link to the beatmap on [osu.ppy.sh](https://osu.ppy.sh/)** while creating an issue.
1. Currently there is no database, so please do not import too many beatmaps.
2. **DO NOT** play a beatmap with too complicated storyboard as background. It will make the timing inaccurate and even crash the game.
3. ~~The patched PlaySoundFileNamed function has some bugs that may crash the application, I'm still finding the solution.~~ (should have been fixed in 43e862)
4. I have an iPhone6s and an iPad Pro 10.5 to test, so it may works well on all iDevices.
5. If the framerate drops under 10, the timing will be inaccurate. So do not try to run it in the simulator. If that happens on your device, maybe you can consider update it because of low performance.
6. I have modified the SpriteKitEasingSwift framework to meet the need of osu! storyboard. The [modified version](https://github.com/imxieyi/SpriteKitEasingSwift) can also be installed by CocoaPods.
7. With the help of image buffer, you can load any complicated storyboard with acceptable memory usage. **But be sure to correct storyboard image paths because in Unix-like system file name is case sensitive.** Also, there are still some bugs in the render and processor. But in most of the time it works well.
8. StoryBoard support for [Cheat Sheet](https://osu.ppy.sh/wiki/Storyboard_Scripting/Cheat_Sheet) is incomplete. Loading such storyboards might crash the application.
10. I'm new to iOS development, Swift and SpriteKit. And I don't like to insert a lot of comments. So please tolerate my awful code.

## Selection View Screenshot

![](screenshots/selection.png)

## GamePlay Screenshot

**With background image:**

![](screenshots/p_run.png)

beatmap: [Kanjou Chemistry (Drum 'n' Bass Remix)](https://osu.ppy.sh/s/92509)

**With skin in beatmap bundle:**

![](screenshots/sk_run.png)

beatmap: [Sharlo - Moshimo kara Kitto](https://osu.ppy.sh/s/493198)

**With background video:**

![](screenshots/v_run.png)

beatmap: [Hatsune Miku - SPiCa](https://osu.ppy.sh/s/16226)

**With background storyboard:**

![](screenshots/sb_run.png)

beatmap: [fhana - Outside of Melancholy ~Yuuutsu no Mukougawa~](https://osu.ppy.sh/s/568455)

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

Notice: The following videos are outdated. A lot of bugs have been fixed since they are published. If you want to see the latest version, please install the latest version manually.

[http://www.bilibili.com/video/av9580463/](http://www.bilibili.com/video/av9580463/)

[http://www.bilibili.com/video/av9582040/](http://www.bilibili.com/video/av9582040/)

[http://www.bilibili.com/video/av9582174/](http://www.bilibili.com/video/av9582174/)

[http://www.bilibili.com/video/av9582511/](http://www.bilibili.com/video/av9582511/)

## Credit
 - [osu!](https://osu.ppy.sh)
 - [opsu!](https://github.com/itdelatrisu/opsu)
 - [osu-parser](https://github.com/nojhamster/osu-parser)
 - [SpriteKitEasingSwift](https://github.com/craiggrummitt/SpriteKitEasingSwift)
 - [MobileVLCKit](https://cocoapods.org/pods/MobileVLCKit)
 - ~~[KSYMediaPlayer_iOS](https://github.com/ksvc/KSYMediaPlayer_iOS)~~ (Abandoned because of compatibility issue)
 - [SQLite.swift](https://github.com/stephencelis/SQLite.swift)
 - [UIBezierPath-Length](https://github.com/ImJCabus/UIBezierPath-Length)
 - [Stack Overflow](http://stackoverflow.com)
 - [Apple Developer Documentation](https://developer.apple.com/reference/)
