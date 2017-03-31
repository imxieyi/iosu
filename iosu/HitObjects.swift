//
//  HitObject.swift
//  iosu
//
//  Created by xieyi on 2017/3/30.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class HitObject{
    
    var type:HitObjectType
    var x:Int //0~512
    var y:Int //0~384
    var time:Int //Milliseconds from beginning of song
    var hitSound:HitSound
    var newCombo:Bool
    
    init() {
        self.type=HitObjectType.None
        self.x=0
        self.y=0
        self.time=0
        self.hitSound = .Normal
        self.newCombo=false
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
        super.init()
        self.type=HitObjectType.Circle
        self.x=x
        self.y=y
        self.time=time
        self.hitSound=HitObject.hitsoundDecode(num: hitsound)
        self.newCombo=newCombo
    }
    
    init(x:Int,y:Int,time:Int,hitsound:Int,newCombo:Bool,type:CircleType) {
        super.init()
        self.type=HitObjectType.Circle
        self.x=x
        self.y=y
        self.time=time
        self.hitSound=HitObject.hitsoundDecode(num: hitsound)
        self.newCombo=newCombo
        self.ctype=type
    }
    
}

class Slider:HitObject{
    
    var cx:[Int] = []
    var cy:[Int] = []
    var repe:Int = 0
    var length:Int = 0
    
    init(x:Int,y:Int,curveX:[Int],curveY:[Int],time:Int,hitsound:Int,newCombo:Bool,repe:Int,length:Int) {
        super.init()
        self.type=HitObjectType.Slider
        self.x=x
        self.y=y
        self.cx=curveX
        self.cy=curveY
        self.time=time
        self.hitSound=HitObject.hitsoundDecode(num: hitsound)
        self.newCombo=newCombo
        self.repe=repe
        self.length=length
    }
    
}

class Spinner:HitObject{
    
    var endtime:Int
    
    init(time:Int,hitsound:Int,endtime:Int,newcombo:Bool) {
        self.endtime=endtime
        super.init()
        self.time=time
        self.hitSound=HitObject.hitsoundDecode(num: hitsound)
        self.type = .Spinner
        self.x=256
        self.y=192
        self.newCombo=newcombo
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
