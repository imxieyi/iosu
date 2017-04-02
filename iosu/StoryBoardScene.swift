//
//  GameScene.swift
//  iosu
//
//  Created by xieyi on 2017/4/2.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import SpriteKit
import SpriteKitEasingSwift
import GameplayKit

class StoryBoardScene: SKScene {
    
    let mplayer=BGMusicPlayer()
    var actiontimepoints:[Int] = []
    let testBMIndex = 6 //The index of beatmap to test in the beatmaps
    var minlayer:CGFloat=0.0
    var hitaudioHeader:String = "normal-"
    var sb:StoryBoard?
    
    override func sceneDidLoad() {
        var audiofile=""
        let beatmaps=BeatmapScanner()
        debugPrint("list of detected beatmaps:")
        for item in beatmaps.beatmaps {
            debugPrint("\(beatmaps.beatmaps.index(of: item)!): \(item)")
        }
        debugPrint("list of detected storyboards:")
        for (_,value) in beatmaps.storyboards {
            debugPrint("\(value)")
        }
        debugPrint("test beatmap:\(beatmaps.beatmaps[testBMIndex])")
        debugPrint("Enter StoryBoardScene, screen size: \(size.width)*\(size.height)")
        do{
            let bm=try Beatmap(file: (beatmaps.beatmapdirs[testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[testBMIndex]])[0])
            switch bm.sampleSet {
            case .Auto:
                //Likely to be an error
                hitaudioHeader="normal-"
                break
            case .Normal:
                hitaudioHeader="normal-"
                break
            case .Soft:
                hitaudioHeader="soft-"
                break
            case .Drum:
                hitaudioHeader="drum-"
                break
            }
            debugPrint("bgimg:\(bm.bgimg)")
            debugPrint("audio:\(bm.audiofile)")
            debugPrint("colors: \(bm.colors.count)")
            debugPrint("timingpoints: \(bm.timingpoints.count)")
            debugPrint("hitobjects: \(bm.hitobjects.count)")
            debugPrint("hitsoundset: \(hitaudioHeader)")
            bm.audiofile=(beatmaps.beatmapdirs[testBMIndex] as NSString).strings(byAppendingPaths: [bm.audiofile])[0] as String
            if !FileManager.default.fileExists(atPath: bm.audiofile){
                throw BeatmapError.AudioFileNotExist
            }
            audiofile=bm.audiofile
        } catch BeatmapError.FileNotFound {
            debugPrint("ERROR:beatmap file not found")
        } catch BeatmapError.IllegalFormat {
            debugPrint("ERROR:Illegal beatmap format")
        } catch BeatmapError.NoAudioFile {
            debugPrint("ERROR:Audio file not found")
        } catch BeatmapError.AudioFileNotExist {
            debugPrint("ERROR:Audio file does not exist")
        } catch BeatmapError.NoColor {
            debugPrint("ERROR:Color not found")
        } catch BeatmapError.NoHitObject{
            debugPrint("ERROR:No hitobject found")
        } catch let error {
            debugPrint("ERROR:unknown error(\(error.localizedDescription))")
        }
        if beatmaps.dirscontainsb.contains(beatmaps.beatmapdirs[testBMIndex]) {
            do{
                sb=try StoryBoard(directory:beatmaps.beatmapdirs[testBMIndex],file: (beatmaps.beatmapdirs[testBMIndex] as NSString).appendingPathComponent(beatmaps.storyboards[beatmaps.beatmapdirs[testBMIndex]]!), width: Double(size.width), height: Double(size.height), layer: 0)
                debugPrint("storyboard object count:\(sb?.sbsprites.count)")
            }catch StoryBoardError.FileNotFound{
                debugPrint("ERROR:storyboard file not found")
            }catch StoryBoardError.IllegalFormat{
                debugPrint("ERROR:illegal storyboard format")
            }catch let error{
                debugPrint("ERROR:unknown error(\(error.localizedDescription))")
            }
        }
        self.run(mplayer.play(file: audiofile))
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    var index = 0
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if sb != nil {
            if index<(sb?.sbsprites.count)! {
            //if index<(sb?.sbsprites.count)! {
                while (sb?.sbsprites[index].starttime)! - Int(mplayer.getTime()*1000) <= 100 {
                    if (sb?.sbsprites[index].starttime)!<=0 {
                        index+=1
                        continue
                    }
                    let offset=(sb?.sbsprites[index].starttime)! - Int(mplayer.getTime()*1000)
                    if offset<0 {
                        return
                    }
                    debugPrint("Add sprite \(index) at layer \(sb?.sbsprites[index].rlayer) with offset \(offset)")
                    sb?.sbsprites[index].convertsprite()
                    debugPrint("sprite status: \(sb?.sbsprites[index].sprite)")
                    debugPrint("sprite time: \(sb?.sbsprites[index].starttime) -> \(sb?.sbsprites[index].endtime)")
                    debugPrint("sprite cmds:")
                    for cmd in (sb?.sbsprites[index].commands)! {
                        switch cmd.type {
                        case .Fade:
                            let c=cmd as! SBFade
                            debugPrint("F \(c.starttime)->\(c.endtime) \(c.startopacity)->\(c.endopacity)")
                            break
                        case .MoveX:
                            let c=cmd as! SBMoveX
                            debugPrint("MX \(c.starttime)->\(c.endtime) \(c.startx)->\(c.endx)")
                            break
                        case .MoveY:
                            let c=cmd as! SBMoveY
                            debugPrint("MY \(c.starttime)->\(c.endtime) \(c.starty)->\(c.endy)")
                            break
                        case .Scale:
                            let c=cmd as! SBScale
                            debugPrint("S \(c.starttime)->\(c.endtime) \(c.starts)->\(c.ends)")
                            break
                        default:
                            debugPrint(cmd)
                        }
                    }
                    self.addChild((sb?.sbsprites[index].sprite)!)
                    sb?.sbsprites[index].runaction(offset: offset)
                    index+=1
                    if index>=(sb?.sbsprites.count)!{
                        return
                    }
                }
            }
        }
    }
    
}
