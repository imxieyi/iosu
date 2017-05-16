//
//  SBLoop.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

//Compound Commands
//https://osu.ppy.sh/wiki/Storyboard_Triggers
class SBLoop:SBCommand,SBCAction {
    
    var loopcount:Int
    var commands:[SBCommand]=[]
    
    init(starttime:Int,loopcount:Int) {
        self.loopcount=loopcount
        super.init(type: .Loop, easing: 0, starttime: starttime, endtime: 0)
    }
    
    func genendtime() {
        var latest:Int = .min
        for cmd in commands {
            if(latest<cmd.endtime) {
                latest=cmd.endtime
            }
        }
        if(latest != .min) {
            endtime=starttime+latest*loopcount
        } else {
            endtime=starttime
        }
        self.duration=Double(endtime-starttime)/1000
        return
    }
    
    func toAction() -> SKAction {
        //return SKAction.repeat(SKAction.group(commands), count: loopcount)
        var loopactions:[SKAction]=[]
        for cmd in commands {
            //cmd.sprite=self.sprite
            loopactions.append(SKAction.sequence([SKAction.wait(forDuration: Double(cmd.starttime)/1000),(cmd as! SBCAction).toAction()]))
        }
        return SKAction.repeat(SKAction.group(loopactions), count: self.loopcount)
    }
    
}
