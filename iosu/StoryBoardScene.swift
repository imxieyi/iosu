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
    //StoryBoard.stdwidth=854
    var audiofile=""
    var sb:StoryBoard?
    public var viewController:GameViewController?
    
    init(size: CGSize,parent:GameViewController) {
        //debugPrint("enter constructor,parent is \(parent)")
        self.viewController=parent
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func sceneDidLoad() {
        let beatmaps=BeatmapScanner()
        debugPrint("test beatmap:\(beatmaps.beatmaps[StoryBoardScene.testBMIndex])")
        debugPrint("Enter StoryBoardScene, screen size: \(size.width)*\(size.height)")
        do{
            let bm=try Beatmap(file: (beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[StoryBoardScene.testBMIndex]])[0])
            debugPrint("bgimg:\(bm.bgimg)")
            debugPrint("audio:\(bm.audiofile)")
            debugPrint("colors: \(bm.colors.count)")
            debugPrint("timingpoints: \(bm.timingpoints.count)")
            debugPrint("hitobjects: \(bm.hitobjects.count)")
            bm.audiofile=(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [bm.audiofile])[0] as String
            if !FileManager.default.fileExists(atPath: bm.audiofile){
                throw BeatmapError.AudioFileNotExist
            }
            audiofile=bm.audiofile
        } catch BeatmapError.FileNotFound {
            Alerts.show(sender: viewController!, title: "Error", message: "beatmap file not found", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
            debugPrint("ERROR:beatmap file not found")
        } catch BeatmapError.IllegalFormat {
            Alerts.show(sender: viewController!, title: "Error", message: "Illegal beatmap format", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
            debugPrint("ERROR:Illegal beatmap format")
        } catch BeatmapError.NoAudioFile {
            Alerts.show(sender: viewController!, title: "Error", message: "Audio file not found", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
            debugPrint("ERROR:Audio file not found")
        } catch BeatmapError.AudioFileNotExist {
            Alerts.show(sender: viewController!, title: "Error", message: "Audio file does not exist", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
            debugPrint("ERROR:Audio file does not exist")
        } catch BeatmapError.NoColor {
            Alerts.show(sender: viewController!, title: "Error", message: "Color not found", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
            debugPrint("ERROR:Color not found")
        } catch BeatmapError.NoHitObject{
            Alerts.show(sender: viewController!, title: "Error", message: "No hitobject found", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
            debugPrint("ERROR:No hitobject found")
        } catch let error {
            Alerts.show(sender: viewController!, title: "Error", message: "unknown error(\(error.localizedDescription))", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
            debugPrint("ERROR:unknown error(\(error.localizedDescription))")
        }
        if beatmaps.dirscontainsb.contains(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex]) {
            do{
                sb=try StoryBoard(directory:beatmaps.beatmapdirs[StoryBoardScene.testBMIndex],osufile:(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[StoryBoardScene.testBMIndex]])[0],osbfile: (beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).appendingPathComponent(beatmaps.storyboards[beatmaps.beatmapdirs[StoryBoardScene.testBMIndex]]!), width: Double(size.width), height: Double(size.height), layer: 0)
                debugPrint("storyboard object count: \(sb?.sbsprites.count)")
                debugPrint("storyboard earliest time: \(sb?.earliest)")
                if !ImageBuffer.notfoundimages.isEmpty {
                    debugPrint("parent:\(viewController==nil)")
                    viewController?.alert=Alerts.create(title: "Warning", message: ImageBuffer.notfound2str(), style: .alert, action1title: "Cancel", action1style: .cancel, handler1: nil, action2title: "Continue", action2style: .default, handler2: {(action:UIAlertAction)->Void in
                        self.startplaying()
                    })
                    //debugPrint("there is images not found,\(viewController?.alert)")
                }else{
                    startplaying()
                }
            }catch StoryBoardError.FileNotFound{
                Alerts.show(sender: viewController!, title: "Error", message: "storyboard file not found", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
                debugPrint("ERROR:storyboard file not found")
            }catch StoryBoardError.IllegalFormat{
                Alerts.show(sender: viewController!, title: "Error", message: "illegal storyboard format", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
                debugPrint("ERROR:illegal storyboard format")
            }catch let error{
                Alerts.show(sender: viewController!, title: "Error", message: "unknown error(\(error.localizedDescription))", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
                debugPrint("ERROR:unknown error(\(error.localizedDescription))")
            }
        }else{
            do{
                debugPrint(".osb file not found")
                sb=try StoryBoard(directory:beatmaps.beatmapdirs[StoryBoardScene.testBMIndex],osufile:(beatmaps.beatmapdirs[StoryBoardScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[StoryBoardScene.testBMIndex]])[0], width: Double(size.width), height: Double(size.height), layer: 0)
                debugPrint("storyboard object count: \(sb?.sbsprites.count)")
                debugPrint("storyboard earliest time: \(sb?.earliest)")
                if !ImageBuffer.notfoundimages.isEmpty {
                    Alerts.show(sender: viewController!, title: "Warning", message: ImageBuffer.notfound2str(), style: .alert, action1title: "Cancel", action1style: .cancel, handler1: nil, action2title: "Continue", action2style: .default, handler2: {(action:UIAlertAction)->Void in
                        self.startplaying()
                    })
                }else{
                    startplaying()
                }
            }catch StoryBoardError.FileNotFound{
                Alerts.show(sender: viewController!, title: "Error", message: "storyboard file not found", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
                debugPrint("ERROR:storyboard file not found")
            }catch StoryBoardError.IllegalFormat{
                Alerts.show(sender: viewController!, title: "Error", message: "illegal storyboard format", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
                debugPrint("ERROR:illegal storyboard format")
            }catch let error{
                Alerts.show(sender: viewController!, title: "Error", message: "unknown error(\(error.localizedDescription))", style: .alert, actiontitle: "OK", actionstyle: .cancel, handler: nil)
                debugPrint("ERROR:unknown error(\(error.localizedDescription))")
            }
        }
    }
    
    func startplaying(){
        debugPrint("start playing music")
        //debugPrint("6400 starttime: \(sb?.sbsprites[6400].starttime)")
        //var count=0
        //debugPrint("\(sb?.sbsprites[index].starttime) \(sb?.sbsprites[index].commands.count)")
        if ((sb?.sbsprites.count)!>0){
            while (sb?.sbsprites[index].starttime)!<=0 {
                //if count<=StoryBoardScene.renderlimit {
                //sb?.sbsprites[index].convertsprite()
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
        if sb != nil && mplayer.isplaying() {
            if index<(sb?.sbsprites.count)! {
                let musictime=Int(mplayer.getTime()*1000)
                while (sb?.sbsprites[index].starttime)! - musictime <= 2000 {
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
