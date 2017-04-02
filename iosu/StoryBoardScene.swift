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
    var bmactions:[SKAction] = []
    var actiontimepoints:[Int] = []
    let testBMIndex = 6 //The index of beatmap to test in the beatmaps
    var minlayer:CGFloat=0.0
    var hitaudioHeader:String = "normal-"
    
    override func sceneDidLoad() {
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
                let sb=try StoryBoard(directory:beatmaps.beatmapdirs[testBMIndex],file: (beatmaps.beatmapdirs[testBMIndex] as NSString).appendingPathComponent(beatmaps.storyboards[beatmaps.beatmapdirs[testBMIndex]]!), width: Double(size.width), height: Double(size.height), layer: 0)
                debugPrint("storyboard object count:\(sb.sbsprites.count)")
            }catch StoryBoardError.FileNotFound{
                debugPrint("ERROR:storyboard file not found")
            }catch StoryBoardError.IllegalFormat{
                debugPrint("ERROR:illegal storyboard format")
            }catch let error{
                debugPrint("ERROR:unknown error(\(error.localizedDescription))")
            }
        }
        //self.run(mplayer.play(file: bm.audiofile))
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
        if index<bmactions.count {
            //If the frame rate drops under 10, the timing will be inaccurate
            //However, if the frame rate drops under 10, the game will be hardly playable!
            while actiontimepoints[index]-Int(mplayer.getTime()*1000) <= 1100 {
                let offset=actiontimepoints[index]-Int(mplayer.getTime()*1000)-1000
                debugPrint("time:\(mplayer.getTime())")
                debugPrint("push hit circle \(index)/\(bmactions.count-1) with offset \(offset)")
                self.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(Double(offset)/1000)),bmactions[index]]))
                //self.run(bmactions[index])
                index+=1
                if index>=bmactions.count{
                    return
                }
            }
        }
    }
    
}
