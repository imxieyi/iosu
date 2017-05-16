//
//  SBMoveX.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBMoveX:SBCommand,SBCAction {
    
    var startx:Double
    var endx:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startx:Double,endx:Double) {
        self.startx=StoryBoard.conv(x:startx)
        self.endx=StoryBoard.conv(x:endx)
        super.init(type: .MoveX, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.moveTo(x: CGFloat(endx), duration: 0)
        }
        return SKEase.moveX(easeFunction: easing.function, easeType: easing.type, time: duration, from: CGFloat(startx), to: CGFloat(endx))
        /*return SKAction.customAction(withDuration: duration, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
         let from=CGPoint(x: CGFloat(self.startx), y: node.position.y)
         let to=CGPoint(x: CGFloat(self.endx), y: node.position.y)
         node.run(SKEase.move(easeFunction: self.easing.function, easeType: self.easing.type, time: self.duration, from: from, to: to))
         })*/
    }
    
}
