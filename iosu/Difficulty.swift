//
//  Difficulty.swift
//  iosu
//
//  Created by xieyi on 2017/5/9.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class BMDifficulty {
    
    private let ARFuncA:Double = -120
    private let ARFuncB:Double = 1800
    private let S300FuncA:Double = -6
    private let S300FuncB:Double = 79.5
    private let S100FuncA:Double = -8
    private let S100FuncB:Double = 139.5
    private let S50FuncA:Double = -10
    private let S50FuncB:Double = 199.5
    
    private let HPDrainRate:Double
    private let CircleSize:Double
    private let OverallDifficulty:Double
    private let ApproachRate:Double
    public let SliderMultiplier:Double
    public let SliderTickRate:Double
    
    public let AbsoluteCS:Double
    
    public let ARTime:Double
    public let Score300:Double
    public let Score100:Double
    public let Score50:Double
    
    init(HP:Double,CS:Double,OD:Double,AR:Double,SM:Double,ST:Double) {
        HPDrainRate=HP
        CircleSize=CS
        OverallDifficulty=OD
        ApproachRate=AR
        SliderMultiplier=SM
        SliderTickRate=ST
        ARTime=ARFuncB+ARFuncA*AR
        Score300=S300FuncB+S300FuncA*OD
        Score100=S100FuncB+S100FuncA*OD
        Score50=S50FuncB+S50FuncA*OD
        AbsoluteCS=GamePlayScene.conv(w: 108.848-CS*8.9646)
    }
    
}
