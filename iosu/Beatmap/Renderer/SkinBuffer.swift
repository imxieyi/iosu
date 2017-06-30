//
//  SkinHelper.swift
//  iosu
//
//  Created by xieyi on 2017/6/29.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class SkinBuffer {
    
    open static var useSkin = true
    open static var bmPath = ""
    
    fileprivate static var buffer=[String:SKTexture]()
    fileprivate static var skinflag=[String:Bool]()
    
    fileprivate static func add(_ file: String) {
        if buffer[file] != nil {
            return
        }
        debugPrint("finding \(file)")
        if useSkin {
            let image=UIImage(contentsOfFile: (bmPath as NSString).appendingPathComponent(file.appending(".png")))
            if image != nil {
                debugPrint("\((bmPath as NSString).appendingPathComponent(file.appending(".png")))")
                let texture=SKTexture(image: image!)
                buffer[file]=texture
                skinflag[file]=true
                return
            }
        }
        let texture=SKTexture(imageNamed: file)
        buffer[file]=texture
        skinflag[file]=false
    }
    
    open static func get(_ file: String) -> SKTexture? {
        add(file)
        if buffer[file] != nil {
            return buffer[file]!
        }
        return nil
    }
    
    open static func getimg(_ file: String) -> UIImage? {
        add(file)
        if buffer[file] != nil {
            return UIImage(cgImage: (buffer[file]?.cgImage())!)
        }
        return nil
    }
    
    open static func getFlag(_ file: String) -> Bool {
        return skinflag[file]!
    }
    
}
