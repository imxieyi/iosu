//
//  SBScale.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBScale:SBCommand,SBCAction {
    
    var starts:Double
    var ends:Double
    
    init(easing:Int,starttime:Int,endtime:Int,starts:Double,ends:Double) {
        self.starts=starts
        self.ends=ends
        super.init(type: .Scale, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.scale(to: CGFloat(ends), duration: 0)
        }
        return SKEase.scale(easeFunction: easing.function, easeType: easing.type, time: duration, from: CGFloat(starts), to: CGFloat(ends))
    }
    
}
