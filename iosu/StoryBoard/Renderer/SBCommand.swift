//
//  SBCommand.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

protocol SBCAction {
    func toAction()->SKAction
}

class SBCommand {
    
    var type:StoryBoardCommand
    var easing:Easing
    var starttime:Int
    var endtime:Int
    var duration:Double
    //var sprite:SKSpriteNode?
    
    init(type:StoryBoardCommand,easing:Int,starttime:Int,endtime:Int) {
        self.type=type
        self.easing=SBCHelper.num2easing(easing)
        self.starttime=starttime
        self.endtime=endtime
        duration=(Double(endtime)-Double(starttime))/1000
    }
    
}
