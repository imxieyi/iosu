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
    private static var actualwidth:Double = 0
    private static var actualheight:Double = 0
    private static var leftedge:Double = 0
    private var layer:Double
    public var sbactions:[SKAction]=[]
    
    init(file:String,width:Double,height:Double,layer:Double) throws {
        StoryBoard.actualheight=height
        StoryBoard.actualwidth=height/StoryBoard.stdheight*StoryBoard.stdwidth
        StoryBoard.leftedge=(width-StoryBoard.actualwidth)/2
        self.layer=layer
        let readFile=FileHandle(forReadingAtPath: file)
        if readFile===nil{
            throw StoryBoardError.FileNotFound
        }
        let bmData=readFile?.readDataToEndOfFile()
        let bmString=String(data: bmData!, encoding: .utf8)
        let lines=bmString?.components(separatedBy: CharacterSet.newlines)
        if lines?.count==0{
            throw StoryBoardError.IllegalFormat
        }
        var index:Int
        index = -1
        for line in lines!{
            index += 1
            switch line {
            case "[Events]":
                parseSBEvents(lines: (lines?.suffix(from: index+1))!)
                break
            default:
                continue
            }
        }
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
    
    private func parseSBEvents(lines:ArraySlice<String>) {
        for line in lines{
            if line.hasPrefix("//"){
                continue
            }
            if line.hasPrefix("Sprite"){
                
            }
        }
    }
    
}

class BasicImage {
    
    var layer:SBLayer
    var origin:SBOrigin
    var filepath:String
    var x:Double
    var y:Double
    
    init(layer:SBLayer,origin:SBOrigin,filepath:String,x:Double,y:Double) {
        self.layer=layer
        self.origin=origin
        self.filepath=filepath
        self.x=x
        self.y=y
    }
    
}

class MovingImage:BasicImage {
    
    var framecount:Int
    var framerate:Int
    var looptype:LoopType
    
    init(layer:SBLayer,origin:SBOrigin,filepath:String,x:Double,y:Double,framecount:Int,framerate:Int,looptype:LoopType) {
        self.framecount=framecount
        self.framerate=framerate
        self.looptype=looptype
        super.init(layer: layer, origin: origin, filepath: filepath, x: x, y: y)
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
