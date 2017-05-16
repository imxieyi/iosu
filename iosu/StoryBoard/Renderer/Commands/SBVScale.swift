//
//  SBVScale.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBVScale:SBCommand,SBCAction {
    
    var startsx:Double
    var startsy:Double
    var endsx:Double
    var endsy:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startsx:Double,startsy:Double,endsx:Double,endsy:Double) {
        self.startsx=startsx
        self.startsy=startsy
        self.endsx=endsx
        self.endsy=endsy
        super.init(type: .VScale, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.group([SKAction.scaleX(to: CGFloat(endsx), duration: 0),SKAction.scaleY(to: CGFloat(endsy), duration: 0)])
        }
        return SKEase.vscale(easeFunction: easing.function, easeType: easing.type, time: duration, xfrom: CGFloat(startsx), yfrom: CGFloat(startsy), xto: CGFloat(endsx), yto: CGFloat(endsy))
    }
    
}
