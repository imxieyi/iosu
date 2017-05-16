//
//  StoryBoard.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class StoryBoard {
    
    public static var stdwidth:Double=640.0
    public static let stdheight:Double=480.0
    public static var actualwidth:Double = 0
    public static var actualheight:Double = 0
    public static var leftedge:Double = 0
    public static var before:Int=0
    public static var after:Int=0
    private var layer:Double
    private var bglayer:Double = 0
    private var passlayer:Double = 0
    private var faillayer:Double = 0
    private var fglayer:Double = 20000
    public var sbsprites:[BasicImage]=[]
    public var sbactions:[SKAction]=[]
    public var sbdirectory:String
    public var earliest = Int.max
    
    init(directory:String,osufile:String,width:Double,height:Double,layer:Double) throws {
        StoryBoard.before=0
        StoryBoard.after=0
        self.sbdirectory=directory
        StoryBoard.actualheight=height
        StoryBoard.actualwidth=height/StoryBoard.stdheight*StoryBoard.stdwidth
        StoryBoard.leftedge=(width-StoryBoard.actualwidth)/2
        debugPrint("actualh:\(StoryBoard.actualheight)")
        debugPrint("actualw:\(StoryBoard.actualwidth)")
        debugPrint("ledge:\(StoryBoard.leftedge)")
        self.layer=layer
        //osu file
        let readFile=FileHandle(forReadingAtPath: osufile)
        if readFile===nil{
            throw StoryBoardError.FileNotFound
        }
        let sbData=readFile?.readDataToEndOfFile()
        let sbString=String(data: sbData!, encoding: .utf8)
        let rawlines=sbString?.components(separatedBy: CharacterSet.newlines)
        var lines=ArraySlice<String>()
        for line in rawlines! {
            if line != "" {
                if !line.hasPrefix("//"){
                    lines.append(line)
                }
            }
        }
        //debugPrint("line count:\(lines?.count)")
        if lines.count==0{
            throw StoryBoardError.IllegalFormat
        }
        var index:Int
        index = -1
        for line in lines{
            index += 1
            switch line {
            case "[Events]":
                var digested=ArraySlice<String>()
                for aline in lines.suffix(from: index+1) {
                    if aline.hasPrefix("["){
                        break
                    }
                    digested.append(aline)
                }
                parseSBEvents(lines: digested)
                break
            default:
                continue
            }
        }
        sbsprites.sort(by: {(s1,s2) -> Bool in
            return s1.starttime<s2.starttime
        })
    }
    
    init(directory:String,osufile:String,osbfile:String,width:Double,height:Double,layer:Double) throws {
        StoryBoard.before=0
        StoryBoard.after=0
        self.sbdirectory=directory
        StoryBoard.actualheight=height
        StoryBoard.actualwidth=height/StoryBoard.stdheight*StoryBoard.stdwidth
        StoryBoard.leftedge=(width-StoryBoard.actualwidth)/2
        debugPrint("actualh:\(StoryBoard.actualheight)")
        debugPrint("actualw:\(StoryBoard.actualwidth)")
        debugPrint("ledge:\(StoryBoard.leftedge)")
        self.layer=layer
        //osu file
        var readFile=FileHandle(forReadingAtPath: osufile)
        if readFile===nil{
            throw StoryBoardError.FileNotFound
        }
        var sbData=readFile?.readDataToEndOfFile()
        var sbString=String(data: sbData!, encoding: .utf8)
        var rawlines=sbString?.components(separatedBy: CharacterSet.newlines)
        var lines=ArraySlice<String>()
        for line in rawlines! {
            if line != "" {
                if !line.hasPrefix("//"){
                    lines.append(line)
                }
            }
        }
        //debugPrint("line count:\(lines?.count)")
        if lines.count==0{
            throw StoryBoardError.IllegalFormat
        }
        var index:Int
        index = -1
        for line in lines{
            index += 1
            switch line {
            case "[Events]":
                var digested=ArraySlice<String>()
                for aline in lines.suffix(from: index+1) {
                    if aline.hasPrefix("["){
                        break
                    }
                    digested.append(aline)
                }
                parseSBEvents(lines: digested)
                break
            default:
                continue
            }
        }
        //osb file
        readFile=FileHandle(forReadingAtPath: osbfile)
        if readFile===nil{
            throw StoryBoardError.FileNotFound
        }
        sbData=readFile?.readDataToEndOfFile()
        sbString=String(data: sbData!, encoding: .utf8)
        rawlines=sbString?.components(separatedBy: CharacterSet.newlines)
        lines=ArraySlice<String>()
        for line in rawlines! {
            if line != "" {
                if !line.hasPrefix("//"){
                    lines.append(line)
                }
            }
        }
        //debugPrint("line count:\(lines?.count)")
        if lines.count==0{
            throw StoryBoardError.IllegalFormat
        }
        //var index:Int
        index = -1
        for line in lines{
            index += 1
            switch line {
            case "[Events]":
                parseSBEvents(lines: lines.suffix(from: index+1))
                break
            default:
                continue
            }
        }
        sbsprites.sort(by: {(s1,s2) -> Bool in
            return s1.starttime<s2.starttime
        })
        debugPrint("before schedule:\(StoryBoard.before) after:\(StoryBoard.after) reduce rate:\(Double(StoryBoard.before-StoryBoard.after)/Double(StoryBoard.before)*100)%")
    }
    
    //Convert StoryBoard x and y to screen x and y
    static public func conv(x:Double) -> Double {
        return leftedge+x/stdwidth*actualwidth
    }
    
    static public func conv(y:Double) -> Double {
        return actualheight-y/stdheight*actualheight
    }
    
    static public func conv(w:Double) -> Double {
        return w/stdwidth*actualwidth
    }
    
    static public func conv(h:Double) -> Double {
        return h/stdheight*actualheight
    }
    
    private func str2layer(str:String) -> SBLayer {
        switch str {
        case "Background":return .Background
        case "Fail":return .Fail
        case "Pass":return .Pass
        case "Foreground":return .Foreground
        default:return .Background
        }
    }
    
    private func str2origin(str:String) -> SBOrigin {
        switch str {
        case "TopLeft":return .TopLeft
        case "TopCentre":return .TopCentre
        case "TopRight":return .TopRight
        case "CentreLeft":return .CentreLeft
        case "Centre":return .Centre
        case "CentreRight":return .CentreRight
        case "BottomLeft":return .BottomLeft
        case "BottomCentre":return .BottomCentre
        case "BottomRight":return .BottomRight
        default:return .Centre
        }
    }
    
    private func parseSBEvents(lines:ArraySlice<String>) {
        var index:Int
        index = -1
        for line in lines{
            index += 1
            if line.hasPrefix("Sprite")||line.hasPrefix("Animation"){
                var slines=ArraySlice<String>()
                var sindex=index+1
                if lines[sindex].hasPrefix("Sprite")||lines[sindex].hasPrefix("Animation") {
                    sindex+=1
                }
                //debugPrint("first cmd:\(lines[sindex])")
                while sindex<lines.count{
                    //debugPrint("line: \(lines[sindex])")
                    if lines[sindex].hasPrefix(" ") || lines[sindex].hasPrefix("_") {
                        slines.append(lines[sindex])
                    }else{
                        break
                    }
                    sindex+=1
                }
                //debugPrint("cmd lines:\(slines.count)")
                let splitted=line.components(separatedBy: ",")
                var sprite:BasicImage
                switch splitted[0]{
                case "Sprite":
                    switch str2layer(str: splitted[1]) {
                    case .Background:
                        bglayer+=1
                        sprite=BasicImage(layer: .Background, rlayer:bglayer, origin: str2origin(str: splitted[2]), filepath: splitted[3], x: (splitted[4] as NSString).doubleValue, y: (splitted[5] as NSString).doubleValue)
                        break
                    case .Pass:
                        passlayer+=1
                        sprite=BasicImage(layer: .Background, rlayer:passlayer, origin: str2origin(str: splitted[2]), filepath: splitted[3], x: (splitted[4] as NSString).doubleValue, y: (splitted[5] as NSString).doubleValue)
                        break
                    case .Fail:
                        faillayer+=1
                        sprite=BasicImage(layer: .Background, rlayer:faillayer, origin: str2origin(str: splitted[2]), filepath: splitted[3], x: (splitted[4] as NSString).doubleValue, y: (splitted[5] as NSString).doubleValue)
                        break
                    case .Foreground:
                        fglayer+=1
                        sprite=BasicImage(layer: .Background, rlayer:fglayer, origin: str2origin(str: splitted[2]), filepath: splitted[3], x: (splitted[4] as NSString).doubleValue, y: (splitted[5] as NSString).doubleValue)
                        break
                    }
                    break
                case "Animation":
                    switch str2layer(str: splitted[1]) {
                    case .Background:
                        bglayer+=1
                        sprite=MovingImage(layer: .Background, rlayer:bglayer, origin: str2origin(str: splitted[2]), filepath: splitted[3], x: (splitted[4] as NSString).doubleValue, y: (splitted[5] as NSString).doubleValue, framecount: (splitted[6] as NSString).integerValue, framedelay: (splitted[7] as NSString).doubleValue, looptype: str2looptype(str: splitted[8]))
                        break
                    case .Pass:
                        passlayer+=1
                        sprite=MovingImage(layer: .Background, rlayer:passlayer, origin: str2origin(str: splitted[2]), filepath: splitted[3], x: (splitted[4] as NSString).doubleValue, y: (splitted[5] as NSString).doubleValue, framecount: (splitted[6] as NSString).integerValue, framedelay: (splitted[7] as NSString).doubleValue, looptype: str2looptype(str: splitted[8]))
                        break
                    case .Fail:
                        faillayer+=1
                        sprite=MovingImage(layer: .Background, rlayer:faillayer, origin: str2origin(str: splitted[2]), filepath: splitted[3], x: (splitted[4] as NSString).doubleValue, y: (splitted[5] as NSString).doubleValue, framecount: (splitted[6] as NSString).integerValue, framedelay: (splitted[7] as NSString).doubleValue, looptype: str2looptype(str: splitted[8]))
                        break
                    case .Foreground:
                        fglayer+=1
                        sprite=MovingImage(layer: .Background, rlayer:fglayer, origin: str2origin(str: splitted[2]), filepath: splitted[3], x: (splitted[4] as NSString).doubleValue, y: (splitted[5] as NSString).doubleValue, framecount: (splitted[6] as NSString).integerValue, framedelay: (splitted[7] as NSString).doubleValue, looptype: str2looptype(str: splitted[8]))
                        break
                    }
                default:
                    continue
                }
                if slines.count>0 {
                    sprite.commands=parseCommands(lines: slines,inloop: false)
                    sprite.gentime()
                    sprite.geninitials()
                    sprite.schedule()
                }
                sprite.filepath=(sprite.filepath as NSString).replacingOccurrences(of: "\\", with: "/")
                sprite.filepath=(sbdirectory as NSString).appending("/"+sprite.filepath)
                if(sprite.isanimation){
                    (sprite as! MovingImage).convertsprite()
                    (sprite as! MovingImage).animate()
                }else{
                    sprite.convertsprite()
                }
                //sprite.sprite=nil
                //debugPrint("number of commands:\(sprite.commands.count)")
                sbsprites.append(sprite)
            }
        }
    }
    
    private func str2looptype(str:String)->LoopType{
        switch str{
        case "LoopForever":return .LoopForever
        case "LoopOnce":return .LoopOnce
        default:return .LoopForever
        }
    }
    
    private func parseCommands(lines:ArraySlice<String>,inloop:Bool) -> [SBCommand] {
        var digested:[String]=[]
        for i in 0...(lines.count-1) {
            digested.append((lines[i] as NSString).substring(from: 1))
        }
        var commands:[SBCommand]=[]
        var index = -1
        for line in digested {
            index+=1
            //debugPrint("raw cmd:\(line)")
            var splitted=line.components(separatedBy: ",")
            if splitted.count<=1 {
                continue
            }
            /*if splitted[2].hasPrefix("-") {
             continue
             }*/
            if splitted[0] != "L" {
                if splitted[3]=="" {
                    splitted[3]=splitted[2]
                    for i in 4...(splitted.count-1) {
                        splitted.append(splitted[i])
                    }
                }
            }
            switch splitted[0] {
            case "F":
                if splitted.count==5 {
                    splitted.append(splitted[4])
                }
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                commands.append(SBFade(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startopacity: (splitted[4] as NSString).doubleValue, endopacity: (splitted[5] as NSString).doubleValue))
                break
            case "M":
                if splitted.count==6 {
                    splitted.append(splitted[4])
                    splitted.append(splitted[5])
                }
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                commands.append(SBMove(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startx: (splitted[4] as NSString).doubleValue, starty: (splitted[5] as NSString).doubleValue, endx: (splitted[6] as NSString).doubleValue, endy: (splitted[7] as NSString).doubleValue))
                break
            case "MX":
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                if splitted.count==5 {
                    splitted.append(splitted[4])
                }
                commands.append(SBMoveX(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startx: (splitted[4] as NSString).doubleValue, endx: (splitted[5] as NSString).doubleValue))
                break
            case "MY":
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                if splitted.count==5 {
                    splitted.append(splitted[4])
                }
                commands.append(SBMoveY(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, starty: (splitted[4] as NSString).doubleValue, endy: (splitted[5] as NSString).doubleValue))
                break
            case "S":
                if splitted.count==5{
                    splitted.append(splitted[4])
                }
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                commands.append(SBScale(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, starts: (splitted[4] as NSString).doubleValue, ends: (splitted[5] as NSString).doubleValue))
                break
            case "V":
                if splitted.count==6{
                    splitted.append(splitted[4])
                    splitted.append(splitted[5])
                }
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                commands.append(SBVScale(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startsx: (splitted[4] as NSString).doubleValue, startsy: (splitted[5] as NSString).doubleValue, endsx: (splitted[6] as NSString).doubleValue, endsy: (splitted[7] as NSString).doubleValue))
                break
            case "R":
                if splitted.count==5{
                    splitted.append(splitted[4])
                }
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                commands.append(SBRotate(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startr: (splitted[4] as NSString).doubleValue, endr: (splitted[5] as NSString).doubleValue))
                break
            case "C":
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                if splitted.count>=10 {
                    commands.append(SBColor(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startr: (splitted[4] as NSString).doubleValue, startg: (splitted[5] as NSString).doubleValue, startb: (splitted[6] as NSString).doubleValue, endr: (splitted[7] as NSString).doubleValue, endg: (splitted[8] as NSString).doubleValue, endb: (splitted[9] as NSString).doubleValue))
                }
                if splitted.count==7 {
                    let r=(splitted[4] as NSString).doubleValue
                    let g=(splitted[5] as NSString).doubleValue
                    let b=(splitted[6] as NSString).doubleValue
                    commands.append(SBColor(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startr: r, startg: g, startb: b, endr: r, endg: g, endb: b))
                }
                break
            case "P":
                if(!inloop) {
                    if (splitted[2] as NSString).integerValue<earliest {
                        earliest=(splitted[2] as NSString).integerValue
                    }
                }
                commands.append(SBParam(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, ptype: splitted[4]))
                break
            case "L":
                if(!inloop) {
                    if (splitted[1] as NSString).integerValue<earliest {
                        earliest=(splitted[1] as NSString).integerValue
                    }
                }
                var looplines=ArraySlice<String>()
                for i in index+1...digested.count-1 {
                    if digested[i].hasPrefix(" ") || digested[i].hasPrefix("_") {
                        looplines.append(digested[i])
                    } else {
                        break
                    }
                }
                let loop=SBLoop(starttime: (splitted[1] as NSString).integerValue, loopcount: (splitted[2] as NSString).integerValue)
                loop.commands=parseCommands(lines: looplines,inloop: true)
                loop.genendtime()
                commands.append(loop)
                break
            case "T":
                //TODO: Parse trigger
                continue
            default:
                continue
            }
        }
        return commands
    }
    
}
