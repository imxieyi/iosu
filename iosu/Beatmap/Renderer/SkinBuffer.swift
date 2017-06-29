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
    
    public static var useSkin = true
    public static var bmPath = ""
    
    private static var buffer=[String:SKTexture]()
    private static var skinflag=[String:Bool]()
    
    private static func add(file: String) {
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
    
    public static func get(file: String) -> SKTexture? {
        add(file: file)
        if buffer[file] != nil {
            return buffer[file]!
        }
        return nil
    }
    
    public static func getimg(file: String) -> UIImage? {
        add(file: file)
        if buffer[file] != nil {
            return UIImage(cgImage: (buffer[file]?.cgImage())!)
        }
        return nil
    }
    
    public static func getFlag(file: String) -> Bool {
        return skinflag[file]!
    }
    
}
