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
    
    private let time:Double
    private let obj:Slider
    private var color:UIColor = UIColor()
    private var layer:CGFloat = 0
    private var edge:CGFloat = 0
    public var endx:CGFloat
    public var endy:CGFloat
    //Calc Length
    private var timing:TimingPoint
    private var singleduration:Double = 0
    public var fulltime:Double = 0
    //Status
    public var stats:[SliderStatus] = []
    public var stattimes:[Double] = []
    public var pointer = 0
    public var failcount = 0
    //Head
    var headinner = SKSpriteNode()
    var headoverlay = SKSpriteNode()
    var headnumber:[SKSpriteNode] = []
    var appcircle = SKSpriteNode()
    //Arrows
    var arrowinners:[SKSpriteNode] = []
    var arrowoverlays:[SKSpriteNode] = []
    var arrowarrows:[SKSpriteNode] = []
    //End
    var endinner = SKSpriteNode()
    var endoverlay = SKSpriteNode()
    //Body
    var body = SKSpriteNode()
    //Dummy
    var dummynode = SKNode()
    
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
    
    func prepare(color:UIColor,number:Int,layer:CGFloat) {
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
        //Head --- Overlay
        selflayer -= 0.01
        headoverlay = SKSpriteNode(texture: BundleImageBuffer.get(file: "hitcircleoverlay"))
        headoverlay.size = size
        headoverlay.position = position1
        headoverlay.zPosition = selflayer
        //Head --- Number
        selflayer -= 0.01
        let lo = number % 10
        let lonode = CircleAction.num2node(number: lo)
        lonode.position = position1
        lonode.zPosition = selflayer
        headnumber.append(lonode)
        if number >= 10 {
            lonode.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            let hi = (number % 100) / 10
            let hinode = CircleAction.num2node(number: hi)
            hinode.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            hinode.position = position1
            hinode.zPosition = selflayer
            headnumber.append(hinode)
        }
        //Head --- Inner
        selflayer -= 0.01
        headinner = SKSpriteNode(texture: BundleImageBuffer.get(file: "hitcircle"))
        headinner.color = color
        headinner.blendMode = .alpha
        headinner.colorBlendFactor = 1
        headinner.size = size
        headinner.position = position1
        headinner.zPosition = selflayer
        //Update status
        stats.append(.Head)
        stattimes.append(currenttime)
        //Head --- Approach Circle
        appcircle = SKSpriteNode(texture: BundleImageBuffer.get(file: "approachcircle"))
        appcircle.size = size
        appcircle.setScale(3)
        appcircle.alpha = 0
        appcircle.position = position1
        appcircle.zPosition = layer + 1
        //Arrows
        var repe = obj.repe
        var athead = false
        while repe > 1 {
            repe -= 1
            //Overlay
            selflayer -= 0.01
            let overlay = SKSpriteNode(texture: BundleImageBuffer.get(file: "hitcircleoverlay"))
            overlay.size = size
            overlay.zPosition = selflayer
            arrowoverlays.append(overlay)
            //Inner
            selflayer -= 0.01
            let inner = SKSpriteNode(texture: BundleImageBuffer.get(file: "hitcircle"))
            inner.color = color
            inner.blendMode = .alpha
            inner.colorBlendFactor = 1
            inner.zPosition = selflayer
            arrowinners.append(inner)
            if athead {
                overlay.position = position1
                inner.position = position1
                athead = false
            } else {
                overlay.position = position2
                inner.position = position2
                athead = true
            }
            //Update status
            currenttime += singleduration
            stats.append(.Arrow)
            stattimes.append(currenttime)
        }
        //End --- Overlay
        selflayer -= 0.01
        endoverlay = SKSpriteNode(texture: BundleImageBuffer.get(file: "hitcircleoverlay"))
        endoverlay.size = size
        endoverlay.zPosition = selflayer
        //End --- Inner
        selflayer -= 0.01
        endinner = SKSpriteNode(texture: BundleImageBuffer.get(file: "hitcircle"))
        endinner.color = color
        endinner.blendMode = .alpha
        endinner.colorBlendFactor = 1
        endinner.zPosition = selflayer
        if athead {
            endoverlay.position = position1
            endinner.position = position1
        } else {
            endoverlay.position = position2
            endinner.position = position2
        }
        //Update status
        currenttime += singleduration
        stats.append(.End)
        stattimes.append(currenttime)
    }
    
    func show(scene:SKScene,offset:Double) {
        let artime = (ActionSet.difficulty?.ARTime)!/1000
        let outwidth = edge * 120 / 128
        obj.genimage(color: color, layer: layer, inwidth: outwidth * 7 / 8, outwidth: outwidth)
        body = SKSpriteNode(texture: SKTexture(image: obj.image!))
        body.anchorPoint = .zero
        body.position = .zero
        body.alpha = 0.85
        body.zPosition = layer
        let showact = SKAction.sequence([.wait(forDuration: offset/1000),.run {
            scene.addChild(self.headinner)
            scene.addChild(self.headoverlay)
            for num in self.headnumber {
                scene.addChild(num)
            }
            if self.arrowinners.count > 0 {
                for i in 0 ... self.arrowinners.count-1 {
                    scene.addChild(self.arrowinners[i])
                    scene.addChild(self.arrowoverlays[i])
                }
            }
            scene.addChild(self.endinner)
            scene.addChild(self.endoverlay)
            scene.addChild(self.body)
            scene.addChild(self.appcircle)
            self.appcircle.run(.sequence([.group([.fadeIn(withDuration: artime/3),.scale(to: 1, duration: artime)]),.removeFromParent()]))
            }])
        let ballact = GamePlayScene.sliderball?.show(color: color, path: obj.path, repe: obj.repe, duration: singleduration/1000, waittime: artime + offset/1000)
        let failact = SKAction.sequence([.wait(forDuration: artime + offset/1000 + (ActionSet.difficulty?.Score50)!/1000),.run {
            self.headinner.run(CircleAction.faildisappear)
            self.headoverlay.run(CircleAction.faildisappear)
            for num in self.headnumber {
                num.run(CircleAction.faildisappear)
            }
            self.pointer += 1
            self.failcount += 1
            }])
        scene.addChild(dummynode)
        scene.run(ballact!)
        let waittime = artime + offset/1000 + (ActionSet.difficulty?.Score300)!/1000 + singleduration * Double(obj.repe) + 1
        dummynode.run(.group([showact,failact,.sequence([.wait(forDuration: waittime),.removeFromParent()])]))
    }
    
    func getposition(time:Double) -> CGPoint {
        if pointer == 0 {
            return CGPoint(x: obj.x, y: obj.y)
        } else {
            return (GamePlayScene.sliderball?.sliderball1.position)!
        }
    }
    
    func update(time:Double,following:Bool) -> SliderFeedback {
        if self.time - time > (ActionSet.difficulty?.ARTime)! && pointer >= stats.count {
            return .Nothing
        }
        switch stats[pointer] {
        case .Head:
            if following {
                pointer += 1
                dummynode.removeAllActions()
                dummynode.removeFromParent()
                switch judge(time: time) {
                case .S50:
                    headinner.run(CircleAction.passdisappear)
                    headoverlay.run(CircleAction.passdisappear)
                    for num in headnumber {
                        num.run(CircleAction.passdisappear)
                    }
                    appcircle.removeFromParent()
                    return .EdgePass
                default:
                    failcount += 1
                    headinner.run(CircleAction.faildisappear)
                    headoverlay.run(CircleAction.faildisappear)
                    for num in headnumber {
                        num.run(CircleAction.faildisappear)
                    }
                    appcircle.removeFromParent()
                    return .FailOnce
                }
            }
            break
        case .Arrow:
            if time >= stattimes[pointer] {
                pointer += 1
                if following {
                    arrowinners[pointer - 2].run(CircleAction.passdisappear)
                    arrowoverlays[pointer - 2].run(CircleAction.passdisappear)
                    return .EdgePass
                } else {
                    failcount += 1
                    if failcount >= 2 {
                        for i in pointer-2...arrowinners.count-1 {
                            arrowinners[i].run(CircleAction.faildisappear)
                            arrowoverlays[i].run(CircleAction.faildisappear)
                        }
                        endinner.run(CircleAction.faildisappear)
                        endoverlay.run(CircleAction.faildisappear)
                        body.run(CircleAction.faildisappear, completion: {
                            self.body = SKSpriteNode()
                            self.obj.image = nil
                        })
                        GamePlayScene.sliderball?.hideall()
                        pointer = stats.count
                        return .FailAll
                    } else {
                        arrowinners[pointer - 2].run(CircleAction.faildisappear)
                        arrowoverlays[pointer - 2].run(CircleAction.faildisappear)
                        return .FailOnce
                    }
                }
            }
        case .End:
            if time >= stattimes[pointer] {
                pointer += 1
                if following {
                    endinner.run(CircleAction.passdisappear)
                    endoverlay.run(CircleAction.passdisappear)
                    body.run(.sequence([.fadeOut(withDuration: 0.5),.removeFromParent()]), completion: {
                        self.body = SKSpriteNode()
                        self.obj.image = nil
                    })
                    return .End
                } else {
                    failcount += 1
                    if failcount >= 2 {
                        endinner.run(CircleAction.faildisappear)
                        endoverlay.run(CircleAction.faildisappear)
                        body.run(CircleAction.faildisappear, completion: {
                            self.body = SKSpriteNode()
                            self.obj.image = nil
                        })
                        return .FailAll
                    } else {
                        endinner.run(CircleAction.passdisappear)
                        endoverlay.run(CircleAction.passdisappear)
                        body.run(.sequence([.fadeOut(withDuration: 0.5),.removeFromParent()]), completion: {
                            self.body = SKSpriteNode()
                            self.obj.image = nil
                        })
                        return .End
                    }
                }
            }
        }
        return .Nothing
    }
    
    //Head Judge
    func judge(time:Double) -> HitResult {
        var d = time - self.time
        debugPrint("d:\(d) score50:\((ActionSet.difficulty?.Score50)!)")
        if d < -(ActionSet.difficulty?.Score50)! {
            return .Fail
        }
        d = abs(d)
        if d <= (ActionSet.difficulty?.Score50)! {
            return .S50
        }
        return .Fail
    }
    
    func gettime() -> Double {
        return time
    }
    
    func getobj() -> HitObject {
        return obj
    }
    
}
