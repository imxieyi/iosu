//
//  SBRotate.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBRotate:SBCommand,SBCAction {
    
    //Both in radians
    var startr:Double
    var endr:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startr:Double,endr:Double) {
        self.startr = -startr
        self.endr = -endr
        super.init(type: .Rotate, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.rotate(toAngle: CGFloat(endr), duration: 0)
        }
        return SKEase.rotate(easeFunction: easing.function, easeType: easing.type, time: duration, from: CGFloat(startr), to: CGFloat(endr))
    }
    
}
