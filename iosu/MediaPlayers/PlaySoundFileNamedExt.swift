//
//  PlaySoundFileNamedExt.swift
//  iosu
//
//  Created by 谢宜 on 2017/6/21.
//  Copyright © 2017年 xieyi. All rights reserved.
//
//  Reference: https://gist.github.com/ainoya/a2c1cd026ad5d695e406
import SpriteKit

public extension SKAction {
    public class func playSoundFileNamed(fileName: String, atVolume: Float, waitForCompletion: Bool) -> SKAction {
        
        do {
            let player: AVAudioPlayer = try AVAudioPlayer(data: BundleAudioBuffer.get(file: fileName)!)
            player.volume = atVolume
            player.prepareToPlay()
            let playAction = SKAction.run {
                player.play()
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
