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
    static var testBMIndex = 42 //The index of beatmap to test in the beatmaps
    var minlayer:CGFloat=0.0
    var hitaudioHeader:String = "normal-"
    var sb:StoryBoard?
    
    override func sceneDidLoad() {
        var audiofile=""
        let beatmaps=BeatmapScanner()
        /*debugPrint("list of detected beatmaps:")
        for item in beatmaps.beatmaps {
            debugPrint("\(beatmaps.beatmaps.index(of: item)!): \(item)")
        }
        debugPrint("list of detected storyboards:")
        for (_,value) in beatmaps.storyboards {
            debugPrint("\(value)")
        }*/
        debugPrint("test beatmap:\(beatmaps.beatmaps[StoryBoardScene.testBMIndex])")
        debugPrint("Enter StoryBoardScene, screen size: \(size.width)*\(size.height)")
        do{
            let bm=try Beatmap(file: (beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[StoryBoardScene.testBMIndex]])[0])
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
            bm.audiofile=(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [bm.audiofile])[0] as String
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
        if beatmaps.dirscontainsb.contains(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex]) {
            do{
                sb=try StoryBoard(directory:beatmaps.beatmapdirs[StoryBoardScene.testBMIndex],osufile:(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[StoryBoardScene.testBMIndex]])[0],osbfile: (beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).appendingPathComponent(beatmaps.storyboards[beatmaps.beatmapdirs[StoryBoardScene.testBMIndex]]!), width: Double(size.width), height: Double(size.height), layer: 0)
                debugPrint("storyboard object count: \(sb?.sbsprites.count)")
                debugPrint("storyboard earliest time: \(sb?.earliest)")
                //debugPrint("6400 starttime: \(sb?.sbsprites[6400].starttime)")
                //var count=0
                while (sb?.sbsprites[index].starttime)!<=0 {
                    //if count<=StoryBoardScene.renderlimit {
                        sb?.sbsprites[index].convertsprite()
                        self.addChild((sb?.sbsprites[index].sprite)!)
                        sb?.sbsprites[index].runaction(offset: (sb?.sbsprites[index].starttime)!-(sb?.earliest)!)
                    //}
                    //count+=1
                    index+=1
                }
                if (sb?.earliest)!<0 {
                    self.run(SKAction.sequence([SKAction.wait(forDuration: Double(-(sb?.earliest)!)/1000),mplayer.play(file: audiofile)]))
                } else {
                    self.run(mplayer.play(file: audiofile))
                }
            }catch StoryBoardError.FileNotFound{
                debugPrint("ERROR:storyboard file not found")
            }catch StoryBoardError.IllegalFormat{
                debugPrint("ERROR:illegal storyboard format")
            }catch let error{
                debugPrint("ERROR:unknown error(\(error.localizedDescription))")
            }
        }else{
            do{
                debugPrint(".osb file not found")
                sb=try StoryBoard(directory:beatmaps.beatmapdirs[StoryBoardScene.testBMIndex],osufile:(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[StoryBoardScene.testBMIndex]])[0], width: Double(size.width), height: Double(size.height), layer: 0)
                debugPrint("storyboard object count: \(sb?.sbsprites.count)")
                debugPrint("storyboard earliest time: \(sb?.earliest)")
                //debugPrint("6400 starttime: \(sb?.sbsprites[6400].starttime)")
                //var count=0
                //debugPrint("\(sb?.sbsprites[index].starttime) \(sb?.sbsprites[index].commands.count)")
                while (sb?.sbsprites[index].starttime)!<=0 {
                    //if count<=StoryBoardScene.renderlimit {
                    sb?.sbsprites[index].convertsprite()
                    self.addChild((sb?.sbsprites[index].sprite)!)
                    sb?.sbsprites[index].runaction(offset: (sb?.sbsprites[index].starttime)!-(sb?.earliest)!)
                    //}
                    //count+=1
                    index+=1
                }
                debugPrint("start playing music")
                if (sb?.earliest)!<0 {
                    self.run(SKAction.sequence([SKAction.wait(forDuration: Double(-(sb?.earliest)!)/1000),mplayer.play(file: audiofile)]))
                } else {
                    self.run(mplayer.play(file: audiofile))
                }
            }catch StoryBoardError.FileNotFound{
                debugPrint("ERROR:storyboard file not found")
            }catch StoryBoardError.IllegalFormat{
                debugPrint("ERROR:illegal storyboard format")
            }catch let error{
                debugPrint("ERROR:unknown error(\(error.localizedDescription))")
            }
        }
        //self.run(mplayer.play(file: audiofile))
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
    //Too many objects loaded at the same time will crash the game
    static private let renderlimit=1000
    //Too many objects shown at the same time will crash the game too
    static private let spritelimit=40000
    private var rendercount=0
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        rendercount=0
        if sb != nil {
            if index<(sb?.sbsprites.count)! {
                if self.children.count>=StoryBoardScene.spritelimit {
                    let musictime=Int(mplayer.getTime()*1000)
                    while (sb?.sbsprites[index].starttime)! - musictime<50{
                        index+=1
                        if index>=(sb?.sbsprites.count)!{
                            return
                        }
                    }
                    return
                }
                let musictime=Int(mplayer.getTime()*1000)
                while (sb?.sbsprites[index].starttime)! - musictime <= 100 {
                    /*if (sb?.sbsprites[index].starttime)!<=0 {
                        index+=1
                        continue
                    }*/
                    if rendercount>StoryBoardScene.renderlimit {
                        index+=1
                        continue
                    }
                    //if offset<50 {
                        while (sb?.sbsprites[index].starttime)! - musictime<50{
                            index+=1
                            if index>=(sb?.sbsprites.count)!{
                                return
                            }
                        }
                        //continue
                        //offset=0
                    //}
                    let offset=(sb?.sbsprites[index].starttime)! - musictime
                    //debugPrint("Add sprite \(index)/\((sb?.sbsprites.count)!-1) at layer \(sb?.sbsprites[index].rlayer) with offset \(offset)")
                    sb?.sbsprites[index].convertsprite()
                    /*debugPrint("sprite status: \(sb?.sbsprites[index].sprite)")
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
                    }*/
                    self.addChild((sb?.sbsprites[index].sprite)!)
                    sb?.sbsprites[index].runaction(offset: offset)
                    index+=1
                    rendercount+=1
                    if index>=(sb?.sbsprites.count)!{
                        return
                    }
                }
            }
        }
    }
    
}
