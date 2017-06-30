//
//  TestScene.swift
//  iosu
//
//  Created by xieyi on 2017/4/7.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TestScene:SKScene {
    
    override func sceneDidLoad() {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("touch")
    }
    
    var firstrun=true
    
    fileprivate func sliderballimg(_ file:String) -> SKTexture {
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
    
    override func update(_ currentTime: TimeInterval) {
        if firstrun {
            let sliderball1=SKSpriteNode(texture: sliderballimg("sliderb0"))
            sliderball1.position=CGPoint(x: self.size.width/2, y: self.size.height/2)
            sliderball1.color = .red
            sliderball1.colorBlendFactor = 1
            sliderball1.blendMode = .alpha
            let sliderball2=SKSpriteNode(texture: sliderballimg("sliderb5"))
            sliderball2.position=CGPoint(x: self.size.width/2, y: self.size.height/2)
            sliderball2.color = .black
            sliderball2.colorBlendFactor = 1
            sliderball2.blendMode = .alpha
            var textures1:[SKTexture]=[]
            var textures2:[SKTexture]=[]
            for i in 0...9 {
                textures1.append(sliderballimg("sliderb\(i)"))
                textures2.append(sliderballimg("sliderb\((i+5)%10)"))
            }
            addChild(sliderball1)
            addChild(sliderball2)
            sliderball1.run(.repeatForever(.animate(with: textures1, timePerFrame: 0.1)))
            sliderball2.run(.repeatForever(.animate(with: textures2, timePerFrame: 0.1)))
            let path=UIBezierPath()
            path.move(to: CGPoint(x: 0, y: self.size.height/2))
            path.addCurve(to: CGPoint(x: 1200, y: self.size.height/2), controlPoint1: CGPoint(x: 400, y: self.size.height/2+800), controlPoint2: CGPoint(x: 800, y: self.size.height/2-800))
            //path.addLine(to: CGPoint(x: 500, y: self.size.height/2))
            let action=SKAction.repeatForever(.sequence([.follow(path.cgPath, asOffset: false, orientToPath: true, duration: 10),.follow(path.reversing().cgPath, asOffset: false, orientToPath: true, duration: 10)]))
            sliderball1.run(action)
            sliderball2.run(action)
            firstrun=false
        }
    }
    
}
