//
//  MusicPlayer.swift
//  iosu
//
//  Created by xieyi on 2017/3/30.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit
import QuartzCore

class BGMusicPlayer{
    
    private static var musicPlayer: AVAudioPlayer!
    public static var gameEarliest:Int = 0
    public static var videoEarliest:Int = 0
    public static var sbEarliest:Int = 0
    public static var gameScene:GamePlayScene?
    public static var sbScene:StoryBoardScene?
    public static var bgmvolume:Float = 1.0
    
    static func setfile(file:String) {
        let url=URL(fileURLWithPath: file)
        self.musicPlayer = try! AVAudioPlayer(contentsOf: url)
        self.musicPlayer.numberOfLoops=0
        self.musicPlayer.volume = bgmvolume
    }
    
    private static var starttime:Double = 0
    
    static func startPlaying() {
        debugPrint("game earliest: \(gameEarliest)")
        debugPrint("video earliest: \(videoEarliest)")
        debugPrint("sb earliest: \(sbEarliest)")
        var offset = -min(gameEarliest,videoEarliest,sbEarliest)
        debugPrint("music offset: \(offset)")
        if offset < 3000 {
            offset = 3000
        } else {
            offset += 100
        }
        starttime = CACurrentMediaTime() + Double(offset)/1000
        let musicnode = SKNode()
        if gameScene != nil {
            gameScene?.addChild(musicnode)
        } else {
            sbScene?.addChild(musicnode)
        }
        musicnode.run(SKAction.sequence([SKAction.wait(forDuration: Double(offset)/1000), SKAction.run {
            self.musicPlayer.prepareToPlay()
            self.musicPlayer.play()
            self.starttime = CACurrentMediaTime()
            }]))
    }
    
    static func getTime() -> TimeInterval{
        return CACurrentMediaTime() - starttime
    }
    
    static func isplaying() -> Bool{
        if musicPlayer==nil {
            return false
        }
        return musicPlayer.isPlaying
    }
    
}
