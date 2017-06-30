//
//  SliderBall.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class SliderBall {
    
    let sliderball1=SKSpriteNode(texture: SliderBall.sliderballimg("sliderb0"))
    let sliderball2=SKSpriteNode(texture: SliderBall.sliderballimg("sliderb5"))
    var followcircle=SKSpriteNode(texture: SKTexture(imageNamed: "sliderfollowcircle"))
    let scene:SKScene
    var useSkin = false
    
    init(scene:SKScene) {
        self.scene = scene
    }
    
    open func initialize(_ size:CGFloat) {
        var n_follow = -1
        var textures3:[SKTexture]=[]
        if SkinBuffer.useSkin {
            var n = -1
            for i in 0...20 {
                _ = SkinBuffer.get("sliderb\(i)")
                if !SkinBuffer.getFlag("sliderb\(i)") {
                    n = i - 1
                    break
                }
            }
            //Parse following circle
            for i in 0...20 {
                _ = SkinBuffer.get("sliderfollowcircle-\(i)")
                if !SkinBuffer.getFlag("sliderfollowcircle-\(i)") {
                    n_follow = i - 1
                    break
                }
            }
            if n > -1 {
                debugPrint("sliderb count in skin: \(n+1)")
                useSkin = true
                sliderball1.colorBlendFactor = 0
                sliderball1.blendMode = .alpha
                sliderball1.zPosition=500000
                sliderball1.size=CGSize(width: size, height: size)
                sliderball1.alpha=0
                scene.addChild(self.sliderball1)
                if n > 0{
                    var textures1:[SKTexture]=[]
                    for i in 0...n {
                        textures1.append(SliderBall.sliderballimg("sliderb\(i)"))
                    }
                    sliderball1.run(.repeatForever(.animate(with: textures1, timePerFrame: 0.05)))
                }
                //Follow circle
                if n_follow > -1 {
                    followcircle=SKSpriteNode(texture: SkinBuffer.get("sliderfollowcircle-0"))
                    followcircle.size=CGSize(width: size*2, height: size*2)
                    followcircle.alpha=0
                    followcircle.zPosition=500000
                    scene.addChild(followcircle)
                    for i in 0...n_follow {
                        textures3.append(SkinBuffer.get("sliderfollowcircle-\(i)")!)
                    }
                    followcircle.run(.repeatForever(.animate(with: textures3, timePerFrame: 0.2)))
                } else {
                    followcircle.size=CGSize(width: size*2, height: size*2)
                    followcircle.alpha=0
                    followcircle.zPosition=500000
                    scene.addChild(followcircle)
                }
                return
            }
        }
        sliderball1.color = .red
        sliderball1.colorBlendFactor = 1
        sliderball1.blendMode = .alpha
        sliderball1.zPosition=500000
        sliderball1.size=CGSize(width: size, height: size)
        sliderball1.alpha=0
        sliderball2.color = .black
        sliderball2.colorBlendFactor = 1
        sliderball2.blendMode = .alpha
        sliderball2.zPosition=500000
        sliderball2.size=CGSize(width: size, height: size)
        sliderball2.alpha=0
        var textures1:[SKTexture]=[]
        var textures2:[SKTexture]=[]
        for i in 0...9 {
            textures1.append(SliderBall.sliderballimg("sliderb\(i)"))
            textures2.append(SliderBall.sliderballimg("sliderb\((i+5)%10)"))
        }
        scene.addChild(self.sliderball1)
        scene.addChild(self.sliderball2)
        sliderball1.run(.repeatForever(.animate(with: textures1, timePerFrame: 0.05)))
        sliderball2.run(.repeatForever(.animate(with: textures2, timePerFrame: 0.05)))
        //Follow circle
        if SkinBuffer.useSkin {
            if n_follow > -1 {
                followcircle=SKSpriteNode(texture: SkinBuffer.get("sliderfollowcircle-0"))
                followcircle.size=CGSize(width: size*2, height: size*2)
                followcircle.alpha=0
                followcircle.zPosition=500000
                scene.addChild(followcircle)
                for i in 0...n_follow {
                    textures3.append(SkinBuffer.get("sliderfollowcircle-\(i)")!)
                }
                followcircle.run(.repeatForever(.animate(with: textures3, timePerFrame: 0.2)))
                return
            }
        }
        followcircle.size=CGSize(width: size*2, height: size*2)
        followcircle.alpha=0
        followcircle.zPosition=500000
        scene.addChild(followcircle)
    }
    
    open func show(_ color:UIColor, path:UIBezierPath, repe:Int, duration:Double, waittime:Double) -> SKAction {
        return SKAction.sequence([.wait(forDuration: waittime),.run {
            let rpath=path.reversing()
            self.sliderball1.color = color
            var moving:[SKAction]=[SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, duration: duration)]
            if repe>1 {
                for i in 2...repe {
                    if(i%2==0){
                        moving.append(SKAction.follow(rpath.cgPath, asOffset: false, orientToPath: true, duration: duration))
                    }else{
                        moving.append(SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, duration: duration))
                    }
                }
            }
            let action=SKAction.sequence([SKAction.fadeIn(withDuration:0),SKAction.sequence(moving),SKAction.fadeOut(withDuration: 0)])
            self.sliderball1.run(action)
            if !self.useSkin {
                self.sliderball2.run(action)
            }
            self.followcircle.run(.sequence([.sequence(moving),.fadeOut(withDuration: 0.1)]))
            }])
    }
    
    open func hideall() {
        sliderball1.alpha = 0
        sliderball2.alpha = 0
        hidefollowcircle()
    }
    
    open func showfollowcircle() {
        followcircle.run(.fadeIn(withDuration: 0.1))
    }
    
    open func hidefollowcircle() {
        followcircle.run(.fadeOut(withDuration: 0.1))
    }
    
    //In order to rotate images in SKAction
    fileprivate static func sliderballimg(_ file:String) -> SKTexture {
        let img=SkinBuffer.getimg(file)
        let rotatedViewBox=UIView(frame: CGRect(x: 0, y: 0, width: (img?.size.width)!, height: (img?.size.height)!))
        rotatedViewBox.transform=CGAffineTransform(rotationAngle: -.pi/2)
        let rotatedSize=rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap=UIGraphicsGetCurrentContext()
        bitmap?.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2)
        bitmap?.rotate(by: -.pi/2)
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw((img?.cgImage)!, in: CGRect(x: -(img?.size.width)!/2, y: -(img?.size.height)!/2, width: (img?.size.width)!, height: (img?.size.height)!))
        let newimg=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return SKTexture(image: newimg!)
    }
    
}
