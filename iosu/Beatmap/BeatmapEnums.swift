//
//  BeatmapEnums.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

enum SampleSet {
    case auto
    case normal
    case soft
    case drum
}

enum BeatmapError:Error{
    case fileNotFound
    case illegalFormat
    case noAudioFile
    case noTimingPoints
    case audioFileNotExist
    case noColor
    case noHitObject
}
