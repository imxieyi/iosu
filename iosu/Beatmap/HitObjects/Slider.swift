//
//  Slider.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class Slider:HitObject{
    
    var cx:[Int] = []
    var cy:[Int] = []
    var repe:Int = 0
    var length:Int = 0
    var image:UIImage?
    var stype:SliderType
    let path=UIBezierPath()
    public var bordercolor = UIColor.white
    public var trackcolor = UIColor.clear
    public var trackoverride = false
    
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
    
    func genpath(debug:Bool) {
        var allx:[CGFloat]=[CGFloat(x)]
        var ally:[CGFloat]=[CGFloat(GamePlayScene.scrheight)-CGFloat(y)]
        for i in 0...cx.count-1 {
            allx.append(CGFloat(cx[i]))
            ally.append(CGFloat(GamePlayScene.scrheight)-CGFloat(cy[i]))
        }
        path.move(to: CGPoint(x: allx.first!, y: ally.first!))
        switch self.stype {
        case .Linear:
            for i in 1...allx.count-1 {
                path.addLine(to: CGPoint(x: allx[i], y: ally[i]))
            }
            break
        case .PassThrough:
            genpassthrough(x1: allx[0], y1: ally[0], x2: allx[1], y2: ally[1], x3: allx[2], y3: ally[2])
            break
        case .Bezier:
            var xx:[CGFloat]=[]
            var yy:[CGFloat]=[]
            for i in 0...allx.count-2 {
                xx.append(CGFloat(allx[i]))
                yy.append(ally[i])
                if(allx[i]==allx[i+1] && ally[i]==ally[i+1]) {
                    if(debug){
                        debugPrint("count:\(xx.count) \(xx) \(yy)")
                    }
                    genbezier(x: xx, y: yy)
                    xx=[]
                    yy=[]
                }
            }
            if(debug){
                debugPrint("count:\(xx.count) \(xx) \(yy)")
            }
            xx.append(allx[allx.count-1])
            yy.append(ally[allx.count-1])
            genbezier(x: xx, y: yy)
            break
        case .Catmull:
            gencatmull(x: allx, y: ally)
            break
        default:
            for i in 1...allx.count-1 {
                //path.move(to: CGPoint(x: allx[i-1], y: ally[i-1]))
                path.addLine(to: CGPoint(x: allx[i], y: ally[i]))
            }
            break
        }
        let mirror=CGAffineTransform(scaleX: 1, y: -1)
        let translate=CGAffineTransform(translationX: 0, y: CGFloat(GamePlayScene.scrheight))
        path.apply(mirror)
        path.apply(translate)
    }
    
    private func genpassthrough(x1:CGFloat,y1:CGFloat,x2:CGFloat,y2:CGFloat,x3:CGFloat,y3:CGFloat) {
        //debugPrint("\(time) (\(x1),\(y1)) (\(x2),\(y2)) (\(x3),\(y3))")
        //Reference:http://blog.csdn.net/xiaogugood/article/details/28238349
        let t1=x1*x1+y1*y1
        let t2=x2*x2+y2*y2
        let t3=x3*x3+y3*y3
        let temp=x1*y2+x2*y3+x3*y1-x1*y3-x2*y1-x3*y2
        //A straight line instead of an arc
        if temp == 0 {
            path.addLine(to: CGPoint(x: x3, y: y3))
            return
        }
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
            //path.addLine(to: CGPoint(x: x[0], y: y[0]))
            path.addLine(to: CGPoint(x: x[1], y: y[1]))
            break
        case 3:
            //path.addLine(to: CGPoint(x: x[0], y: y[0]))
            path.addQuadCurve(to: CGPoint(x: x[2], y: y[2]), controlPoint: CGPoint(x: x[1], y: y[1]))
            break
        case 4:
            //path.addLine(to: CGPoint(x: x[0], y: y[0]))
            path.addCurve(to: CGPoint(x: x[3], y: y[3]), controlPoint1: CGPoint(x: x[1], y: y[1]), controlPoint2: CGPoint(x: x[2], y: y[2]))
            break
        default:
            genhighbezier(x: x, y: y)
        }
    }
    
    //https://pomax.github.io/bezierinfo/zh-CN/
    private func genhighbezier(x:[CGFloat],y:[CGFloat]) {
        var points:[CGPoint]=[]
        for i in 0...x.count-1 {
            points.append(CGPoint(x: x[i], y: y[i]))
        }
        //path.addLine(to: points.first!)
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
    
}
