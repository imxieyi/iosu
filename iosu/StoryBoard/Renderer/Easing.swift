//
//  Easing.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKitEasingSwift

class Easing {
    
    var function:CurveType
    var type:EaseType
    
    init(function:CurveType,type:EaseType) {
        self.function=function
        self.type=type
    }
    
}
