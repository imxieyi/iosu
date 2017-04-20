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
    let path=UIBezierPath()
    
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
    
    func genpath() {
        var allx:[CGFloat]=[CGFloat(x)]
        var ally:[CGFloat]=[CGFloat(GamePlayScene.scrheight)-CGFloat(y)]
        for i in 0...cx.count-1 {
            allx.append(CGFloat(cx[i]))
            ally.append(CGFloat(GamePlayScene.scrheight)-CGFloat(cy[i]))
        }
        switch self.stype {
        case .Linear:
            for i in 1...allx.count-1 {
                path.move(to: CGPoint(x: allx[i-1], y: ally[i-1]))
                path.addLine(to: CGPoint(x: allx[i], y: ally[i]))
            }
            break
        case .PassThrough:
            genpassthrough(x1: allx[0], y1: ally[0], x2: allx[1], y2: ally[1], x3: allx[2], y3: ally[2])
            break
        case .Bezier:
            //https://pomax.github.io/bezierinfo/zh-CN/
            var xx:[CGFloat]=[]
            var yy:[CGFloat]=[]
            for i in 0...allx.count-2 {
                xx.append(CGFloat(allx[i]))
                yy.append(ally[i])
                if(allx[i]==allx[i+1] && ally[i]==ally[i+1]) {
                    genbezier(x: xx, y: yy)
                    xx=[]
                    yy=[]
                }
            }
            xx.append(CGFloat(allx[allx.count-1]))
            yy.append(ally[allx.count-1])
            genbezier(x: xx, y: yy)
            break
        case .Catmull:
            gencatmull(x: allx, y: ally)
            break
        default:
            for i in 1...allx.count-1 {
                path.move(to: CGPoint(x: allx[i-1], y: ally[i-1]))
                path.addLine(to: CGPoint(x: allx[i], y: ally[i]))
            }
            break
        }
    }
    
    private func genpassthrough(x1:CGFloat,y1:CGFloat,x2:CGFloat,y2:CGFloat,x3:CGFloat,y3:CGFloat) {
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
    }
    
    private func genbezier(x:[CGFloat],y:[CGFloat]) {
        switch x.count {
        case 0:
            break
        case 1:
            break
        case 2: //Line
            path.move(to: CGPoint(x: x[0], y: y[0]))
            path.addLine(to: CGPoint(x: x[1], y: y[1]))
            break
        case 3:
            path.move(to: CGPoint(x: x[0], y: y[0]))
            path.addQuadCurve(to: CGPoint(x: x[2], y: y[2]), controlPoint: CGPoint(x: x[1], y: y[1]))
            break
        case 4:
            path.move(to: CGPoint(x: x[0], y: y[0]))
            path.addCurve(to: CGPoint(x: x[3], y: y[3]), controlPoint1: CGPoint(x: x[1], y: y[1]), controlPoint2: CGPoint(x: x[2], y: y[2]))
            break
        default:
            genhighbezier(x: x, y: y)
        }
    }
    
    private func genhighbezier(x:[CGFloat],y:[CGFloat]) {
        var points:[CGPoint]=[]
        for i in 0...x.count-1 {
            points.append(CGPoint(x: x[i], y: y[i]))
        }
        path.move(to: points.first!)
        path.close()
        let sections=50
        let interval=1.0/CGFloat(sections)
        for i in 1...sections {
            drawbezier(points: points, t: interval*CGFloat(i))
        }
    }
    
    private func drawbezier(points:[CGPoint],t:CGFloat) {
        if(points.count==1) {
            path.addLine(to: points[0])
        } else {
            var newpoints:[CGPoint]=[]
            for i in 0...points.count-2 {
                let x=(1-t)*points[i].x+t*points[i+1].x
                let y=(1-t)*points[i].y+t*points[i+1].y
                newpoints.append(CGPoint(x: x, y: y))
            }
            drawbezier(points: newpoints, t: t)
        }
    }
    
    //opsu: itdelatrisu.opsu.objects.curves.CatmullCurve
    private func gencatmull(x:[CGFloat],y:[CGFloat]) {
        var points:[CGPoint]=[]
        if(x[0] != x[1] || y[0] != y[1]) {
            points.append(CGPoint(x: x[0], y: y[0]))
        }
        for i in 0...x.count-1 {
            points.append(CGPoint(x: x[i], y: y[i]))
            if(points.count>=4) {
                path.move(to: points[0])
                path.close()
                let sections=50
                let interval=1.0/CGFloat(sections)
                for i in 1...sections {
                    drawcatmull(points: points, t: interval*CGFloat(i))
                }
                points.removeFirst()
            }
        }
        if(x[x.count-2] != x[x.count-1] || y[x.count-2] != y[x.count-1]) {
            points.append(CGPoint(x: x[x.count-1], y: y[x.count-1]))
        }
        if(points.count>=4){
            path.move(to: points[0])
            path.close()
            let sections=50
            let interval=1.0/CGFloat(sections)
            for i in 1...sections {
                drawcatmull(points: points, t: interval*CGFloat(i))
            }
        }
    }
    
    //http://blog.csdn.net/i_dovelemon/article/details/47984241
    private func drawcatmull(points:[CGPoint],t:CGFloat) {
        if(points.count != 4) {
            debugPrint("4 points are needed to draw catmull, got \(points.count)")
            return
        }
        let x = points[0].x * (-0.5*t*t*t + t*t - 0.5*t) + points[1].x * (1.5*t*t*t - 2.5*t*t + 1) + points[2].x * (-1.5*t*t*t + 2.0*t*t + 0.5*t) + points[3].x * (0.5*t*t*t - 0.5*t*t)
        let y = points[0].y * (-0.5*t*t*t + t*t - 0.5*t) + points[1].y * (1.5*t*t*t - 2.5*t*t + 1) + points[2].y * (-1.5*t*t*t + 2.0*t*t + 0.5*t) + points[3].y * (0.5*t*t*t - 0.5*t*t)
        path.addLine(to: CGPoint(x: x,y: y))
    }
    
    func genimage(color:UIColor,layer:CGFloat,inwidth:CGFloat,outwidth:CGFloat){
        let size=CGSize(width: GamePlayScene.scrwidth, height: GamePlayScene.scrheight)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        renderpath(path: path, color: color, inwidth: inwidth, outwidth: outwidth, size: size)
        image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func renderpath(path:UIBezierPath,color:UIColor,inwidth:CGFloat,outwidth:CGFloat,size:CGSize) {
        let pathlayer=CAShapeLayer()
        pathlayer.frame=CGRect(origin: CGPoint.zero, size: size)
        pathlayer.path=path.cgPath
        pathlayer.strokeColor=color.cgColor
        pathlayer.fillColor=UIColor.clear.cgColor
        pathlayer.lineWidth=inwidth
        pathlayer.lineCap=kCALineCapRound
        pathlayer.lineJoin=kCALineJoinBevel
        pathlayer.zPosition=1
        let pathlayer2=CAShapeLayer()
        pathlayer2.frame=CGRect(origin: CGPoint.zero, size: size)
        pathlayer2.path=path.cgPath
        pathlayer2.strokeColor=UIColor.white.cgColor
        pathlayer2.fillColor=UIColor.clear.cgColor
        pathlayer2.lineWidth=outwidth
        pathlayer2.lineCap=kCALineCapRound
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
