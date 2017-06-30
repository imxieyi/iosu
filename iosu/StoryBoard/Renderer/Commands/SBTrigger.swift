//
//  SBTrigger.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBTrigger:SBCommand,SBCAction {
    
    //TODO: Trigger Command
    
    init(easing:Int,starttime:Int,endtime:Int) {
        super.init(type: .trigger, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKAction.group([])
    }
    
}
