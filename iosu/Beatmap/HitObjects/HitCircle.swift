//
//  HitCircle.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

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
