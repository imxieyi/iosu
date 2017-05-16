//
//  BeatmapEnums.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

enum SampleSet {
    case Auto
    case Normal
    case Soft
    case Drum
}

enum BeatmapError:Error{
    case FileNotFound
    case IllegalFormat
    case NoAudioFile
    case NoTimingPoints
    case AudioFileNotExist
    case NoColor
    case NoHitObject
}
