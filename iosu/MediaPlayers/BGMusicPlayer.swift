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

enum BGMusicState {
    case playing
    case paused
    case stopped
}

class BGMusicPlayer: NSObject, AVAudioPlayerDelegate {
    
    static let instance = BGMusicPlayer()
    
    fileprivate var musicPlayer: AVAudioPlayer!
    open var gameEarliest:Int = 0
    open var videoEarliest:Int = 0
    open var sbEarliest:Int = 0
    open var gameScene:GamePlayScene?
    open var sbScene:StoryBoardScene?
    open var bgmvolume:Float = 1.0
    open var state: BGMusicState = .stopped
    
    func setfile(_ file:String) {
        let url=URL(fileURLWithPath: file)
        self.musicPlayer = try! AVAudioPlayer(contentsOf: url)
        self.musicPlayer.numberOfLoops=0
        self.musicPlayer.volume = bgmvolume
        self.musicPlayer.delegate = self
        state = .paused
    }
    
    fileprivate var starttime:Double = 0
    
    func startPlaying() {
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
            self.state = .playing
            self.starttime = CACurrentMediaTime()
            }]))
    }
    
    func getTime() -> TimeInterval{
        return CACurrentMediaTime() - starttime
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        state = .stopped
    }
    
    func pause() {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
        }
        state = .paused
    }
    
    func play() {
        if !musicPlayer.isPlaying {
            musicPlayer.play()
        }
        state = .playing
    }
    
    func stop() {
        musicPlayer.stop()
        state = .stopped
    }
    
    func isplaying() -> Bool{
        if musicPlayer==nil {
            return false
        }
        return musicPlayer.isPlaying
    }
    
}
