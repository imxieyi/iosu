//
//  SBColor.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBColor:SBCommand,SBCAction {
    
    var startr:Double
    var startg:Double
    var startb:Double
    var endr:Double
    var endg:Double
    var endb:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startr:Double,startg:Double,startb:Double,endr:Double,endg:Double,endb:Double) {
        self.startr=startr/255
        self.startg=startg/255
        self.startb=startb/255
        self.endr=endr/255
        self.endg=endg/255
        self.endb=endb/255
        super.init(type: .Color, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.colorize(with: UIColor(red: CGFloat(endr), green: CGFloat(endg), blue: CGFloat(endb), alpha: 1), colorBlendFactor: 1, duration: 0)
        }
        return SKEase.color(easeFunction: easing.function, easeType: easing.type, time: duration, rfrom: CGFloat(startr), gfrom: CGFloat(startg), bfrom: CGFloat(startb), rto: CGFloat(endr), gto: CGFloat(endg), bto: CGFloat(endb))
    }
    
}
