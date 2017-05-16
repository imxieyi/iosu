//
//  HitObjectEnums.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

enum HitSound {
    case Normal     //0
    case Whistle    //2
    case Finish     //4
    case Clap       //8
}

enum HitObjectType{
    case Circle
    case Slider
    case Spinner
    case None //Unknown hitobject type
}

enum CircleType{
    case Plain
    case SliderHead
    case SliderEnd
    case SliderArrow
}

enum SliderType{
    case Linear //L
    case PassThrough //P
    case Bezier //B
    case Catmull //C
    case None //Invalid slider type
}
