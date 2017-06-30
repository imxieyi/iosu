//
//  Difficulty.swift
//  iosu
//
//  Created by xieyi on 2017/5/9.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class BMDifficulty {
    
    fileprivate let ARFuncA:Double = -120
    fileprivate let ARFuncB:Double = 1800
    fileprivate let S300FuncA:Double = -6
    fileprivate let S300FuncB:Double = 79.5
    fileprivate let S100FuncA:Double = -8
    fileprivate let S100FuncB:Double = 139.5
    fileprivate let S50FuncA:Double = -10
    fileprivate let S50FuncB:Double = 199.5
    
    fileprivate let HPDrainRate:Double
    fileprivate let CircleSize:Double
    fileprivate let OverallDifficulty:Double
    fileprivate let ApproachRate:Double
    open let SliderMultiplier:Double
    open let SliderTickRate:Double
    
    open let AbsoluteCS:Double
    
    open let ARTime:Double
    open let Score300:Double
    open let Score100:Double
    open let Score50:Double
    
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
