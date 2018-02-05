//
//  ImageBuffer.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

//Significantly optimize memory usage and framerate
class ImageBuffer{
    
    static var buffer=[String:SKTexture]()
    static var notfoundimages=Set<String>()
    
    static func addtobuffer(_ file:String) {
        if buffer[file] != nil {
            return
        }
        var image=UIImage(contentsOfFile: file)
        if image==nil {
            debugPrint("image not found: \(file)")
            debugPrint("Trying to fix")
            image=UIImage(contentsOfFile: file.replacingOccurrences(of: "/sb/", with: "/SB/"))
            if image==nil {
                image=UIImage(contentsOfFile: file.replacingOccurrences(of: "/SB/", with: "/sb/"))
                if image==nil {
                    debugPrint("Failed.")
                    notfoundimages.insert(file)
                    return
                }
            }
        }
        let texture=SKTexture(image: image!)
        buffer[file]=texture
    }
    
    static func notfound2str() -> String {
        var str="Cannot find following images:\n"
        for line in notfoundimages {
            str+=line+"\n"
        }
        return str
    }
    
    static func get(_ file:String) ->SKTexture? {
        addtobuffer(file)
        if buffer[file] != nil {
            return buffer[file]!
        }
        return nil
        //return SKTexture()
    }
    
    static func clean() {
        buffer.removeAll()
        notfoundimages.removeAll()
    }
    
}
