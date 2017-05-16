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
    
    let sliderball1=SKSpriteNode(texture: SliderBall.sliderballimg(file: "sliderb0"))
    let sliderball2=SKSpriteNode(texture: SliderBall.sliderballimg(file: "sliderb5"))
    let followcircle=SKSpriteNode(texture: SKTexture(imageNamed: "sliderfollowcircle"))
    let scene:SKScene
    
    init(scene:SKScene) {
        self.scene = scene
    }
    
    public func initialize(size:CGFloat) {
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
            textures1.append(SliderBall.sliderballimg(file: "sliderb\(i)"))
            textures2.append(SliderBall.sliderballimg(file: "sliderb\((i+5)%10)"))
        }
        scene.addChild(self.sliderball1)
        scene.addChild(self.sliderball2)
        sliderball1.run(.repeatForever(.animate(with: textures1, timePerFrame: 0.05)))
        sliderball2.run(.repeatForever(.animate(with: textures2, timePerFrame: 0.05)))
        //Follow circle
        followcircle.size=CGSize(width: size*2, height: size*2)
        followcircle.alpha=0
        followcircle.zPosition=500000
        scene.addChild(followcircle)
    }
    
    public func show(color:UIColor, path:UIBezierPath, repe:Int, duration:Double, waittime:Double) -> SKAction {
        return SKAction.sequence([.wait(forDuration: waittime),.run {
            let mirror=CGAffineTransform(scaleX: 1, y: -1)
            let translate=CGAffineTransform(translationX: 0, y: CGFloat(GamePlayScene.scrheight))
            path.apply(mirror)
            path.apply(translate)
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
            self.sliderball2.run(action)
            self.followcircle.run(.sequence([.sequence(moving),.fadeOut(withDuration: 0.1)]))
            }])
    }
    
    public func hideall() {
        sliderball1.alpha = 0
        sliderball2.alpha = 0
        hidefollowcircle()
    }
    
    public func showfollowcircle() {
        followcircle.run(.fadeIn(withDuration: 0.1))
    }
    
    public func hidefollowcircle() {
        followcircle.run(.fadeOut(withDuration: 0.1))
    }
    
    private static func sliderballimg(file:String) -> SKTexture {
        let img=UIImage(named: file)
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
