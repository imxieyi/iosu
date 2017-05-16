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
    case H //Flip image horizontally
    case V //Flip image vertically
    case A //Use additive-color blending instead of alpha-blending
    case N //Unknown type
}

class SBParam:SBCommand,SBCAction {
    
    var paramtype:SBParameterType
    
    init(easing:Int,starttime:Int,endtime:Int,ptype:String) {
        //debugPrint("typestr: \((ptype as NSString).substring(to: 1))")
        if ptype.contains("H"){
            self.paramtype = .H
        } else if ptype.contains("V"){
            self.paramtype = .V
        } else if ptype.contains("A"){
            self.paramtype = .A
        } else {
            self.paramtype = .N
        }
        super.init(type: .Parameter, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        //debugPrint("convert parameter to action, type \(self.paramtype)")
        switch paramtype {
        case .H:
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
        case .V:
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
        case .A:
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
        case .N:
            return SKAction.run {
            }
        }
    }
    
}
