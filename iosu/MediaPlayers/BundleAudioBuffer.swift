//
//  BundleAudioBuffer.swift
//  iosu
//
//  Created by 谢宜 on 2017/6/21.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class BundleAudioBuffer{
    
    static var buffer=[String:Data]()
    
    static func addtobuffer(_ file:String) {
        if buffer[file] != nil {
            return
        }
        
        let nameOnly = (file as NSString).deletingPathExtension
        let fileExt  = (file as NSString).pathExtension
        
        let soundPath = Bundle.main.url(forResource: nameOnly, withExtension: fileExt)
        let audio = try! Data(contentsOf: soundPath!)
        buffer[file]=audio as Data?
    }
    
    static func get(_ file:String) -> Data? {
        addtobuffer(file)
        if buffer[file] != nil {
            return buffer[file]!
        }
        return nil
    }
    
}
