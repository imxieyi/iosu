//
//  SliderAction.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class SliderAction:HitObjectAction {
    
    fileprivate let time:Double
    fileprivate let obj:Slider
    fileprivate var color:UIColor = UIColor()
    fileprivate var layer:CGFloat = 0
    fileprivate var edge:CGFloat = 0
    open var endx:CGFloat
    open var endy:CGFloat
    //Calc Length
    fileprivate var timing:TimingPoint
    fileprivate var singleduration:Double = 0
    open var fulltime:Double = 0
    //Status
    open var stats:[SliderStatus] = []
    open var stattimes:[Double] = []
    open var pointer = 0
    open var failcount = 0
    //For tick points
    fileprivate var scene:SKScene?
    fileprivate var runcount = 0
    fileprivate var newrun = false
    fileprivate var tickcount = 0
    fileprivate var ticktimeindex = 0
    fileprivate var runstarttime:Double = 0
    //Head
    var headinner : SKSpriteNode? = nil
    var headoverlay : SKSpriteNode? = nil
    var headnumber:[SKSpriteNode] = []
    var appcircle : SKSpriteNode? = nil
    //Arrows
    var arrowinners:[SKSpriteNode] = []
    var arrowoverlays:[SKSpriteNode] = []
    var arrowarrows:[SKSpriteNode] = []
    //End
    var endinner : SKSpriteNode? = nil
    var endoverlay : SKSpriteNode? = nil
    //Body
    var inbody : SKShapeNode? = nil
    var outbody : SKShapeNode? = nil
    //Tick points
    fileprivate var tickpoints:[[SKSpriteNode]] = []
    fileprivate var ticktimes:[Double] = []
    //Dummy
    var dummynode : SKNode? = nil
    var guardnode : SKNode? = nil
    
    init(obj:Slider,timing:TimingPoint) {
        self.time = Double(obj.time)
        self.obj = obj
        self.timing = timing
        if obj.repe % 2 == 1 {
            endx = CGFloat(obj.cx.last!)
            endy = CGFloat(obj.cy.last!)
        } else {
            endx = CGFloat(obj.x)
            endy = CGFloat(obj.y)
        }
    }
    
    //Return true if the color passed is bright
    func isbright(_ color:UIColor) -> Bool {
        let cicolor = CIColor(color: color)
        return cicolor.red+cicolor.green+cicolor.blue > 1.5
    }
    
    func prepare(_ color:UIColor,number:Int,layer:CGFloat) {
        self.color = color
        //Calculate time
        let pxPerBeat = 100 * (ActionSet.difficulty?.SliderMultiplier)!
        let beatsNumber = Double(obj.length) / pxPerBeat
        singleduration = ceil(beatsNumber * timing.timeperbeat)
        fulltime = singleduration * Double(obj.repe)
        var currenttime = Double(obj.time)
        //Draw
        self.color = color
        self.layer = layer
        self.edge = CGFloat((ActionSet.difficulty?.AbsoluteCS)!)
        let size = CGSize(width: edge, height: edge)
        let position1 = CGPoint(x: obj.x, y: obj.y)
        let position2 = CGPoint(x: obj.cx.last!, y: obj.cy.last!)
        var selflayer = layer + 1
        //Calculate angle for arrows
        let position3 = obj.path.point(atPercentOfLength: 0.00) //At head
        let position4 = obj.path.point(atPercentOfLength: 1.00) //At end
        let position5 = obj.path.point(atPercentOfLength: 0.01) //Near head
        let position6 = obj.path.point(atPercentOfLength: 0.99) //Near end
        var angle1 = atan((position3.y-position5.y)/(position3.x-position5.x))
        if position3.x == position5.x {
            if position5.y > position3.y {
                angle1 = CGFloat.pi / 2
            } else {
                angle1 = -CGFloat.pi / 2
            }
        }
        if position3.x > position5.x {
            angle1 = CGFloat.pi + angle1
        }
        var angle2 = atan((position4.y-position6.y)/(position4.x-position6.x))
        if position4.x == position6.x {
            if position6.y > position4.y {
                angle2 = CGFloat.pi / 2
            } else {
                angle2 = -CGFloat.pi / 2
            }
        }
        if position4.x > position6.x {
            angle2 = CGFloat.pi + angle2
        }
        //Head --- Overlay
        selflayer -= 0.01
        headoverlay = SKSpriteNode(texture: SkinBuffer.get("hitcircleoverlay"))
        headoverlay?.size = size
        headoverlay?.position = position1
        headoverlay?.zPosition = selflayer
        //Head --- Number
        selflayer -= 0.01
        let lo = number % 10
        let lonode = CircleAction.num2node(lo)
        lonode.position = position1
        lonode.zPosition = selflayer
        headnumber.append(lonode)
        if number >= 10 {
            lonode.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            let hi = (number % 100) / 10
            let hinode = CircleAction.num2node(hi)
            hinode.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            hinode.position = position1
            hinode.zPosition = selflayer
            headnumber.append(hinode)
        }
        //Head --- Inner
        selflayer -= 0.01
        headinner = SKSpriteNode(texture: SkinBuffer.get("hitcircle"))
        headinner?.color = color
        headinner?.blendMode = .alpha
        headinner?.colorBlendFactor = 1
        headinner?.size = size
        headinner?.position = position1
        headinner?.zPosition = selflayer
        //Update status
        stats.append(.head)
        stattimes.append(currenttime)
        //Head --- Approach Circle
        appcircle = SKSpriteNode(texture: SkinBuffer.get("approachcircle"))
        appcircle?.size = size
        appcircle?.setScale(3)
        appcircle?.alpha = 0
        appcircle?.position = position1
        appcircle?.zPosition = 100001
        
        //Arrows
        var repe = obj.repe
        var athead = false
        while repe > 1 {
            repe -= 1
            //Overlay
            selflayer -= 0.01
            let overlay = SKSpriteNode(texture: SkinBuffer.get("hitcircleoverlay"))
            overlay.size = size
            overlay.zPosition = selflayer
            arrowoverlays.append(overlay)
            //Arrow
            selflayer -= 0.01
            let arrow = SKSpriteNode(texture: SkinBuffer.get("reversearrow"))
            arrow.size = size
            arrow.zPosition = selflayer
            if SkinBuffer.getFlag("reversearrow") {
                arrow.colorBlendFactor = 0
            } else {
                arrow.colorBlendFactor = 1
            }
            arrow.blendMode = .alpha
            if(isbright(color)){
                arrow.color = .black
            } else {
                arrow.color = .white
            }
            arrowarrows.append(arrow)
            //Inner
            selflayer -= 0.01
            let inner = SKSpriteNode(texture: SkinBuffer.get("hitcircle"))
            inner.color = color
            inner.blendMode = .alpha
            inner.colorBlendFactor = 1
            inner.size = size
            inner.zPosition = selflayer
            arrowinners.append(inner)
            if athead {
                overlay.position = position1
                arrow.position = position1
                arrow.zRotation = angle1
                inner.position = position1
                athead = false
            } else {
                overlay.position = position2
                arrow.position = position2
                arrow.zRotation = angle2
                inner.position = position2
                athead = true
            }
            //Update status
            currenttime += singleduration
            stats.append(.arrow)
            stattimes.append(currenttime)
        }
        //End --- Overlay
        selflayer -= 0.01
        endoverlay = SKSpriteNode(texture: SkinBuffer.get("hitcircleoverlay"))
        endoverlay?.size = size
        endoverlay?.zPosition = selflayer
        //End --- Inner
        selflayer -= 0.01
        endinner = SKSpriteNode(texture: SkinBuffer.get("hitcircle"))
        endinner?.color = color
        endinner?.blendMode = .alpha
        endinner?.colorBlendFactor = 1
        endinner?.size = size
        endinner?.zPosition = selflayer
        if athead {
            endoverlay?.position = position1
            endinner?.position = position1
        } else {
            endoverlay?.position = position2
            endinner?.position = position2
        }
        //Body --- In
        let outwidth = edge * 120 / 128
        inbody = SKShapeNode(path: obj.path.cgPath)
        inbody?.lineCap = .round
        inbody?.lineJoin = .round
        inbody?.fillColor = .clear
        inbody?.isAntialiased = true
        if obj.trackoverride && SkinBuffer.useSkin {
            inbody?.strokeColor = obj.trackcolor
        } else {
            inbody?.strokeColor = color
        }
        inbody?.lineWidth = outwidth * 7 / 8
        inbody?.position = .zero
        inbody?.alpha = 0.8
        inbody?.zPosition = layer + 0.01
        //Body --- Out
        outbody = SKShapeNode(path: obj.path.cgPath)
        outbody?.lineCap = .round
        outbody?.lineJoin = .round
        outbody?.fillColor = .clear
        outbody?.strokeColor = color
        outbody?.isAntialiased = true
        if SkinBuffer.useSkin {
            outbody?.strokeColor = obj.bordercolor
        } else {
            outbody?.strokeColor = UIColor.white
        }
        outbody?.lineWidth = outwidth
        outbody?.position = .zero
        outbody?.alpha = 0.8
        outbody?.zPosition = layer
        //Update status
        currenttime += singleduration
        stats.append(.end)
        stattimes.append(currenttime)
        //Tick points
        let tickinterval = timing.timeperbeat/(ActionSet.difficulty?.SliderTickRate)!
        var time = Double(obj.time)
        repe = obj.repe
        var toend = true
        while repe >= 1 {
            repe -= 1
            tickpoints.append([])
            var ctime = time + tickinterval
            while ctime < time + singleduration - tickinterval/10 {
                let ticksprite = SKSpriteNode(texture: SkinBuffer.get("sliderscorepoint"))
                ticksprite.setScale(CGFloat((ActionSet.difficulty?.AbsoluteCS)! / 96))
                ticksprite.zPosition = layer + 0.02
                var point:CGPoint
                if toend {
                    //From UIBezierPath-Length library
                    point = obj.path.point(atPercentOfLength: CGFloat((ctime-time)/singleduration))
                } else {
                    point = obj.path.reversing().point(atPercentOfLength: CGFloat((ctime-time)/singleduration))
                }
                ticksprite.position = point
                tickpoints[tickpoints.count-1].append(ticksprite)
                ticktimes.append(ctime)
                ctime += tickinterval
            }
            time += singleduration
            if toend {
                toend = false
            } else {
                toend = true
            }
        }
        runstarttime = Double(obj.time)
    }
    
    static let arrowanim = SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.1),SKAction.scale(to: 1.0, duration: 0.1),SKAction.wait(forDuration: 0.2)]))
    
    func show(_ scene:SKScene,offset:Double) {
        self.scene = scene
        let artime = (ActionSet.difficulty?.ARTime)!/1000
        let showact = SKAction.sequence([.wait(forDuration: offset/1000),.run {
            scene.addChild(self.headinner!)
            scene.addChild(self.headoverlay!)
            for num in self.headnumber {
                scene.addChild(num)
            }
            if self.arrowinners.count > 0 {
                for i in 0 ... self.arrowinners.count-1 {
                    scene.addChild(self.arrowinners[i])
                    scene.addChild(self.arrowarrows[i])
                    self.arrowarrows[i].run(SliderAction.arrowanim)
                    scene.addChild(self.arrowoverlays[i])
                }
            }
            for tickpoint in self.tickpoints[0] {
                scene.addChild(tickpoint)
            }
            scene.addChild(self.endinner!)
            scene.addChild(self.endoverlay!)
            scene.addChild(self.inbody!)
            scene.addChild(self.outbody!)
            scene.addChild(self.appcircle!)
            self.appcircle?.run(.sequence([.group([.fadeIn(withDuration: artime/3),.scale(to: 1, duration: artime)]),.run {
                self.appcircle?.isHidden = true
                }]))
            }])
        let ballact = GamePlayScene.sliderball?.show(color, path: obj.path, repe: obj.repe, duration: singleduration/1000, waittime: artime + offset/1000)
        let failact = SKAction.sequence([.wait(forDuration: artime + offset/1000 + (ActionSet.difficulty?.Score50)!/1000),.run {
            self.headinner?.run(CircleAction.faildisappear)
            self.headoverlay?.run(CircleAction.faildisappear)
            for num in self.headnumber {
                num.run(CircleAction.faildisappear)
            }
            self.pointer += 1
            self.failcount += 1
            }])
        dummynode = SKNode()
        scene.addChild(dummynode!)
        scene.run(ballact!)
        let waittime = artime + offset/1000 + (ActionSet.difficulty?.Score300)!/1000 + singleduration/1000 * Double(obj.repe) + 1
        dummynode?.run(.group([showact,failact]))
        guardnode = SKNode()
        scene.addChild(guardnode!)
        guardnode?.run(.sequence([.wait(forDuration: waittime),.run{
            self.destroy()
            }]))
    }
    
    func getposition(_ time:Double) -> CGPoint {
        if pointer == 0 {
            return CGPoint(x: obj.x, y: obj.y)
        } else {
            return (GamePlayScene.sliderball?.sliderball1.position)!
        }
    }
    
    func update(_ time:Double,following:Bool) -> SliderFeedback {
        if self.time - time > (ActionSet.difficulty?.ARTime)! || pointer >= stats.count {
            return .nothing
        }
        if ticktimeindex < ticktimes.count {
            if time >= ticktimes[ticktimeindex] {
                tickpoints[runcount][tickcount].isHidden = true
                ticktimeindex += 1
                tickcount += 1
                if tickcount == tickpoints[runcount].count {
                    tickcount = 0
                    runcount += 1
                    if runcount < obj.repe {
                        newrun = true
                    }
                }
                if following {
                    return .tickPass
                } else {
                    return .failTick
                }
            }
            //Push new tick points
            if time >= runstarttime + singleduration && newrun {
                runstarttime += singleduration
                //debugPrint("time:\(time) runcount:\(runcount)")
                for tickpoint in tickpoints[runcount] {
                    scene?.addChild(tickpoint)
                }
                newrun = false
            }
        }
        switch stats[pointer] {
        case .head:
            if following {
                pointer += 1
                dummynode?.removeAllActions()
                dummynode?.isHidden = true
                switch judge(time) {
                case .s50:
                    headinner?.run(CircleAction.passdisappear)
                    headoverlay?.run(CircleAction.passdisappear)
                    for num in headnumber {
                        num.run(CircleAction.passdisappear)
                    }
                    appcircle?.isHidden = true
                    return .edgePass
                default:
                    failcount += 1
                    headinner?.run(CircleAction.faildisappear)
                    headoverlay?.run(CircleAction.faildisappear)
                    for num in headnumber {
                        num.run(CircleAction.faildisappear)
                    }
                    appcircle?.isHidden = true
                    return .failOnce
                }
            }
            break
        case .arrow:
            if time >= stattimes[pointer] {
                pointer += 1
                if following {
                    arrowinners[pointer - 2].run(CircleAction.passdisappear)
                    arrowarrows[pointer - 2].run(CircleAction.passdisappear)
                    arrowoverlays[pointer - 2].run(CircleAction.passdisappear)
                    return .edgePass
                } else {
                    failcount += 1
                    if failcount >= 2 {
                        if pointer-2 <= arrowinners.count-1 {
                            for i in pointer-2...arrowinners.count-1 {
                                arrowinners[i].run(CircleAction.faildisappear)
                                arrowarrows[i].run(CircleAction.faildisappear)
                                arrowoverlays[i].run(CircleAction.faildisappear)
                            }
                        }
                        endinner?.run(CircleAction.faildisappear)
                        endoverlay?.run(CircleAction.faildisappear)
                        inbody?.run(CircleAction.faildisappear)
                        outbody?.run(CircleAction.faildisappear)
                        for tickpoint in self.tickpoints[runcount] {
                            //scene?.addChild(tickpoint)
                            tickpoint.run(CircleAction.faildisappear)
                        }
                        GamePlayScene.sliderball?.hideall()
                        pointer = stats.count
                        return .failAll
                    } else {
                        arrowinners[pointer - 2].run(CircleAction.faildisappear)
                        arrowarrows[pointer - 2].run(CircleAction.faildisappear)
                        arrowoverlays[pointer - 2].run(CircleAction.faildisappear)
                        return .failOnce
                    }
                }
            }
        case .end:
            if time >= stattimes[pointer] {
                pointer += 1
                if following {
                    endinner?.run(CircleAction.passdisappear)
                    endoverlay?.run(CircleAction.passdisappear)
                    inbody?.run(.sequence([.fadeOut(withDuration: 0.5)]))
                    outbody?.run(.sequence([.fadeOut(withDuration: 0.5)]))
                    return .end
                } else {
                    failcount += 1
                    if failcount >= 2 {
                        endinner?.run(CircleAction.faildisappear)
                        endoverlay?.run(CircleAction.faildisappear)
                        inbody?.run(CircleAction.faildisappear)
                        outbody?.run(CircleAction.faildisappear)
                        pointer = stats.count
                        return .failAll
                    } else {
                        endinner?.run(CircleAction.passdisappear)
                        endoverlay?.run(CircleAction.passdisappear)
                        inbody?.run(.sequence([.fadeOut(withDuration: 0.5)]))
                        outbody?.run(.sequence([.fadeOut(withDuration: 0.5)]))
                        return .end
                    }
                }
            }
        }
        return .nothing
    }
    
    //In order to prevent objects remaining on the screen
    func destroy() {
        headinner?.isHidden = true
        headinner = nil
        for node in headnumber {
            node.isHidden = true
        }
        headnumber.removeAll()
        headoverlay?.isHidden = true
        headoverlay = nil
        endinner?.isHidden = true
        endinner = nil
        endoverlay?.isHidden = true
        endoverlay = nil
        if arrowarrows.count > 0 {
            for i in 0...arrowarrows.count-1 {
                arrowarrows[i].isHidden = true
                arrowinners[i].isHidden = true
                arrowoverlays[i].isHidden = true
            }
        }
        if tickpoints.count > 0 {
            for i in 0...tickpoints.count-1 {
                for node in tickpoints[i] {
                    node.isHidden = true
                }
            }
            tickpoints.removeAll()
        }
        arrowarrows.removeAll()
        arrowinners.removeAll()
        arrowoverlays.removeAll()
        inbody?.isHidden = true
        inbody = nil
        outbody?.isHidden = true
        outbody = nil
        dummynode?.isHidden = true
        dummynode = nil
        guardnode?.isHidden = true
        guardnode = nil
    }
    
    //Head Judge
    func judge(_ time:Double) -> HitResult {
        var d = time - self.time
        //debugPrint("d:\(d) score50:\((ActionSet.difficulty?.Score50)!)")
        if d < -(ActionSet.difficulty?.Score50)! {
            return .fail
        }
        d = abs(d)
        if d <= (ActionSet.difficulty?.Score50)! {
            return .s50
        }
        return .fail
    }
    
    func gettime() -> Double {
        return time
    }
    
    func getobj() -> HitObject {
        return obj
    }
    
}
