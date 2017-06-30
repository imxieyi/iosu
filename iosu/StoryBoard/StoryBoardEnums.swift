//
//  StoryBoardEnums.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

enum StoryBoardError:Error {
    case fileNotFound
    case illegalFormat
}

enum SBLayer {
    case background
    case fail
    case pass
    case foreground
}

enum SBOrigin {
    case topLeft
    case topCentre
    case topRight
    case centreLeft
    case centre
    case centreRight
    case bottomLeft
    case bottomCentre
    case bottomRight
}

enum LoopType {
    case loopForever
    case loopOnce
}

enum StoryBoardCommand {
    case fade
    case move
    case moveX
    case moveY
    case scale
    case vScale //x and y scale differently
    case rotate
    case color
    case parameter
    case loop
    case trigger
    case unknown
}
