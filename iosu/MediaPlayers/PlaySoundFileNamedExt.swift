//
//  PlaySoundFileNamedExt.swift
//  iosu
//
//  Created by 谢宜 on 2017/6/21.
//  Copyright © 2017年 xieyi. All rights reserved.
//
//  Reference: https://gist.github.com/ainoya/a2c1cd026ad5d695e406
import SpriteKit
import AVFoundation

//In order to fix EXC_BAD_ADDRESS exception
class SoundNode:SKNode {
    
    fileprivate let player:AVAudioPlayer
    
    init(player: AVAudioPlayer) {
        self.player = player
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func play() {
        self.run(SKAction.sequence([SKAction.run{
            self.player.play()
        },SKAction.wait(forDuration: player.duration),SKAction.run {
            self.player.stop()
            self.isHidden = true
            }]))
    }
    
}

public extension SKAction {
    
    public class func playSoundFileNamed(_ fileName: String, atVolume: Float, waitForCompletion: Bool) -> SKAction {
        do {
            let player = try AVAudioPlayer(data: BundleAudioBuffer.get(fileName)!)
            let dummynode = SoundNode(player: player)
            GamePlayScene.current?.addChild(dummynode)
            player.volume = atVolume
            player.prepareToPlay()
            let playAction = SKAction.run {
                dummynode.play()
            }
            if(waitForCompletion){
                let waitAction = SKAction.wait(forDuration: player.duration)
                let groupAction: SKAction = SKAction.group([playAction, waitAction])
                return groupAction
            }
            return playAction
        } catch let error {
            debugPrint("\(fileName) caused: \(error.localizedDescription)")
        }
        return .run{}
    }
}
