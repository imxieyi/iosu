//
//  StoryBoardCommands.swift
//  iosu
//
//  Created by xieyi on 2017/4/2.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class SBCHelper {
    
    static func str2cmdtype(string:String) -> StoryBoardCommand {
        var str=string
        while str.hasPrefix(" ") || str.hasPrefix("_") {
            str=(str as NSString).substring(from: 1)
        }
        switch str {
        case "F":return StoryBoardCommand.Fade
        case "M":return StoryBoardCommand.Move
        case "MX":return StoryBoardCommand.MoveX
        case "MY":return StoryBoardCommand.MoveY
        case "S":return StoryBoardCommand.Scale
        case "V":return StoryBoardCommand.VScale
        case "R":return StoryBoardCommand.Rotate
        case "C":return StoryBoardCommand.Color
        case "P":return StoryBoardCommand.Parameter
        case "L":return StoryBoardCommand.Loop
        case "T":return StoryBoardCommand.Trigger
        default:return StoryBoardCommand.Unknown
        }
    }
    
    static func num2easing(num:Int) -> Easing {
        switch num {
        case 0:return Easing(function: .curveTypeLinear, type: .easeTypeIn)
        case 1:return Easing(function: .curveTypeSine, type: .easeTypeOut)
        case 2:return Easing(function: .curveTypeSine, type: .easeTypeIn)
        case 3:return Easing(function: .curveTypeQuadratic, type: .easeTypeIn)
        case 4:return Easing(function: .curveTypeQuadratic, type: .easeTypeOut)
        case 5:return Easing(function: .curveTypeQuadratic, type: .easeTypeInOut)
        case 6:return Easing(function: .curveTypeCubic, type: .easeTypeIn)
        case 7:return Easing(function: .curveTypeCubic, type: .easeTypeOut)
        case 8:return Easing(function: .curveTypeCubic, type: .easeTypeInOut)
        case 9:return Easing(function: .curveTypeQuartic, type: .easeTypeIn)
        case 10:return Easing(function: .curveTypeQuartic, type: .easeTypeOut)
        case 11:return Easing(function: .curveTypeQuartic, type: .easeTypeInOut)
        case 12:return Easing(function: .curveTypeQuintic, type: .easeTypeIn)
        case 13:return Easing(function: .curveTypeQuintic, type: .easeTypeOut)
        case 14:return Easing(function: .curveTypeQuintic, type: .easeTypeInOut)
        case 15:return Easing(function: .curveTypeSine, type: .easeTypeIn)
        case 16:return Easing(function: .curveTypeSine, type: .easeTypeOut)
        case 17:return Easing(function: .curveTypeSine, type: .easeTypeInOut)
        case 18:return Easing(function: .curveTypeExpo, type: .easeTypeIn)
        case 19:return Easing(function: .curveTypeExpo, type: .easeTypeOut)
        case 20:return Easing(function: .curveTypeExpo, type: .easeTypeInOut)
        case 21:return Easing(function: .curveTypeCircular, type: .easeTypeIn)
        case 22:return Easing(function: .curveTypeCircular, type: .easeTypeOut)
        case 23:return Easing(function: .curveTypeCircular, type: .easeTypeInOut)
        case 24:return Easing(function: .curveTypeElastic, type: .easeTypeIn)
        case 25:return Easing(function: .curveTypeElastic, type: .easeTypeOut)
        //ElasticHalf Out, function modified from plain elastic
        case 26:return Easing(function: .curveTypeElasticHalf, type: .easeTypeOut)
        //ElasticQuarter Out, function modified from plain elastic
        case 27:return Easing(function: .curveTypeElasticQuarter, type: .easeTypeOut)
        case 28:return Easing(function: .curveTypeElastic, type: .easeTypeInOut)
        case 29:return Easing(function: .curveTypeBack, type: .easeTypeIn)
        case 30:return Easing(function: .curveTypeBack, type: .easeTypeOut)
        case 31:return Easing(function: .curveTypeBack, type: .easeTypeInOut)
        case 32:return Easing(function: .curveTypeBounce, type: .easeTypeIn)
        case 33:return Easing(function: .curveTypeBounce, type: .easeTypeOut)
        case 34:return Easing(function: .curveTypeBounce, type: .easeTypeInOut)
        default:return Easing(function: .curveTypeLinear, type: .easeTypeIn)
        }
    }
    
}

class Easing {
    
    var function:CurveType
    var type:EaseType
    
    init(function:CurveType,type:EaseType) {
        self.function=function
        self.type=type
    }
    
}

protocol SBCAction {
    func toAction()->SKAction
}

class SBCommand {

    var type:StoryBoardCommand
    var easing:Easing
    var starttime:Int
    var endtime:Int
    var duration:Double
    var sprite:SKSpriteNode?
    
    init(type:StoryBoardCommand,easing:Int,starttime:Int,endtime:Int) {
        self.type=type
        self.easing=SBCHelper.num2easing(num: easing)
        self.starttime=starttime
        self.endtime=endtime
        duration=(Double(endtime)-Double(starttime))/1000
    }
    
}

class SBFade:SBCommand,SBCAction {
    
    var startopacity:Double
    var endopacity:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startopacity:Double,endopacity:Double) {
        self.startopacity=startopacity
        self.endopacity=endopacity
        super.init(type: .Fade, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKEase.fade(easeFunction: easing.function, easeType: easing.type, time: duration, fromValue: CGFloat(startopacity), toValue: CGFloat(endopacity))
    }
    
}

class SBMove:SBCommand,SBCAction {
    
    var startx:Double
    var starty:Double
    var endx:Double
    var endy:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startx:Double,starty:Double,endx:Double,endy:Double) {
        self.startx=StoryBoard.conv(x: startx)
        self.starty=StoryBoard.conv(y: starty)
        self.endx=StoryBoard.conv(x: endx)
        self.endy=StoryBoard.conv(y: endy)
        super.init(type: .Move, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        let from=CGPoint(x: startx, y: starty)
        let to=CGPoint(x: endx, y: endy)
        return SKEase.move(easeFunction: easing.function, easeType: easing.type, time: duration, from: from, to: to)
    }
    
}

class SBMoveX:SBCommand,SBCAction {
    
    var startx:Double
    var endx:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startx:Double,endx:Double) {
        self.startx=startx
        self.endx=endx
        super.init(type: .MoveX, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKAction.customAction(withDuration: duration, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let from=CGPoint(x: CGFloat(self.startx), y: node.position.y)
            let to=CGPoint(x: CGFloat(self.endx), y: node.position.y)
            node.run(SKEase.move(easeFunction: self.easing.function, easeType: self.easing.type, time: self.duration, from: from, to: to))
        })
    }
    
}

class SBMoveY:SBCommand,SBCAction {
    
    var starty:Double
    var endy:Double
    
    init(easing:Int,starttime:Int,endtime:Int,starty:Double,endy:Double) {
        self.starty=starty
        self.endy=endy
        super.init(type: .MoveY, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKAction.customAction(withDuration: duration, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let from=CGPoint(x: node.position.x, y: CGFloat(self.starty))
            let to=CGPoint(x: node.position.x, y: CGFloat(self.endy))
            node.run(SKEase.move(easeFunction: self.easing.function, easeType: self.easing.type, time: self.duration, from: from, to: to))
        })
    }
    
}

class SBScale:SBCommand,SBCAction {
    
    var starts:Double
    var ends:Double
    
    init(easing:Int,starttime:Int,endtime:Int,starts:Double,ends:Double) {
        self.starts=starts
        self.ends=ends
        super.init(type: .Scale, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKEase.scale(easeFunction: easing.function, easeType: easing.type, time: duration, from: CGFloat(starts), to: CGFloat(ends))
    }
    
}

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
        return SKEase.vscale(easeFunction: easing.function, easeType: easing.type, time: duration, xfrom: CGFloat(startsx), yfrom: CGFloat(startsy), xto: CGFloat(endsx), yto: CGFloat(endsy))
    }
    
}

class SBRotate:SBCommand,SBCAction {
    
    //Both in radians
    var startr:Double
    var endr:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startr:Double,endr:Double) {
        self.startr=startr
        self.endr=endr
        super.init(type: .Rotate, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKEase.rotate(easeFunction: easing.function, easeType: easing.type, time: duration, from: CGFloat(startr), to: CGFloat(endr))
    }
    
}

class SBColor:SBCommand,SBCAction {
    
    var startr:Double
    var startg:Double
    var startb:Double
    var endr:Double
    var endg:Double
    var endb:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startr:Double,startg:Double,startb:Double,endr:Double,endg:Double,endb:Double) {
        self.startr=startr
        self.startg=startg
        self.startb=startb
        self.endr=endr
        self.endg=endg
        self.endb=endb
        super.init(type: .Color, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKEase.color(easeFunction: easing.function, easeType: easing.type, time: duration, rfrom: CGFloat(startr), gfrom: CGFloat(startg), bfrom: CGFloat(startb), rto: CGFloat(endr), gto: CGFloat(endg), bto: CGFloat(endb))
    }
    
}

enum SBParameterType {
    case H //Flip image horizontally
    case V //Flip image vertically
    case A //Use additive-color blending instead of alpha-blending
    case N //Unknown type
}

class SBParam:SBCommand,SBCAction {
    
    var paramtype:SBParameterType
    
    init(easing:Int,starttime:Int,endtime:Int,ptype:String) {
        switch ptype {
        case "H":
            self.paramtype = .H
            break
        case "V":
            self.paramtype = .V
            break
        case "A":
            self.paramtype = .A
            break
        default:
            self.paramtype = .N
            break
        }
        super.init(type: .Parameter, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        switch paramtype {
        case .H:
            return SKEase.vscale(easeFunction: easing.function, easeType: easing.type, time: duration, xfrom: (sprite?.xScale)!, yfrom: (sprite?.yScale)!, xto: -(sprite?.xScale)!, yto: (sprite?.yScale)!)
        case .V:
            return SKEase.vscale(easeFunction: easing.function, easeType: easing.type, time: duration, xfrom: (sprite?.xScale)!, yfrom: (sprite?.yScale)!, xto: (sprite?.xScale)!, yto: -(sprite?.yScale)!)
        case .A:
            return SKAction.customAction(withDuration: duration, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
                if elapsedTime < CGFloat(self.duration) {
                    (node as! SKSpriteNode).blendMode = .add
                } else {
                    (node as! SKSpriteNode).blendMode = .alpha
                }
            })
        default:
            return SKAction.group([])
        }
    }
    
}

//Compound Commands
//https://osu.ppy.sh/wiki/Storyboard_Triggers
class SBLoop:SBCommand,SBCAction {
    
    var loopcount:Int
    var commands:[SKAction]=[]
    
    init(easing:Int,starttime:Int,endtime:Int,loopcount:Int) {
        self.loopcount=loopcount
        super.init(type: .Loop, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKAction.repeat(SKAction.group(commands), count: loopcount)
    }
    
}

class SBTrigger:SBCommand,SBCAction {
    
    //TODO: Trigger Command
    
    init(easing:Int,starttime:Int,endtime:Int) {
        super.init(type: .Trigger, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKAction.group([])
    }
    
}
