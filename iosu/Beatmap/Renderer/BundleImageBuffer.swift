//
//  BundleImageBuffer.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class BundleImageBuffer{
    
    static var buffer=[String:SKTexture]()
    
    static func addtobuffer(file:String) {
        if buffer[file] != nil {
            return
        }
        let texture=SKTexture(imageNamed: file)
        buffer[file]=texture
    }
    
    static func get(file:String) -> SKTexture? {
        addtobuffer(file: file)
        if buffer[file] != nil {
            return buffer[file]!
        }
        return nil
    }
    
}
