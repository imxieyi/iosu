//
//  SBMoveY.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBMoveY:SBCommand,SBCAction {
    
    var starty:Double
    var endy:Double
    
    init(easing:Int,starttime:Int,endtime:Int,starty:Double,endy:Double) {
        self.starty=StoryBoard.conv(y:starty)
        self.endy=StoryBoard.conv(y:endy)
        super.init(type: .moveY, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.moveTo(y: CGFloat(endy), duration: 0)
        }
        return SKEase.moveY(easeFunction: easing.function, easeType: easing.type, time: duration, from: CGFloat(starty), to: CGFloat(endy))
        /*return SKAction.customAction(withDuration: duration, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
         let from=CGPoint(x: node.position.x, y: CGFloat(self.starty))
         let to=CGPoint(x: node.position.x, y: CGFloat(self.endy))
         node.run(SKEase.move(easeFunction: self.easing.function, easeType: self.easing.type, time: self.duration, from: from, to: to))
         })*/
    }
    
}
