//
//  HitObjectAction.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

protocol HitObjectAction {
    func prepare(color:UIColor,number:Int,layer:CGFloat)
    //Time in ms
    func gettime() -> Double
    func show(scene:SKScene,offset:Double)
    func getobj() -> HitObject
    func destroy()
}
