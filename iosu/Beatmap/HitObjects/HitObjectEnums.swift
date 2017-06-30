//
//  HitObjectEnums.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

enum HitSound {
    case normal     //0
    case whistle    //2
    case finish     //4
    case clap       //8
}

enum HitObjectType{
    case circle
    case slider
    case spinner
    case none //Unknown hitobject type
}

enum CircleType{
    case plain
    case sliderHead
    case sliderEnd
    case sliderArrow
}

enum SliderType{
    case linear //L
    case passThrough //P
    case bezier //B
    case catmull //C
    case none //Invalid slider type
}
