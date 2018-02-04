//
//  BasicImage.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class BasicImage {
    
    var layer:SBLayer
    var rlayer:Double
    var origin:SBOrigin
    var filepath:String
    var commands:[SBCommand]=[]
    var starttime=0
    var endtime=0
    var sprite:FlipNode?
    var actions:SKAction?
    //Initial value
    var x:Double
    var y:Double
    var alpha:Double = 1
    var r:Double = 1
    var g:Double = 1
    var b:Double = 1
    var xscale:Double = 1
    var yscale:Double = 1
    var angle:Double = 0
    var isanimation=false
    
    init(layer:SBLayer,rlayer:Double,origin:SBOrigin,filepath:String,x:Double,y:Double) {
        self.layer=layer
        self.rlayer=rlayer
        self.origin=origin
        self.filepath=filepath
        while self.filepath.hasPrefix("\"") {
            self.filepath=(self.filepath as NSString).substring(from: 1)
        }
        while self.filepath.hasSuffix("\"") {
            self.filepath=(self.filepath as NSString).substring(to: self.filepath.lengthOfBytes(using: .ascii)-1)
        }
        self.x=StoryBoard.conv(x: x)
        self.y=StoryBoard.conv(y: y)
    }
    
    init(layer:SBLayer,rlayer:Double,origin:SBOrigin,filepath:String,x:Double,y:Double,isanimation:Bool) {
        self.layer=layer
        self.rlayer=rlayer
        self.origin=origin
        self.filepath=filepath
        while self.filepath.hasPrefix("\"") {
            self.filepath=(self.filepath as NSString).substring(from: 1)
        }
        while self.filepath.hasSuffix("\"") {
            self.filepath=(self.filepath as NSString).substring(to: self.filepath.lengthOfBytes(using: .ascii)-1)
        }
        self.x=StoryBoard.conv(x: x)
        self.y=StoryBoard.conv(y: y)
        self.isanimation=isanimation
    }
    
    func gentime() {
        starttime=Int.max
        endtime=Int.min
        for cmd in commands {
            if starttime>cmd.starttime {
                starttime=cmd.starttime
            }
            if endtime<cmd.endtime {
                endtime=cmd.endtime
            }
        }
    }
    
    func geninitials(){
        var FirstMove=SBMove(easing: 0, starttime: .max, endtime: .max, startx: 0, starty: 0, endx: 0, endy: 0)
        var FirstMoveX=SBMoveX(easing: 0, starttime: .max, endtime: .max, startx: 0, endx: 0)
        var FirstMoveY=SBMoveY(easing: 0, starttime: .max, endtime: .max, starty: 0, endy: 0)
        var FirstScale=SBScale(easing: 0, starttime: .max, endtime: .max, starts: 0, ends: 0)
        var FirstVScale=SBVScale(easing: 0, starttime: .max, endtime: .max, startsx: 0, startsy: 0, endsx: 0, endsy: 0)
        var FirstColor=SBColor(easing: 0, starttime: .max, endtime: .max, startr: 0, startg: 0, startb: 0, endr: 0, endg: 0, endb: 0)
        var FirstFade=SBFade(easing: 0, starttime: .max, endtime: .max, startopacity: 0, endopacity: 0)
        var FirstRotate=SBRotate(easing: 0, starttime: .max, endtime: .max, startr: 0, endr: 0)
        for cmd in commands {
            switch cmd.type {
            case .move:
                if FirstMove.starttime>cmd.starttime {
                    FirstMove=cmd as! SBMove
                }
                break
            case .moveX:
                if FirstMoveX.starttime>cmd.starttime {
                    FirstMoveX=cmd as! SBMoveX
                }
                break
            case .moveY:
                if FirstMoveY.starttime>cmd.starttime {
                    FirstMoveY=cmd as! SBMoveY
                }
                break
            case .scale:
                if FirstScale.starttime>cmd.starttime {
                    FirstScale=cmd as! SBScale
                }
                break
            case .vScale:
                if FirstVScale.starttime>cmd.starttime {
                    FirstVScale=cmd as! SBVScale
                }
                break
            case .color:
                if FirstColor.starttime>cmd.starttime {
                    FirstColor=cmd as! SBColor
                }
                break
            case .fade:
                if FirstFade.starttime>cmd.starttime {
                    FirstFade=cmd as! SBFade
                }
                break
            case .rotate:
                if FirstRotate.starttime>cmd.starttime {
                    FirstRotate=cmd as! SBRotate
                }
                break
            default:
                continue
            }
        }
        //Generate initial values
        if FirstMove.starttime != .max {
            if FirstMove.starttime<FirstMoveX.starttime {
                x=FirstMove.startx
            } else {
                x=FirstMoveX.startx
            }
        } else {
            if FirstMoveX.starttime != .max {
                x=FirstMoveX.startx
            }
        }
        if FirstMove.starttime != .max {
            if FirstMove.starttime<FirstMoveY.starttime {
                y=FirstMove.starty
            } else {
                y=FirstMoveY.starty
            }
        } else {
            if FirstMoveY.starttime != .max {
                y=FirstMoveY.starty
            }
        }
        if FirstScale.starttime != .max {
            if FirstScale.starttime<FirstVScale.starttime {
                xscale=FirstScale.starts
                yscale=FirstScale.starts
            } else {
                xscale=FirstVScale.startsx
                yscale=FirstVScale.startsy
            }
        } else {
            if FirstVScale.starttime != .max {
                xscale=FirstVScale.startsx
                yscale=FirstVScale.startsy
            }
        }
        if FirstColor.starttime != .max {
            r=FirstColor.startr
            g=FirstColor.startg
            b=FirstColor.startb
        }
        if FirstFade.starttime != .max {
            alpha=FirstFade.startopacity
        }
        if FirstRotate.starttime != .max {
            angle=FirstRotate.startr
        }
    }
    
    func convertsprite(){
        sprite=FlipNode(texture: ImageBuffer.get(filepath))
        if sprite==nil {
            return
        }
        var size=sprite?.size
        size?.width*=CGFloat(StoryBoard.actualwidth/StoryBoard.stdwidth)
        size?.height*=CGFloat(StoryBoard.actualheight/StoryBoard.stdheight)
        sprite?.size=size!
        sprite?.zPosition=CGFloat(rlayer)
        sprite?.position=CGPoint(x: x, y: y)
        sprite?.blendMode = .alpha
        sprite?.color = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
        sprite?.colorBlendFactor=1.0
        sprite?.alpha=0
        sprite?.xScale=CGFloat(xscale)
        sprite?.yScale=CGFloat(yscale)
        sprite?.zRotation=CGFloat(angle)
        switch origin {
        case .topLeft:
            sprite?.anchorPoint=CGPoint(x: 0, y: 1)
            break
        case .topCentre:
            sprite?.anchorPoint=CGPoint(x: 0.5, y: 1)
            break
        case .topRight:
            sprite?.anchorPoint=CGPoint(x: 1, y: 1)
            break
        case .centreLeft:
            sprite?.anchorPoint=CGPoint(x: 0, y: 0.5)
            break
        case .centre:
            sprite?.anchorPoint=CGPoint(x: 0.5, y: 0.5)
            break
        case .centreRight:
            sprite?.anchorPoint=CGPoint(x: 1, y: 0.5)
            break
        case .bottomLeft:
            sprite?.anchorPoint=CGPoint(x: 0, y: 0)
            break
        case .bottomCentre:
            sprite?.anchorPoint=CGPoint(x: 0.5, y: 0)
            break
        case .bottomRight:
            sprite?.anchorPoint=CGPoint(x: 1, y: 0)
            break
        }
    }
    
    func schedule(){
        commands.sort(by: {(c1,c2)->Bool in
            return c1.starttime<c2.starttime
        })
        var temp:[[SKAction]]=[]
        var endtime:[Int]=[]
        for cmd in commands {
            var flag=false
            if endtime.count>0 {
                for i in 0...endtime.count-1 {
                    if cmd.starttime == endtime[i] {
                        flag=true
                        temp[i].append((cmd as! SBCAction).toAction())
                        endtime[i]=cmd.endtime
                        break
                    } else if cmd.starttime > endtime[i] {
                        flag=true
                        temp[i].append(SKAction.wait(forDuration: Double(cmd.starttime-endtime[i])/1000))
                        temp[i].append((cmd as! SBCAction).toAction())
                        endtime[i]=cmd.endtime
                        break
                    }
                }
            }
            if !flag {
                if cmd.starttime == self.starttime {
                    temp.append([(cmd as! SBCAction).toAction()])
                } else {
                    temp.append([SKAction.wait(forDuration: Double(cmd.starttime-self.starttime)/1000),(cmd as! SBCAction).toAction()])
                }
                endtime.append(cmd.endtime)
            }
        }
        StoryBoard.before+=commands.count
        StoryBoard.after+=temp.count
        //debugPrint("before:\(commands.count) after:\(temp.count)")
        var actions:[SKAction]=[]
        actions.append(SKAction.customAction(withDuration: 0, actionBlock: {(node:SKNode,time:CGFloat) -> Void in
            node.alpha=CGFloat(self.alpha)
        }))
        for group in temp {
            actions.append(SKAction.sequence(group))
        }
        self.actions=SKAction.group(actions)
        self.commands=[]
    }
    
    func runaction(_ offset:Int){
        if sprite==nil {
            return
        }
        //var acts:[SKAction]=[SKAction.wait(forDuration: Double(offset)/1000)]
        //sprite?.run(SKAction.sequence([SKAction.sequence(acts),self.actions!]),completion:{ ()->Void in
        if self.actions != nil {
            sprite?.run(SKAction.sequence([SKAction.wait(forDuration: Double(offset)/1000),self.actions!]),completion:{ ()->Void in
                //debugPrint("destroy sprite")
                self.sprite?.removeAllActions()
                self.sprite?.isHidden = true
//                self.sprite?.removeFromParent()
//                self.sprite=nil
//                self.commands=[]
//                self.actions=nil
            })
        }
    }
    
}
