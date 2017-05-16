//
//  TimingPoint.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class TimingPoint {
    
    var offset:Int
    var timeperbeat:Double //In milliseconds
    var beattype:Int //3:3/3,4:4/4
    var sampleset:SampleSet
    var samplesetid:Int //0 for default
    var volume:Int //0~100
    var inherited:Bool
    var kiai:Bool //Climax of the song
    
    init(offset:Int,timeperbeat:Double,beattype:Int,sampleset:SampleSet,samplesetid:Int,volume:Int,inherited:Bool,kiai:Bool) {
        self.offset=offset
        self.timeperbeat=timeperbeat
        self.beattype=beattype
        self.sampleset=sampleset
        self.samplesetid=samplesetid
        self.volume=volume
        self.inherited=inherited
        self.kiai=kiai
    }
    
}
