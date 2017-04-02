//
//  BeatmapProcessor.swift
//  iosu
//
//  Created by xieyi on 2017/3/30.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class BeatmapScanner{
    
    //var docPath:NSString
    public var beatmapdirs:[String]=[]
    public var beatmaps:[String]=[]
    public var storyboards=[String:String]()
    public var dirscontainsb:[String]=[]
    
    init() {
        //let home=NSHomeDirectory() as NSString
        //docPath=home.strings(byAppendingPaths: "Documents")
        let manager=FileManager.default
        let docURL=manager.urls(for: .documentDirectory, in: .userDomainMask)
        let url=docURL[0] as URL
        let contentsOfPath=try? manager.contentsOfDirectory(atPath: url.path)
        for entry in contentsOfPath!{
            //debugPrint("folder:\(entry)")
            let contentsOfBMPath=try? manager.contentsOfDirectory(atPath: url.appendingPathComponent(entry).path)
            for subentry in contentsOfBMPath!{
                //debugPrint("       \(subentry)")
                if subentry.hasSuffix(".osu"){
                    let fullpath=url.appendingPathComponent(entry, isDirectory: true)
                    beatmapdirs.append(fullpath.path)
                    //fullpath=fullpath.appendingPathComponent(subentry, isDirectory: false)
                    //beatmaps.append(fullpath.path)
                    beatmaps.append(subentry)
                }
                if subentry.hasSuffix(".osb"){
                    let fullpath=url.appendingPathComponent(entry, isDirectory: true)
                    //beatmapdirs.append(fullpath.path)
                    //fullpath=fullpath.appendingPathComponent(subentry, isDirectory: false)
                    //beatmaps.append(fullpath.path)
                    dirscontainsb.append(fullpath.path)
                    storyboards.updateValue(subentry, forKey: fullpath.path)
                }
            }
        }
    }
    
    func count()->Int{
        return beatmaps.count
    }
    
    func get(index:Int)->String{
        return beatmaps[index]
    }
    
}
