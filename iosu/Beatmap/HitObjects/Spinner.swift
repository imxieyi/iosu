//
//  Spinner.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class Spinner:HitObject{
    
    var endtime:Int
    
    init(time:Int,hitsound:Int,endtime:Int,newcombo:Bool) {
        self.endtime=endtime
        super.init(type: .Spinner, x: 0, y: 0, time: time, hitsound: HitObject.hitsoundDecode(num: hitsound), newcombo: newcombo)
    }
    
}
