//
//  SBMove.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBMove:SBCommand,SBCAction {
    
    var startx:Double
    var starty:Double
    var endx:Double
    var endy:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startx:Double,starty:Double,endx:Double,endy:Double) {
        self.startx=StoryBoard.conv(x: startx)
        self.starty=StoryBoard.conv(y: starty)
        self.endx=StoryBoard.conv(x: endx)
        self.endy=StoryBoard.conv(y: endy)
        super.init(type: .move, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        let from=CGPoint(x: startx, y: starty)
        let to=CGPoint(x: endx, y: endy)
        if starttime==endtime {
            return SKAction.move(to: to, duration: 0)
        }
        return SKEase.move(easeFunction: easing.function, easeType: easing.type, time: duration, from: from, to: to)
    }
    
}
