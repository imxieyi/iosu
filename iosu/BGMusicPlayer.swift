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

class BGMusicPlayer{
    
    var musicPlayer: AVAudioPlayer!
    
    func play(file:String) -> SKAction {
        return SKAction.run({() -> Void in
            let url=URL(fileURLWithPath: file)
            self.musicPlayer = try! AVAudioPlayer(contentsOf: url)
            /*if musicPlayer == nil {
             throw BeatmapError.AudioFileNotExist
             }*/
            self.musicPlayer.numberOfLoops=0
            self.musicPlayer.prepareToPlay()
            self.musicPlayer.play()
        })
    }
    
    func getTime() -> TimeInterval{
        if musicPlayer == nil{
            return -1
        }
        return musicPlayer.currentTime
    }
    
    func isplaying() -> Bool{
        if musicPlayer==nil {
            return false
        }
        return musicPlayer.isPlaying
    }
    
}
