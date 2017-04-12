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
    //var x:[Int]=[100,200,300,400]
    //var y:[Int]=[100,200,100,200]
    //var pathanimation:CABasicAnimation?
    
    override func update(_ currentTime: TimeInterval) {
        if firstrun {
            path=UIBezierPath()
            let x1:CGFloat=100
            let y1:CGFloat=100
            let x2:CGFloat=200
            let y2:CGFloat=200
            let x3:CGFloat=300
            let y3:CGFloat=150
            //source:http://blog.csdn.net/xiaogugood/article/details/28238349
            let t1=x1*x1+y1*y1
            let t2=x2*x2+y2*y2
            let t3=x3*x3+y3*y3
            let temp=x1*y2+x2*y3+x3*y1-x1*y3-x2*y1-x3*y2
            let x=(t2*y3+t1*y2+t3*y1-t2*y1-t3*y2-t1*y3)/temp/2
            let y=(t3*x2+t2*x1+t1*x3-t1*x2-t2*x3-t3*x1)/temp/2
            let r=sqrt((x1-x)*(x1-x)+(y1-y)*(y1-y))
            var a1=atan2(y1-y, x1-x)
            let a2=atan2(y2-y, x2-x)
            var a3=atan2(y3-y, x3-x)
            var clockwise=false
            if a3>a1 {
                clockwise=true
            }
            debugPrint("\(a1) \(a2) \(a3)")
            if a1>a3 {
                let t=a1
                a1=a3
                a3=t
            }
            path?.addArc(withCenter: CGPoint(x:x,y:y), radius: r, startAngle: a1, endAngle: a3, clockwise: clockwise)
            //path?.move(to: CGPoint(x: x.first!, y: y.first!))
            //path?.addCurve(to: CGPoint(x:x.last!,y:y.last!), controlPoint1: CGPoint(x:x[1],y:y[1]), controlPoint2: CGPoint(x:x[2],y:y[2]))
            //path?.addLine(to: CGPoint(x: 200, y: 200))
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
