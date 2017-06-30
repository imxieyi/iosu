//
//  HitObject.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
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
    
    static func getObjectType(_ num:Int) -> HitObjectType {
        if num==1 || num==5 {
            return HitObjectType.circle
        }
        if num==2 || num==6 {
            return HitObjectType.slider
        }
        if num==8 || num==12 {
            return HitObjectType.spinner
        }
        return HitObjectType.none
    }
    
    static func getNewCombo(_ num:Int) -> Bool {
        if num==5 || num==6 || num==12 {
            return true
        }
        return false
    }
    
    static func hitsoundDecode(_ num:Int) -> HitSound {
        switch num {
        case 0:
            return .normal
        case 2:
            return .whistle
        case 4:
            return .finish
        case 8:
            return .clap
        default:
            //Maybe there are other types
            return .normal
        }
    }
    
}
