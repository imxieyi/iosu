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
        //StoryBoard.stdwidth=854
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
                //debugPrint("\(sb?.sbsprites[index].starttime) \(sb?.sbsprites[index].commands.count)")
                if ((sb?.sbsprites.count)!>0){
                while (sb?.sbsprites[index].starttime)!<=0 {
                    sb?.sbsprites[index].convertsprite()
                    self.addChild((sb?.sbsprites[index].sprite)!)
                    if (sb?.sbsprites[index].commands.count)!>0 {
                        sb?.sbsprites[index].runaction(offset: (sb?.sbsprites[index].starttime)!-(sb?.earliest)!)
                    }
                    index+=1
                }
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
        }else{
            do{
                debugPrint(".osb file not found")
                sb=try StoryBoard(directory:beatmaps.beatmapdirs[StoryBoardScene.testBMIndex],osufile:(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[StoryBoardScene.testBMIndex]])[0], width: Double(size.width), height: Double(size.height), layer: 0)
                debugPrint("storyboard object count: \(sb?.sbsprites.count)")
                debugPrint("storyboard earliest time: \(sb?.earliest)")
                //debugPrint("6400 starttime: \(sb?.sbsprites[6400].starttime)")
                //var count=0
                //debugPrint("\(sb?.sbsprites[index].starttime) \(sb?.sbsprites[index].commands.count)")
                if ((sb?.sbsprites.count)!>0){
                while (sb?.sbsprites[index].starttime)!<=0 {
                    //if count<=StoryBoardScene.renderlimit {
                    sb?.sbsprites[index].convertsprite()
                    self.addChild((sb?.sbsprites[index].sprite)!)
                    sb?.sbsprites[index].runaction(offset: (sb?.sbsprites[index].starttime)!-(sb?.earliest)!)
                    //}
                    //count+=1
                    index+=1
                }
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
        //let node=SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
        /*let node=SKSpriteNode(color: UIColor.black, size: CGSize(width: StoryBoard.conv(w: 100), height: StoryBoard.conv(h: 100)))
        node.zPosition=100000
        node.anchorPoint=CGPoint(x: 0, y: 1)
        node.position=CGPoint(x: StoryBoard.conv(x: 10), y: StoryBoard.conv(y: 10))
        //node.fillColor=UIColor.black
        self.addChild(node)*/
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
                let musictime=Int(mplayer.getTime()*1000)
                while (sb?.sbsprites[index].starttime)! - musictime <= 1000 {
                    var offset=(sb?.sbsprites[index].starttime)! - musictime
                    sb?.sbsprites[index].convertsprite()
                    if offset<0{
                        offset = 0
                    }
                    self.addChild((sb?.sbsprites[index].sprite)!)
                    if (sb?.sbsprites[index].commands.count)!>0{
                        sb?.sbsprites[index].runaction(offset: offset)
                    }
                    index+=1
                    if index>=(sb?.sbsprites.count)!{
                        return
                    }
                }
            }
        }
    }
    
}
