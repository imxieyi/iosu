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
    
    static func setfile(file:String) {
        let url=URL(fileURLWithPath: file)
        self.musicPlayer = try! AVAudioPlayer(contentsOf: url)
        self.musicPlayer.numberOfLoops=0
    }
    
    private static var starttime:Double = 0
    
    static func startPlaying() {
        var offset = -min(gameEarliest,videoEarliest,sbEarliest)
        debugPrint("music offset: \(offset)")
        if offset < 2000 {
            offset = 2000
        }
        if sbScene != nil && StoryBoardScene.hasSB {
            sbScene?.preparesb(offset: offset)
        }
        if gameScene != nil {
            gameScene?.preparevideo(offset: offset)
            gameScene?.preparegame(offset: offset)
        }
        starttime = CACurrentMediaTime() + Double(offset)/1000
        if sbScene != nil {
            sbScene?.run(SKAction.sequence([SKAction.wait(forDuration: Double(offset)/1000), SKAction.run {
                self.musicPlayer.prepareToPlay()
                self.musicPlayer.play()
                }]))
        } else {
            gameScene?.run(SKAction.sequence([SKAction.wait(forDuration: Double(offset)/1000), SKAction.run {
                self.musicPlayer.prepareToPlay()
                self.musicPlayer.play()
                }]))
        }
    }
    
    static func getTime() -> TimeInterval{
        if !isplaying() {
            return CACurrentMediaTime() - starttime
        }
        return musicPlayer.currentTime
    }
    
    static func isplaying() -> Bool{
        if musicPlayer==nil {
            return false
        }
        return musicPlayer.isPlaying
    }
    
}
