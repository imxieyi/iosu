//
//  SBParam.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

enum SBParameterType {
    case h //Flip image horizontally
    case v //Flip image vertically
    case a //Use additive-color blending instead of alpha-blending
    case n //Unknown type
}

class SBParam:SBCommand,SBCAction {
    
    var paramtype:SBParameterType
    
    init(easing:Int,starttime:Int,endtime:Int,ptype:String) {
        //debugPrint("typestr: \((ptype as NSString).substring(to: 1))")
        if ptype.contains("H"){
            self.paramtype = .h
        } else if ptype.contains("V"){
            self.paramtype = .v
        } else if ptype.contains("A"){
            self.paramtype = .a
        } else {
            self.paramtype = .n
        }
        super.init(type: .parameter, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        //debugPrint("convert parameter to action, type \(self.paramtype)")
        switch paramtype {
        case .h:
            let flip={(node:SKNode,time:CGFloat)->Void in
                (node as! FlipNode).hflip=true
            }
            if starttime==endtime {
                return SKAction.customAction(withDuration: 0, actionBlock: flip)
            }
            let restore={(node:SKNode,time:CGFloat)->Void in
                (node as! FlipNode).hflip=false
            }
            return SKAction.sequence([SKAction.customAction(withDuration: 0, actionBlock: flip),SKAction.wait(forDuration: duration),SKAction.customAction(withDuration: 0, actionBlock: restore)])
        case .v:
            let flip={(node:SKNode,time:CGFloat)->Void in
                (node as! FlipNode).vflip=true
            }
            if starttime==endtime {
                return SKAction.customAction(withDuration: 0, actionBlock: flip)
            }
            let restore={(node:SKNode,time:CGFloat)->Void in
                (node as! FlipNode).vflip=false
            }
            return SKAction.sequence([SKAction.customAction(withDuration: 0, actionBlock: flip),SKAction.wait(forDuration: duration),SKAction.customAction(withDuration: 0, actionBlock: restore)])
        case .a:
            let set={(node:SKNode,time:CGFloat)->Void in
                (node as! SKSpriteNode).blendMode = .add
            }
            if(starttime==endtime){
                return SKAction.customAction(withDuration: 0, actionBlock: set)
            }
            let restore={(node:SKNode,time:CGFloat)->Void in
                (node as! SKSpriteNode).blendMode = .alpha
            }
            return SKAction.sequence([SKAction.customAction(withDuration: 0, actionBlock: set),SKAction.wait(forDuration: duration),SKAction.customAction(withDuration: 0, actionBlock: restore)])
        case .n:
            return SKAction.run {
            }
        }
    }
    
}
