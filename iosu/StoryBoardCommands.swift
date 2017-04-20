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
    //var sprite:SKSpriteNode?
    
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
        if starttime==endtime {
            //debugPrint("set alpha: \(endopacity)")
            return SKAction.fadeAlpha(to: CGFloat(endopacity), duration: 0)
        }
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
        if starttime==endtime {
            return SKAction.move(to: to, duration: 0)
        }
        return SKEase.move(easeFunction: easing.function, easeType: easing.type, time: duration, from: from, to: to)
    }
    
}

class SBMoveX:SBCommand,SBCAction {
    
    var startx:Double
    var endx:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startx:Double,endx:Double) {
        self.startx=StoryBoard.conv(x:startx)
        self.endx=StoryBoard.conv(x:endx)
        super.init(type: .MoveX, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.moveTo(x: CGFloat(endx), duration: 0)
        }
        return SKEase.moveX(easeFunction: easing.function, easeType: easing.type, time: duration, from: CGFloat(startx), to: CGFloat(endx))
        /*return SKAction.customAction(withDuration: duration, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let from=CGPoint(x: CGFloat(self.startx), y: node.position.y)
            let to=CGPoint(x: CGFloat(self.endx), y: node.position.y)
            node.run(SKEase.move(easeFunction: self.easing.function, easeType: self.easing.type, time: self.duration, from: from, to: to))
        })*/
    }
    
}

class SBMoveY:SBCommand,SBCAction {
    
    var starty:Double
    var endy:Double
    
    init(easing:Int,starttime:Int,endtime:Int,starty:Double,endy:Double) {
        self.starty=StoryBoard.conv(y:starty)
        self.endy=StoryBoard.conv(y:endy)
        super.init(type: .MoveY, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.moveTo(y: CGFloat(endy), duration: 0)
        }
        return SKEase.moveY(easeFunction: easing.function, easeType: easing.type, time: duration, from: CGFloat(starty), to: CGFloat(endy))
        /*return SKAction.customAction(withDuration: duration, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let from=CGPoint(x: node.position.x, y: CGFloat(self.starty))
            let to=CGPoint(x: node.position.x, y: CGFloat(self.endy))
            node.run(SKEase.move(easeFunction: self.easing.function, easeType: self.easing.type, time: self.duration, from: from, to: to))
        })*/
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
        if starttime==endtime {
            return SKAction.scale(to: CGFloat(ends), duration: 0)
        }
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
        if starttime==endtime {
            return SKAction.group([SKAction.scaleX(to: CGFloat(endsx), duration: 0),SKAction.scaleY(to: CGFloat(endsy), duration: 0)])
        }
        return SKEase.vscale(easeFunction: easing.function, easeType: easing.type, time: duration, xfrom: CGFloat(startsx), yfrom: CGFloat(startsy), xto: CGFloat(endsx), yto: CGFloat(endsy))
    }
    
}

class SBRotate:SBCommand,SBCAction {
    
    //Both in radians
    var startr:Double
    var endr:Double
    
    init(easing:Int,starttime:Int,endtime:Int,startr:Double,endr:Double) {
        self.startr = -startr
        self.endr = -endr
        super.init(type: .Rotate, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        if starttime==endtime {
            return SKAction.rotate(toAngle: CGFloat(endr), duration: 0)
        }
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
        var duration=0
        for cmd in commands {
            duration+=cmd.endtime-cmd.starttime
        }
        endtime=starttime+duration*loopcount
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

class SBTrigger:SBCommand,SBCAction {
    
    //TODO: Trigger Command
    
    init(easing:Int,starttime:Int,endtime:Int) {
        super.init(type: .Trigger, easing: easing, starttime: starttime, endtime: endtime)
    }
    
    func toAction() -> SKAction {
        return SKAction.group([])
    }
    
}
