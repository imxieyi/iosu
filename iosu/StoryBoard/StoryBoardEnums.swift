//
//  StoryBoardEnums.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

enum StoryBoardError:Error {
    case FileNotFound
    case IllegalFormat
}

enum SBLayer {
    case Background
    case Fail
    case Pass
    case Foreground
}

enum SBOrigin {
    case TopLeft
    case TopCentre
    case TopRight
    case CentreLeft
    case Centre
    case CentreRight
    case BottomLeft
    case BottomCentre
    case BottomRight
}

enum LoopType {
    case LoopForever
    case LoopOnce
}

enum StoryBoardCommand {
    case Fade
    case Move
    case MoveX
    case MoveY
    case Scale
    case VScale //x and y scale differently
    case Rotate
    case Color
    case Parameter
    case Loop
    case Trigger
    case Unknown
}
