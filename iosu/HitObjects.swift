//
//  HitObject.swift
//  iosu
//
//  Created by xieyi on 2017/3/30.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import UIKit

class HitObject{
    
    var type:HitObjectType
    var x:Int //0~512
    var y:Int //0~384
    var time:Int //Milliseconds from beginning of song
    var hitSound:HitSound
    var newCombo:Bool
    
    init(type:HitObjectType,x:Int,y:Int,time:Int,hitsound:HitSound,newcombo:Bool) {
        self.type=type
        debugPrint("before:\(x),\(y)")
        self.x=Int(GamePlayScene.conv(x: Double(x)))
        self.y=Int(GamePlayScene.conv(y: Double(y)))
        debugPrint("after:\(self.x),\(self.y)")
        self.time=time
        self.hitSound = hitsound
        self.newCombo=newcombo
    }
    
    static func getObjectType(num:String) -> HitObjectType {
        if num=="1" || num=="5" {
            return HitObjectType.Circle
        }
        if num=="2" || num=="6" {
            return HitObjectType.Slider
        }
        if num=="8" || num=="12" {
            return HitObjectType.Spinner
        }
        return HitObjectType.None
    }
    
    static func getNewCombo(num:String) -> Bool {
        if num=="5" || num=="6" || num=="12" {
            return true
        }
        return false
    }
    
    static func hitsoundDecode(num:Int) -> HitSound {
        switch num {
        case 0:
            return .Normal
        case 2:
            return .Whistle
        case 4:
            return .Finish
        case 8:
            return .Clap
        default:
            //Maybe there are other types
            return .Normal
        }
    }
    
}

class HitCircle:HitObject{
    
    var ctype:CircleType = .Plain
    
    init(x:Int,y:Int,time:Int,hitsound:Int,newCombo:Bool) {
        super.init(type: .Circle, x: x, y: y, time: time, hitsound: HitObject.hitsoundDecode(num: hitsound), newcombo: newCombo)
    }
    
    init(x:Int,y:Int,time:Int,hitsound:Int,newCombo:Bool,type:CircleType) {
        self.ctype=type
        super.init(type: .Circle, x: x, y: y, time: time, hitsound: HitObject.hitsoundDecode(num: hitsound), newcombo: newCombo)
    }
    
}

class Slider:HitObject{
    
    var cx:[Int] = []
    var cy:[Int] = []
    var repe:Int = 0
    var length:Int = 0
    var image:UIImage?
    
    init(x:Int,y:Int,curveX:[Int],curveY:[Int],time:Int,hitsound:Int,newCombo:Bool,repe:Int,length:Int) {
        self.cx=curveX
        self.cy=curveY
        for i in 0...cx.count-1 {
            cx[i]=Int(GamePlayScene.conv(x: Double(cx[i])))
            cy[i]=Int(GamePlayScene.conv(y: Double(cy[i])))
        }
        self.repe=repe
        self.length=length
        super.init(type: .Slider, x: x, y: y, time: time, hitsound: HitObject.hitsoundDecode(num: hitsound), newcombo: newCombo)
    }
    
    func genimage(color:UIColor,layer:CGFloat,inwidth:CGFloat,outwidth:CGFloat){
        let size=CGSize(width: GamePlayScene.scrwidth, height: GamePlayScene.scrheight)
        let path=UIBezierPath()
        path.move(to: CGPoint(x: x, y: Int(GamePlayScene.scrheight)-y))
        path.addLine(to: CGPoint(x: cx[cx.count-1], y: Int(GamePlayScene.scrheight)-cy[cy.count-1]))
        let pathlayer=CAShapeLayer()
        pathlayer.frame=CGRect(origin: CGPoint.zero, size: size)
        pathlayer.path=path.cgPath
        pathlayer.strokeColor=color.cgColor
        pathlayer.lineWidth=inwidth
        pathlayer.lineCap="round"
        pathlayer.lineJoin=kCALineJoinBevel
        pathlayer.zPosition=1
        let pathlayer2=CAShapeLayer()
        pathlayer2.frame=CGRect(origin: CGPoint.zero, size: size)
        pathlayer2.path=path.cgPath
        pathlayer2.strokeColor=UIColor.white.cgColor
        pathlayer2.lineWidth=outwidth
        pathlayer2.lineCap="round"
        pathlayer2.lineJoin=kCALineJoinBevel
        pathlayer2.zPosition=0
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        pathlayer2.render(in: UIGraphicsGetCurrentContext()!)
        pathlayer.render(in: UIGraphicsGetCurrentContext()!)
        image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
}

class Spinner:HitObject{
    
    var endtime:Int
    
    init(time:Int,hitsound:Int,endtime:Int,newcombo:Bool) {
        self.endtime=endtime
        super.init(type: .Spinner, x: 0, y: 0, time: time, hitsound: HitObject.hitsoundDecode(num: hitsound), newcombo: newcombo)
    }
    
}

enum HitSound {
    case Normal     //0
    case Whistle    //2
    case Finish     //4
    case Clap       //8
}

enum HitObjectType{
    case Circle
    case Slider
    case Spinner
    case None //Unknown hitobject type
}

enum CircleType{
    case Plain
    case SliderHead
    case SliderEnd
    case SliderArrow
}

enum SliderType{
    case Linear //L
    case PassThrough //P
    case Bezier //B
    case Catmull //C
    case None //Invalid slider type
}
