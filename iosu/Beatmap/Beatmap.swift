//
//  BeatmapDecoder.swift
//  iosu
//
//  Created by xieyi on 2017/3/30.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import UIKit

class Beatmap{
    
    open var bgimg:String = ""
    open var audiofile:String = ""
    open var difficulty:BMDifficulty?
    open var timingpoints:[TimingPoint] = []
    open var colors:[UIColor] = []
    open var hitobjects:[HitObject] = []
    open var sampleSet:SampleSet = .auto //Set of audios
    open var bgvideos:[BGVideo]=[]
    open var widesb=false
    //For sliders
    open var bordercolor = UIColor.white
    open var trackcolor = UIColor.clear
    open var trackoverride = false
    
    init(file:String) throws {
        debugPrint("full path: \(file)")
        let readFile=FileHandle(forReadingAtPath: file)
        if readFile===nil{
            throw BeatmapError.fileNotFound
        }
        let bmData=readFile?.readDataToEndOfFile()
        let bmString=String(data: bmData!, encoding: .utf8)
        let rawlines=bmString?.components(separatedBy: CharacterSet.newlines)
        if rawlines?.count==0{
            throw BeatmapError.illegalFormat
        }
        var lines=ArraySlice<String>()
        for line in rawlines! {
            if line != "" {
                if !line.hasPrefix("//"){
                    lines.append(line)
                }
            }
        }
        var index:Int
        index = -1
        for line in lines{
            index += 1
            switch line {
            case "[General]":
                try parseGeneral(lines.suffix(from: index+1))
                break
            case "[Difficulty]":
                parseDifficulty(lines.suffix(from: index+1))
                break
            case "[Events]":
                parseEvents(lines.suffix(from: index+1))
                break
            case "[TimingPoints]":
                try parseTimingPoints(lines.suffix(from: index+1))
                break
            case "[Colours]":
                try parseColors(lines.suffix(from: index+1))
                break
            case "[HitObjects]":
                try parseHitObjects(lines.suffix(from: index+1))
                break
            default:
                continue
            }
        }
        bgvideos.sort(by: {(v1,v2)->Bool in
            return v1.time<v2.time
        })
    }
    
    func getTimingPoint(_ offset:Int) -> TimingPoint {
        for i in (0...timingpoints.count-1).reversed() {
            if timingpoints[i].offset <= offset {
                return timingpoints[i]
            }
        }
        return timingpoints[0]
    }
 
    func parseGeneral(_ lines:ArraySlice<String>) throws -> Void {
        for line in lines{
            if line.hasPrefix("["){
                if(audiofile==""){
                    throw BeatmapError.noAudioFile
                }
                return
            }
            let splitted=line.components(separatedBy: ":")
            if splitted.count<=1{
                continue
            }
            var value=splitted[1] as NSString
            while value.substring(to: 1)==" "{
                value=value.substring(from: 1) as NSString
            }
            if value.length==0{
                throw BeatmapError.noAudioFile
            }
            switch splitted[0] {
            case "AudioFilename":
                audiofile=value as String
                break
            case "SampleSet":
                sampleSet=samplesetConv(value as String)
                break
            case "WidescreenStoryboard":
                if (value as NSString).integerValue==1 {
                    debugPrint("Widescreen Storyboard enabled")
                    widesb=true
                }
                break
            default:break
            }
        }
    }
    
    func samplesetConv(_ str:String) -> SampleSet {
        switch str {
        case "Normal":
            return .normal
        case "Soft":
            return .soft
        case "Drum":
            return .drum
        default:
            return .auto
        }
    }
    
    func parseDifficulty(_ lines:ArraySlice<String>) -> Void {
        var hp:Double = -1
        var cs:Double = -1
        var od:Double = 5
        var ar:Double = -1
        var sm:Double = 1.4
        var st:Double = 1
        for line in lines{
            if line.hasPrefix("["){
                if(hp == -1){
                    hp=od
                }
                if(cs == -1){
                    cs=od
                }
                if(ar == -1){
                    ar=od
                }
                difficulty=BMDifficulty(HP: hp, CS: cs, OD: od, AR: ar, SM: sm, ST: st)
                return
            }
            let splitted=line.components(separatedBy: ":")
            if splitted.count != 2 {
                continue
            }
            let value=(splitted[1] as NSString).doubleValue
            switch splitted[0] {
            case "HPDrainRate":
                hp=value
                break
            case "CircleSize":
                cs=value
                break
            case "OverallDifficulty":
                od=value
                break
            case "ApproachRate":
                ar=value
                break
            case "SliderMultiplier":
                sm=value
                break
            case "SliderTickRate":
                st=value
                break
            default:
                break
            }
        }
        if(hp == -1){
            hp=od
        }
        if(cs == -1){
            cs=od
        }
        if(ar == -1){
            ar=od
        }
        difficulty=BMDifficulty(HP: hp, CS: cs, OD: od, AR: ar, SM: sm, ST: st)
    }
    
    func parseEvents(_ lines:ArraySlice<String>) -> Void {
        for line in lines {
            if line.hasPrefix("[") {
                return
            }
            if line.hasPrefix("Video") {
                let splitted=line.components(separatedBy: ",")
                var vstr=splitted[2]
                vstr=(vstr as NSString).replacingOccurrences(of: "\\", with: "/")
                while vstr.hasPrefix("\"") {
                    vstr=(vstr as NSString).substring(from: 1)
                }
                while vstr.hasSuffix("\"") {
                    vstr=(vstr as NSString).substring(to: vstr.lengthOfBytes(using: .ascii)-1)
                }
                bgvideos.append(BGVideo(file: vstr, time: (splitted[1] as NSString).integerValue))
                debugPrint("find video \(vstr) with offset \(String(describing: bgvideos.last?.time))")
            } else {
                let splitted=line.components(separatedBy: ",")
                if splitted.count>=3 {
                    switch splitted[0] {
                    case "0":
                        var vstr=splitted[2]
                        vstr=(vstr as NSString).replacingOccurrences(of: "\\", with: "/")
                        while vstr.hasPrefix("\"") {
                            vstr=(vstr as NSString).substring(from: 1)
                        }
                        while vstr.hasSuffix("\"") {
                            vstr=(vstr as NSString).substring(to: vstr.lengthOfBytes(using: .ascii)-1)
                        }
                        bgimg=vstr
                        break
                    case "1":
                        var vstr=splitted[2]
                        vstr=(vstr as NSString).replacingOccurrences(of: "\\", with: "/")
                        while vstr.hasPrefix("\"") {
                            vstr=(vstr as NSString).substring(from: 1)
                        }
                        while vstr.hasSuffix("\"") {
                            vstr=(vstr as NSString).substring(to: vstr.lengthOfBytes(using: .ascii)-1)
                        }
                        bgvideos.append(BGVideo(file: vstr, time: (splitted[1] as NSString).integerValue))
                        break
                    default:
                        continue
                    }
                }
            }
        }
    }
    
    func parseTimingPoints(_ lines:ArraySlice<String>) throws -> Void {
        var lasttimeperbeat:Double = 0
        for line in lines{
            if line.hasPrefix("["){
                if(timingpoints.count==0){
                    throw BeatmapError.noTimingPoints
                }
                return
            }
            var splitted=line.components(separatedBy: ",")
            if splitted.count<8 {
                if splitted.count==6 {
                    splitted.append("1")
                    splitted.append("0")
                } else if splitted.count==7 {
                    splitted.append("0")
                } else {
                    continue
                }
            }
            if splitted[6]=="1" { //Not inherited
                let offset=(splitted[0] as NSString).integerValue
                let timeperbeat=(splitted[1] as NSString).doubleValue
                let meter=(splitted[2] as NSString).integerValue
                let sampleset=samplesetConv(splitted[3])
                let samplesetid=(splitted[4] as NSString).integerValue
                let volume=(splitted[5] as NSString).integerValue
                let kiai=((splitted[7] as NSString).integerValue == 1)
                timingpoints.append(TimingPoint(offset: offset, timeperbeat: timeperbeat, beattype: meter, sampleset: sampleset, samplesetid: samplesetid, volume: volume, inherited: false, kiai: kiai))
                lasttimeperbeat=timeperbeat
            }else{ //Inherited
                let offset=(splitted[0] as NSString).integerValue
                let timeperbeat=(splitted[1] as NSString).doubleValue
                let meter=(splitted[2] as NSString).integerValue
                let sampleset=samplesetConv(splitted[3])
                let samplesetid=(splitted[4] as NSString).integerValue
                let volume=(splitted[5] as NSString).integerValue
                let kiai=((splitted[7] as NSString).integerValue == 1)
                timingpoints.append(TimingPoint(offset: offset, timeperbeat: lasttimeperbeat*abs(timeperbeat/100), beattype: meter, sampleset: sampleset, samplesetid: samplesetid, volume: volume, inherited: true, kiai: kiai))
            }
        }
    }
    
    func parseColors(_ lines:ArraySlice<String>) throws -> Void{
        for line in lines{
            if line.hasPrefix("["){
                if(colors.count==0){
                    throw BeatmapError.noColor
                }
                return
            }
            let splitted=line.components(separatedBy: ":")
            if splitted.count==0{
                continue
            }
            if splitted[0].hasPrefix("Combo"){
                let dsplitted=splitted[1].components(separatedBy: ",")
                if dsplitted.count != 3{
                    throw BeatmapError.illegalFormat
                }
                colors.append(UIColor(red: CGFloat((dsplitted[0] as NSString).floatValue/255), green: CGFloat((dsplitted[1] as NSString).floatValue/255), blue: CGFloat((dsplitted[2] as NSString).floatValue/255), alpha: 1.0))
            }
            if splitted[0].hasPrefix("SliderBorder") {
                let dsplitted=splitted[1].components(separatedBy: ",")
                if dsplitted.count == 3 {
                    bordercolor = UIColor(red: CGFloat((dsplitted[0] as NSString).floatValue/255), green: CGFloat((dsplitted[1] as NSString).floatValue/255), blue: CGFloat((dsplitted[2] as NSString).floatValue/255), alpha: 1.0)
                }
            }
            if splitted[0].hasPrefix("SliderTrackOverride") {
                let dsplitted=splitted[1].components(separatedBy: ",")
                if dsplitted.count == 3 {
                    trackoverride = true
                    trackcolor = UIColor(red: CGFloat((dsplitted[0] as NSString).floatValue/255), green: CGFloat((dsplitted[1] as NSString).floatValue/255), blue: CGFloat((dsplitted[2] as NSString).floatValue/255), alpha: 1.0)
                }
            }
        }
    }
    
    func parseHitObjects(_ lines:ArraySlice<String>) throws -> Void {
        var newcombo=true
        for line in lines{
            if line.hasPrefix("["){
                if(hitobjects.count==0){
                    throw BeatmapError.noHitObject
                }
                return
            }
            let splitted=line.components(separatedBy: ",")
            //debugPrint("\(splitted.count)")
            if splitted.count<5{
                continue
            }
            let typenum = (splitted[3] as NSString).integerValue % 16
            switch HitObject.getObjectType(typenum) {
            case .circle:
                newcombo=newcombo || HitObject.getNewCombo(typenum)
                hitobjects.append(HitCircle(x: (splitted[0] as NSString).integerValue, y: (splitted[1] as NSString).integerValue, time: (splitted[2] as NSString).integerValue, hitsound: (splitted[4] as NSString).integerValue, newCombo: newcombo))
                newcombo=false
                break
            case .slider:
                newcombo=newcombo || HitObject.getNewCombo(typenum)
                let dslider=decodeSlider(splitted[5])
                let slider=Slider(x: (splitted[0] as NSString).integerValue, y: (splitted[1] as NSString).integerValue, slidertype: dslider.type, curveX: dslider.cx, curveY: dslider.cy, time: (splitted[2] as NSString).integerValue, hitsound: (splitted[4] as NSString).integerValue, newCombo: newcombo, repe: (splitted[6] as NSString).integerValue,length:(splitted[7] as NSString).integerValue)
                slider.genpath(false)
                slider.bordercolor = bordercolor
                if trackoverride {
                    slider.trackoverride = true
                    slider.trackcolor = trackcolor
                }
                hitobjects.append(slider)
                newcombo = false
                break
            case .spinner:
                newcombo=true //TODO: Maybe wrong
                hitobjects.append(Spinner(time: (splitted[2] as NSString).integerValue, hitsound: (splitted[4] as NSString).integerValue, endtime: (splitted[5] as NSString).integerValue, newcombo: newcombo))
                break
            case .none:
                continue
            }
        }
    }
    
    func decodeSlider(_ sliderinfo:String) -> DecodedSlider {
        let splitted=sliderinfo.components(separatedBy: "|")
        if splitted.count<=1{
            return DecodedSlider(cx: [], cy: [], type: .none)
        }
        var type=SliderType.none
        switch splitted[0]{
        case "L":
            type = .linear
            break
        case "P":
            type = .passThrough
            break
        case "B":
            type = .bezier
            break
        case "C":
            type = .catmull
            break
        default:
            return DecodedSlider(cx: [], cy: [], type: .none)
        }
        var cx:[Int] = []
        var cy:[Int] = []
        for i in 1...splitted.count-1 {
            let position=splitted[i].components(separatedBy: ":")
            if position.count != 2 {
                continue
            }
            let x=(position[0] as NSString).integerValue
            let y=(position[1] as NSString).integerValue
            cx.append(x)
            cy.append(y)
        }
        return DecodedSlider(cx: cx, cy: cy, type: type)
    }
    
    class DecodedSlider {
        
        open var cx:[Int]
        open var cy:[Int]
        open var type:SliderType
        
        init(cx:[Int],cy:[Int],type:SliderType) {
            self.cx=cx
            self.cy=cy
            self.type=type
        }
        
    }
    
}
