//
//  RendererEnums.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

enum SliderStatus {
    case Head
    case Arrow
    case End
}

enum SliderFeedback {
    case Nothing
    case EdgePass
    case FailOnce
    case FailAll
    case End
}
