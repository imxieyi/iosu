//
//  StoryBoard.swift
//  iosu
//
//  Created by xieyi on 2017/4/2.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift

class StoryBoard {
    
    private static let stdwidth=640.0
    private static let stdheight=480.0
    public static var actualwidth:Double = 0
    public static var actualheight:Double = 0
    public static var leftedge:Double = 0
    private var layer:Double
    private var bglayer:Double = 0
    private var passlayer:Double = 0
    private var faillayer:Double = 0
    private var fglayer:Double = 20000
    public var sbsprites:[BasicImage]=[]
    public var sbactions:[SKAction]=[]
    public var sbdirectory:String
    public var earliest=Int.max
    
    init(directory:String,osufile:String,width:Double,height:Double,layer:Double) throws {
        self.sbdirectory=directory
        StoryBoard.actualheight=height
        StoryBoard.actualwidth=height/StoryBoard.stdheight*StoryBoard.stdwidth
        StoryBoard.leftedge=(width-StoryBoard.actualwidth)/2
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
        self.sbdirectory=directory
        StoryBoard.actualheight=height
        StoryBoard.actualwidth=height/StoryBoard.stdheight*StoryBoard.stdwidth
        StoryBoard.leftedge=(width-StoryBoard.actualwidth)/2
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
            if line.hasPrefix("Sprite"){
                var slines=ArraySlice<String>()
                var sindex=index+1
                if lines[sindex].hasPrefix("Sprite")||lines[sindex].hasPrefix("Animation") {
                    sindex+=1
                }
                //debugPrint("first cmd:\(lines[sindex])")
                while sindex<=lines.count{
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
                if slines.count>0 {
                    sprite.commands=parseCommands(lines: slines)
                    sprite.gentime()
                    sprite.genaction()
                }
                sprite.filepath=(sprite.filepath as NSString).replacingOccurrences(of: "\\", with: "/")
                sprite.filepath=(sbdirectory as NSString).appending("/"+sprite.filepath)
                //sprite.convertsprite()
                //sprite.sprite=nil
                //debugPrint("number of commands:\(sprite.commands.count)")
                sbsprites.append(sprite)
            }
        }
    }
    
    private func parseCommands(lines:ArraySlice<String>) -> [SBCommand] {
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
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
                }
                commands.append(SBFade(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startopacity: (splitted[4] as NSString).doubleValue, endopacity: (splitted[5] as NSString).doubleValue))
                break
            case "M":
                if splitted.count==6 {
                    splitted.append(splitted[4])
                    splitted.append(splitted[5])
                }
                //debugPrint("\(splitted[2])")
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
                }
                commands.append(SBMove(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startx: (splitted[4] as NSString).doubleValue, starty: (splitted[5] as NSString).doubleValue, endx: (splitted[6] as NSString).doubleValue, endy: (splitted[7] as NSString).doubleValue))
                break
            case "MX":
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
                }
                if splitted.count==5 {
                    splitted.append(splitted[4])
                }
                commands.append(SBMoveX(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startx: (splitted[4] as NSString).doubleValue, endx: (splitted[5] as NSString).doubleValue))
                break
            case "MY":
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
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
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
                }
                commands.append(SBScale(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, starts: (splitted[4] as NSString).doubleValue, ends: (splitted[5] as NSString).doubleValue))
                break
            case "V":
                if splitted.count==6{
                    splitted.append(splitted[4])
                    splitted.append(splitted[5])
                }
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
                }
                commands.append(SBVScale(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startsx: (splitted[4] as NSString).doubleValue, startsy: (splitted[5] as NSString).doubleValue, endsx: (splitted[6] as NSString).doubleValue, endsy: (splitted[7] as NSString).doubleValue))
                break
            case "R":
                if splitted.count==5{
                    splitted.append(splitted[4])
                }
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
                }
                commands.append(SBRotate(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startr: (splitted[4] as NSString).doubleValue, endr: (splitted[5] as NSString).doubleValue))
                break
            case "C":
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
                }
                if splitted.count==10 {
                    commands.append(SBColor(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startr: (splitted[4] as NSString).doubleValue, startg: (splitted[5] as NSString).doubleValue, startb: (splitted[6] as NSString).doubleValue, endr: (splitted[7] as NSString).doubleValue, endg: (splitted[8] as NSString).doubleValue, endb: (splitted[9] as NSString).doubleValue))
                }
                if splitted.count==7 {
                    /*let r=Double(Int(splitted[4],radix:16)!)
                    let g=Double(Int(splitted[5],radix:16)!)
                    let b=Double(Int(splitted[6],radix:16)!)*/
                    let r=(splitted[4] as NSString).doubleValue
                    let g=(splitted[5] as NSString).doubleValue
                    let b=(splitted[6] as NSString).doubleValue
                    commands.append(SBColor(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, startr: r, startg: g, startb: b, endr: r, endg: g, endb: b))
                }
                break
            case "P":
                if (splitted[2] as NSString).integerValue<earliest {
                    earliest=(splitted[2] as NSString).integerValue
                }
                commands.append(SBParam(easing: (splitted[1] as NSString).integerValue, starttime: (splitted[2] as NSString).integerValue, endtime: (splitted[3] as NSString).integerValue, ptype: splitted[4]))
                break
            case "L":
                if (splitted[1] as NSString).integerValue<earliest {
                    earliest=(splitted[1] as NSString).integerValue
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
                loop.commands=parseCommands(lines: looplines)
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


//Significantly optimize memory usage and framerate
class ImageBuffer{
    
    static var buffer=[String:SKTexture]()
    
    static func addtobuffer(file:String) {
        if buffer[file] != nil {
            return
        }
        let image=UIImage(contentsOfFile: file)
        if image==nil {
            debugPrint("image not found: \(file)")
            return
        }
        let texture=SKTexture(image: image!)
        buffer[file]=texture
    }
    
    static func get(file:String) ->SKTexture {
        addtobuffer(file: file)
        if buffer[file] != nil {
            return buffer[file]!
        }
        return SKTexture()
    }
    
}

class BasicImage {
    
    var layer:SBLayer
    var rlayer:Double
    var origin:SBOrigin
    var filepath:String
    var x:Double
    var y:Double
    var commands:[SBCommand]=[]
    var starttime=0
    var endtime=0
    var sprite:SKSpriteNode?
    var actions:SKAction?
    
    init(layer:SBLayer,rlayer:Double,origin:SBOrigin,filepath:String,x:Double,y:Double) {
        self.layer=layer
        self.rlayer=rlayer
        self.origin=origin
        self.filepath=filepath
        while self.filepath.hasPrefix("\"") {
            self.filepath=(self.filepath as NSString).substring(from: 1)
        }
        while self.filepath.hasSuffix("\"") {
            self.filepath=(self.filepath as NSString).substring(to: self.filepath.lengthOfBytes(using: .ascii)-1)
        }
        self.x=x
        self.y=y
    }
    
    func gentime() {
        starttime=Int.max
        endtime=Int.min
        for cmd in commands {
            if starttime>cmd.starttime {
                starttime=cmd.starttime
            }
            if endtime<cmd.endtime {
                endtime=cmd.endtime
            }
        }
    }
    
    func convertsprite(){
        sprite=SKSpriteNode(texture: ImageBuffer.get(file: filepath))
        //let scale=Double((image?.size.height)!/1080)*StoryBoard.actualheight
        //sprite?.size=CGSize(width: Double((image?.size.width)!)*scale, height: Double((image?.size.height)!)*scale)
        sprite?.zPosition=CGFloat(rlayer)
        sprite?.position=CGPoint(x: StoryBoard.conv(x: x), y: StoryBoard.conv(y: y))
        sprite?.blendMode = .alpha
        sprite?.color = .white
        sprite?.colorBlendFactor=1.0
        sprite?.alpha=0
        switch origin {
        case .TopLeft:
            sprite?.anchorPoint=CGPoint(x: 0, y: 1)
            break
        case .TopCentre:
            sprite?.anchorPoint=CGPoint(x: 0.5, y: 1)
            break
        case .TopRight:
            sprite?.anchorPoint=CGPoint(x: 1, y: 1)
            break
        case .CentreLeft:
            sprite?.anchorPoint=CGPoint(x: 0, y: 0.5)
            break
        case .Centre:
            sprite?.anchorPoint=CGPoint(x: 0.5, y: 0.5)
            break
        case .CentreRight:
            sprite?.anchorPoint=CGPoint(x: 1, y: 0.5)
            break
        case .BottomLeft:
            sprite?.anchorPoint=CGPoint(x: 0, y: 0)
            break
        case .BottomCentre:
            sprite?.anchorPoint=CGPoint(x: 0.5, y: 0)
            break
        case .BottomRight:
            sprite?.anchorPoint=CGPoint(x: 1, y: 0)
            break
        }
    }
    
    func genaction(){
        var action:[SKAction]=[]
        for cmd in commands {
            //cmd.sprite=self.sprite
            //debugPrint("after: \(cmd.starttime-self.starttime)")
            action.append(SKAction.sequence([SKAction.wait(forDuration: Double(cmd.starttime-self.starttime)/1000),(cmd as! SBCAction).toAction()]))
        }
        self.actions=SKAction.group(action)
    }
    
    func runaction(offset:Int){
        var acts:[SKAction]=[SKAction.wait(forDuration: Double(offset)/1000)]
        acts.append(SKAction.customAction(withDuration: 0, actionBlock: {(node:SKNode,time:CGFloat)->Void in
            node.alpha=1
        }))
        sprite?.run(SKAction.sequence([SKAction.sequence(acts),self.actions!]),completion:{ ()->Void in
            self.sprite?.removeFromParent()
            self.sprite=nil
            self.commands=[]
            self.actions=nil
        })
    }
    
}

class MovingImage:BasicImage {
    
    var framecount:Int
    var framerate:Int
    var looptype:LoopType
    
    init(layer:SBLayer,rlayer:Double,origin:SBOrigin,filepath:String,x:Double,y:Double,framecount:Int,framerate:Int,looptype:LoopType) {
        self.framecount=framecount
        self.framerate=framerate
        self.looptype=looptype
        super.init(layer: layer, rlayer: rlayer, origin: origin, filepath: filepath, x: x, y: y)
    }
    
}

enum StoryBoardError:Error {
    case FileNotFound
    case IllegalFormat
}

enum SBLayer {
    case Background
    case Fail
    case Pass
    case Foreground
}

enum SBOrigin {
    case TopLeft
    case TopCentre
    case TopRight
    case CentreLeft
    case Centre
    case CentreRight
    case BottomLeft
    case BottomCentre
    case BottomRight
}

enum LoopType {
    case LoopForever
    case LoopOnce
}

enum StoryBoardCommand {
    case Fade
    case Move
    case MoveX
    case MoveY
    case Scale
    case VScale //x and y scale differently
    case Rotate
    case Color
    case Parameter
    case Loop
    case Trigger
    case Unknown
}
