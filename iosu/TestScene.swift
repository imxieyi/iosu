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
    var path:UIBezierPath?
    var pathlayer:CAShapeLayer?
    var pathlayer2:CAShapeLayer?
    //var pathanimation:CABasicAnimation?
    
    override func update(_ currentTime: TimeInterval) {
        if firstrun {
            path=UIBezierPath()
            path?.move(to: CGPoint(x: 100, y: 100))
            path?.addLine(to: CGPoint(x: 200, y: 200))
            pathlayer=CAShapeLayer()
            pathlayer?.frame=CGRect(origin: CGPoint.zero, size: self.size)
            pathlayer?.path=path?.cgPath
            pathlayer?.strokeColor=UIColor.red.cgColor
            pathlayer?.lineWidth=50.0*2
            pathlayer?.lineCap="round"
            pathlayer?.lineJoin=kCALineJoinBevel
            pathlayer?.zPosition=1
            pathlayer2=CAShapeLayer()
            pathlayer2?.frame=CGRect(origin: CGPoint.zero, size: self.size)
            pathlayer2?.path=path?.cgPath
            pathlayer2?.strokeColor=UIColor.white.cgColor
            pathlayer2?.lineWidth=58.0*2
            pathlayer2?.lineCap="round"
            pathlayer2?.lineJoin=kCALineJoinBevel
            pathlayer2?.zPosition=0.5
            firstrun=false
            UIGraphicsBeginImageContextWithOptions((pathlayer?.frame.size)!, false, 1)
            pathlayer2?.render(in: UIGraphicsGetCurrentContext()!)
            pathlayer?.render(in: UIGraphicsGetCurrentContext()!)
            let image=UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let rect=SKSpriteNode(texture: SKTexture(image: image!))
            rect.anchorPoint = CGPoint(x: 0, y: 0)
            rect.position = CGPoint(x: 0, y: 0)
            //rect.setScale(2)
            self.addChild(rect)
        }
    }
    
}
