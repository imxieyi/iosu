//
//  RendererEnums.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

enum SliderStatus {
    case head
    case arrow
    case end
}

enum SliderFeedback {
    case nothing
    case edgePass
    case tickPass
    case failOnce
    case failTick
    case failAll
    case end
}
