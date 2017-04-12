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
        //debugPrint("before:\(x),\(y)")
        self.x=Int(GamePlayScene.conv(x: Double(x)))
        self.y=Int(GamePlayScene.conv(y: Double(y)))
        //debugPrint("after:\(self.x),\(self.y)")
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
    var stype:SliderType
    
    init(x:Int,y:Int,slidertype:SliderType,curveX:[Int],curveY:[Int],time:Int,hitsound:Int,newCombo:Bool,repe:Int,length:Int) {
        self.cx=curveX
        self.cy=curveY
        for i in 0...cx.count-1 {
            cx[i]=Int(GamePlayScene.conv(x: Double(cx[i])))
            cy[i]=Int(GamePlayScene.conv(y: Double(cy[i])))
        }
        self.repe=repe
        self.length=length
        self.stype=slidertype
        super.init(type: .Slider, x: x, y: y, time: time, hitsound: HitObject.hitsoundDecode(num: hitsound), newcombo: newCombo)
    }
    
    func genimage(color:UIColor,layer:CGFloat,inwidth:CGFloat,outwidth:CGFloat){
        let size=CGSize(width: GamePlayScene.scrwidth, height: GamePlayScene.scrheight)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let path=UIBezierPath()
        var allx:[Int]=[x]
        var ally:[Int]=[y]
        allx.append(contentsOf: cx)
        ally.append(contentsOf: cy)
        switch self.stype {
        case .Linear:
            for i in 1...allx.count-1 {
                path.move(to: CGPoint(x: allx[i-1], y: Int(GamePlayScene.scrheight)-ally[i-1]))
                path.addLine(to: CGPoint(x: allx[i], y: Int(GamePlayScene.scrheight)-ally[i]))
            }
            renderpath(path: path, color: color, inwidth: inwidth, outwidth: outwidth, size: size)
            break
        case .PassThrough:
            let x1=CGFloat(allx[0])
            let y1=CGFloat(Int(GamePlayScene.scrheight)-ally[0])
            let x2=CGFloat(allx[1])
            let y2=CGFloat(Int(GamePlayScene.scrheight)-ally[1])
            let x3=CGFloat(allx[2])
            let y3=CGFloat(Int(GamePlayScene.scrheight)-ally[2])
            //Reference:http://blog.csdn.net/xiaogugood/article/details/28238349
            let t1=x1*x1+y1*y1
            let t2=x2*x2+y2*y2
            let t3=x3*x3+y3*y3
            let temp=x1*y2+x2*y3+x3*y1-x1*y3-x2*y1-x3*y2
            let x=(t2*y3+t1*y2+t3*y1-t2*y1-t3*y2-t1*y3)/temp/2
            let y=(t3*x2+t2*x1+t1*x3-t1*x2-t2*x3-t3*x1)/temp/2
            let r=sqrt((x1-x)*(x1-x)+(y1-y)*(y1-y))
            var a1=atan2(y1-y, x1-x)
            var a2=atan2(y2-y, x2-x)
            var a3=atan2(y3-y, x3-x)
            if a1<0 {
                a1 += .pi*2
            }
            if a2<0 {
                a2 += .pi*2
            }
            if a3<0 {
                a3 += .pi*2
            }
            var clockwise=true
            if (a1<a2 && a2>a3 && a1<a3)||(a1>a2 && a3>a1)||(a1>a2 && a2>a3) {
                clockwise=false
            }
            path.addArc(withCenter: CGPoint(x:x,y:y), radius: r, startAngle: a1, endAngle: a3, clockwise: clockwise)
            renderpath(path: path, color: color, inwidth: inwidth, outwidth: outwidth, size: size)
            break
        //case .Bezier:
            //TODO: Parse Bezier
            //https://zh.wikipedia.org/wiki/貝茲曲線
        default:
            for i in 1...allx.count-1 {
                path.move(to: CGPoint(x: allx[i-1], y: Int(GamePlayScene.scrheight)-ally[i-1]))
                path.addLine(to: CGPoint(x: allx[i], y: Int(GamePlayScene.scrheight)-ally[i]))
            }
            renderpath(path: path, color: color, inwidth: inwidth, outwidth: outwidth, size: size)
            break
        }
        image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func renderpath(path:UIBezierPath,color:UIColor,inwidth:CGFloat,outwidth:CGFloat,size:CGSize) {
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
        pathlayer2.render(in: UIGraphicsGetCurrentContext()!)
        pathlayer.render(in: UIGraphicsGetCurrentContext()!)
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
