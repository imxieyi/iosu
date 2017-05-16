//
//  SBFade.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBFade:SBCommand,SBCAction {
    
    var startopacity:Double
    var endopacity:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startopacity:Double,endopacity:Double) {
        self.startopacity=startopacity
        self.endopacity=endopacity
        super.init(type: .Fade, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime{
            //debugPrint("set alpha: \(endopacity)")
            return SKAction.fadeAlpha(to: CGFloat(endopacity), duration: 0)
        }
        if startopacity==endopacity {
            return SKAction.sequence([SKAction.fadeAlpha(to: CGFloat(endopacity), duration: 0),SKAction.wait(forDuration: duration)])
        }
        return SKEase.fade(easeFunction: easing.function, easeType: easing.type, time: duration, fromValue: CGFloat(startopacity), toValue: CGFloat(endopacity))
    }
    
}
