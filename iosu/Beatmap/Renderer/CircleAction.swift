//
//  CircleAction.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class CircleAction:HitObjectAction {
    
    fileprivate let time:Double
    fileprivate let obj:HitCircle
    fileprivate var inner:SKSpriteNode? = nil
    fileprivate var overlay:SKSpriteNode? = nil
    fileprivate var number:[SKSpriteNode]=[]
    fileprivate var appcircle:SKSpriteNode? = nil
    fileprivate var dummynode:SKNode? = nil
    fileprivate var guardnode:SKNode? = nil
    
    init(obj:HitCircle) {
        self.time=Double(obj.time)
        self.obj=obj
    }
    
    func prepare(_ color:UIColor,number:Int,layer:CGFloat) {
        let edge = CGFloat((ActionSet.difficulty?.AbsoluteCS)!)
        let size = CGSize(width: edge, height: edge)
        let position = CGPoint(x: obj.x, y: obj.y)
        var selflayer = layer
        //Draw inner
        selflayer += 0.1
        inner = SKSpriteNode(texture: SkinBuffer.get("hitcircle"))
        inner?.color = color
        inner?.blendMode = .alpha
        inner?.colorBlendFactor = 1
        inner?.size = size
        inner?.position = position
        inner?.zPosition = selflayer
        //Draw number
        selflayer += 0.1
        let lo = number % 10
        let lonode = CircleAction.num2node(lo)
        lonode.position = position
        lonode.zPosition = selflayer
        self.number.append(lonode)
        if number >= 10 {
            lonode.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            selflayer += 0.1
            let hi = (number % 100) / 10
            let hinode = CircleAction.num2node(hi)
            hinode.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            hinode.position = position
            hinode.zPosition = selflayer
            self.number.append(hinode)
        }
        //Draw overlay
        selflayer += 0.1
        overlay = SKSpriteNode(texture: SkinBuffer.get("hitcircleoverlay"))
        overlay?.colorBlendFactor = 0
        overlay?.size = size
        overlay?.position = position
        overlay?.zPosition = selflayer
        //Draw Approach Circle
        appcircle = SKSpriteNode(texture: SkinBuffer.get("approachcircle"))
        appcircle?.colorBlendFactor = 0
        appcircle?.size = size
        appcircle?.setScale(3)
        appcircle?.alpha = 0
        appcircle?.position = position
        appcircle?.zPosition = 100001
    }
    
    static func num2node(_ number:Int) -> SKSpriteNode {
        let texture = SkinBuffer.get("default-\(number)")
        var width = (texture?.size().width)!
        var height = (texture?.size().height)!
        let scale = CGFloat((ActionSet.difficulty?.AbsoluteCS)!) / 3 / height
        width *= scale
        height *= scale
        let node = SKSpriteNode(texture: texture)
        node.colorBlendFactor = 0
        node.size = CGSize(width: width, height: height)
        return node
    }
    
    static let faildisappear = SKAction.sequence([.fadeOut(withDuration: 0.1),.removeFromParent()])
    func show(_ scene:SKScene,offset:Double) {
        let artime = (ActionSet.difficulty?.ARTime)!/1000
        let showact = SKAction.sequence([.wait(forDuration: offset/1000),.run{
            scene.addChild(self.inner!)
            scene.addChild(self.overlay!)
            for num in self.number {
                scene.addChild(num)
            }
            scene.addChild(self.appcircle!)
            self.appcircle?.run(.sequence([.group([.fadeIn(withDuration: artime/3),.scale(to: 1, duration: artime)]),.removeFromParent()]))
            }])
        let failact = SKAction.sequence([.wait(forDuration: artime+offset/1000+(ActionSet.difficulty?.Score50)!/1000),SKAction.playSoundFileNamed("combobreak.mp3", atVolume: GamePlayScene.effvolume, waitForCompletion: false),.run {
            ActionSet.current?.pointer+=1
            self.inner?.run(CircleAction.faildisappear)
            self.overlay?.run(CircleAction.faildisappear)
            for num in self.number {
                num.run(CircleAction.faildisappear)
            }
            //Show fail
            let img = SkinBuffer.get("hit0")!
            let node = SKSpriteNode(texture: img)
            let scale = CGFloat((ActionSet.difficulty?.AbsoluteCS)! / 128)
            node.setScale(scale)
            node.colorBlendFactor = 0
            node.alpha = 0
            node.position = CGPoint(x: self.obj.x, y: self.obj.y)
            node.zPosition = 100001
            scene.addChild(node)
            node.run(.group([.sequence([.fadeIn(withDuration: 0.2),.fadeOut(withDuration: 0.6),.removeFromParent()]),.sequence([.scale(by: 1.5, duration: 0.1),.scale(to: scale, duration: 0.1)])]))
            }])
        dummynode = SKNode()
        scene.addChild(dummynode!)
        dummynode?.run(.group([showact,failact]))
        guardnode = SKNode()
        guardnode?.run(.wait(forDuration: artime+offset/1000+(ActionSet.difficulty?.Score50)!/1000+2), completion: {
            self.destroy()
        })
    }
    
    static let passdisappear = SKAction.sequence([.group([.fadeOut(withDuration: 0.2),.scale(to: 2, duration: 0.2)]),.removeFromParent()])
    //Time in ms
    func judge(_ time:Double) -> HitResult {
        ActionSet.current?.pointer+=1
        dummynode?.removeAllActions()
        dummynode?.run(.sequence([.wait(forDuration: 0.5),.removeFromParent()]))
        var d = time - self.time
        //debugPrint("d:\(d) score50:\((ActionSet.difficulty?.Score50)!)")
        if d < -(ActionSet.difficulty?.Score50)! {
            self.inner?.run(CircleAction.faildisappear)
            self.overlay?.run(CircleAction.faildisappear)
            for num in self.number {
                num.run(CircleAction.faildisappear)
            }
            self.appcircle?.run(CircleAction.faildisappear)
            return .fail
        }
        d = abs(d)
        if d <= (ActionSet.difficulty?.Score50)! {
            self.inner?.run(CircleAction.passdisappear)
            self.overlay?.run(CircleAction.passdisappear)
            for num in self.number {
                num.run(CircleAction.passdisappear)
            }
            self.appcircle?.removeFromParent()
            if d <= (ActionSet.difficulty?.Score300)! {
                return .s300
            }
            if d <= (ActionSet.difficulty?.Score100)! {
                return .s100
            }
            return .s50
        }
        self.inner?.run(CircleAction.faildisappear)
        self.overlay?.run(CircleAction.faildisappear)
        for num in self.number {
            num.run(CircleAction.faildisappear)
        }
        self.appcircle?.run(CircleAction.faildisappear)
        return .fail
    }
    
    func gettime() -> Double {
        return time
    }
    
    func getobj() -> HitObject {
        return obj
    }
    
    func destroy() {
        inner?.removeFromParent()
        inner = nil
        for node in number {
            node.removeFromParent()
        }
        number.removeAll()
        overlay?.removeFromParent()
        overlay = nil
        appcircle?.removeFromParent()
        appcircle = nil
        dummynode?.removeFromParent()
        dummynode = nil
        guardnode?.removeFromParent()
        guardnode = nil
    }
    
}
