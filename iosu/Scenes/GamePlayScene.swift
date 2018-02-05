//
//  GameScene.swift
//  iosu
//
//  Created by xieyi on 2017/3/28.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import SpriteKit
import SpriteKitEasingSwift
import GameplayKit

class GamePlayScene: SKScene {
    
    var bmactions:[SKAction] = []
    var actiontimepoints:[Int] = []
    static var testBMIndex = 6 //The index of beatmap to test in the beatmaps
    var maxlayer:CGFloat=100000
    var minlayer:CGFloat=0
    var hitaudioHeader:String = "normal-"
    static var realwidth:Double=512
    static var realheight:Double=384
    static var scrwidth:Double=750
    static var scrheight:Double=750
    static var scrscale:Double=1
    static var leftedge:Double=0
    static var bottomedge:Double=0
    static var bgdim:Double=0.2
    static var effvolume:Float = 1.0
    static var current:SKScene?
    
    fileprivate var actions:ActionSet?
    
    fileprivate var bgvactions:[SKAction]=[]
    fileprivate var bgvtimes:[Int]=[]
    
    open static var sliderball:SliderBall?
    var bm:Beatmap?
    
    override func sceneDidLoad() {
        GamePlayScene.current = self
        GamePlayScene.sliderball=SliderBall(scene: self)
        GamePlayScene.scrscale=Double(size.height)/480.0
        GamePlayScene.realwidth=512.0*GamePlayScene.scrscale
        GamePlayScene.realheight=384.0*GamePlayScene.scrscale
        GamePlayScene.scrwidth=Double(size.width)
        GamePlayScene.scrheight=Double(size.height)
        GamePlayScene.bottomedge=(Double(size.height)-GamePlayScene.realheight)/2
        GamePlayScene.leftedge=(Double(size.width)-GamePlayScene.realwidth)/2
        let beatmaps=BeatmapScanner()
        debugPrint("test beatmap:\(beatmaps.beatmaps[GamePlayScene.testBMIndex])")
        debugPrint("Enter GamePlayScene, screen size: \(size.width)*\(size.height)")
        debugPrint("scrscale:\(GamePlayScene.scrscale)")
        debugPrint("realwidth:\(GamePlayScene.realwidth)")
        debugPrint("realheight:\(GamePlayScene.realheight)")
        debugPrint("bottomedge:\(GamePlayScene.bottomedge)")
        debugPrint("leftedge:\(GamePlayScene.leftedge)")
        do{
            bm=try Beatmap(file: (beatmaps.beatmapdirs[GamePlayScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[GamePlayScene.testBMIndex]])[0])
            if (bm?.bgvideos.count)! > 0 && GameViewController.showvideo {
                debugPrint("got \(String(describing: bm?.bgvideos.count)) videos")
                for i in 0...(bm?.bgvideos.count)!-1 {
                    let file=(beatmaps.beatmapdirs[GamePlayScene.testBMIndex] as NSString).strings(byAppendingPaths: [(bm?.bgvideos[i].file)!])[0]
                    //var file=URL(fileURLWithPath: beatmaps.beatmapdirs[GamePlayScene.testBMIndex], isDirectory: true)
                    //let file=beatmaps.bmdirurls[GamePlayScene.testBMIndex].appendingPathComponent(bm?.bgvideos[i])
                    if FileManager.default.fileExists(atPath: file) {
                        bgvactions.append(BGVPlayer.setcontent(file))
                        bgvtimes.append((bm?.bgvideos[i].time)!)
                    } else {
                        debugPrint("video not found: \(file)")
                    }
                }
            } else if bm?.bgimg != ""  && !(StoryBoardScene.hasSB) {
                debugPrint("got bgimg:\(String(describing: bm?.bgimg))")
                let bgimg=UIImage(contentsOfFile: (beatmaps.beatmapdirs[GamePlayScene.testBMIndex] as NSString).strings(byAppendingPaths: [(bm?.bgimg)!])[0])
                if bgimg==nil {
                    debugPrint("Background image not found")
                } else {
                    let bgnode=SKSpriteNode(texture: SKTexture(image: bgimg!))
                    let bgscale:CGFloat = max(size.width/(bgimg?.size.width)!,size.height/(bgimg?.size.height)!)
                    bgnode.setScale(bgscale)
                    bgnode.zPosition=0
                    bgnode.position=CGPoint(x: size.width/2, y: size.height/2)
                    addChild(bgnode)
                }
            }
            let dimnode=SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            dimnode.fillColor = .black
            dimnode.alpha=CGFloat(GamePlayScene.bgdim)
            dimnode.zPosition=1
            addChild(dimnode)
            switch (bm?.sampleSet)! {
            case .auto:
                //Likely to be an error
                hitaudioHeader="normal-"
                break
            case .normal:
                hitaudioHeader="normal-"
                break
            case .soft:
                hitaudioHeader="soft-"
                break
            case .drum:
                hitaudioHeader="drum-"
                break
            }
            debugPrint("bgimg:\(String(describing: bm?.bgimg))")
            debugPrint("audio:\(String(describing: bm?.audiofile))")
            debugPrint("colors: \(String(describing: bm?.colors.count))")
            debugPrint("timingpoints: \(String(describing: bm?.timingpoints.count))")
            debugPrint("hitobjects: \(String(describing: bm?.hitobjects.count))")
            debugPrint("hitsoundset: \(hitaudioHeader)")
            bm?.audiofile=(beatmaps.beatmapdirs[GamePlayScene.testBMIndex] as NSString).strings(byAppendingPaths: [(bm?.audiofile)!])[0] as String
            if !FileManager.default.fileExists(atPath: (bm?.audiofile)!){
                throw BeatmapError.audioFileNotExist
            }
            actions = ActionSet(beatmap: bm!, scene: self)
            actions?.prepare()
            BGMusicPlayer.instance.gameScene = self
            BGMusicPlayer.instance.gameEarliest = Int((actions?.nexttime())!) - Int((bm?.difficulty?.ARTime)!)
            BGMusicPlayer.instance.setfile((bm?.audiofile)!)
            if bgvtimes.count>0 {
                BGMusicPlayer.instance.videoEarliest = bgvtimes.first!
            }
        } catch BeatmapError.fileNotFound {
            debugPrint("ERROR:beatmap file not found")
        } catch BeatmapError.illegalFormat {
            debugPrint("ERROR:Illegal beatmap format")
        } catch BeatmapError.noAudioFile {
            debugPrint("ERROR:Audio file not found")
        } catch BeatmapError.audioFileNotExist {
            debugPrint("ERROR:Audio file does not exist")
        } catch BeatmapError.noColor {
            debugPrint("ERROR:Color not found")
        } catch BeatmapError.noHitObject{
            debugPrint("ERROR:No hitobject found")
        } catch let error {
            debugPrint("ERROR:unknown error(\(error.localizedDescription))")
        }
    }
    
    static func conv(x:Double) -> Double {
        return leftedge+x*scrscale
    }
    
    static func conv(y:Double) -> Double {
        return scrheight-bottomedge-y*scrscale
    }
    
    static func conv(w:Double) -> Double {
        return w*scrscale
    }
    
    static func conv(h:Double) -> Double {
        return h*scrscale
    }
    
    func showresult(x:CGFloat,y:CGFloat,result:HitResult,audio:String) {
        var img:SKTexture
        switch result {
        case .s300:
            img = SkinBuffer.get("hit300")!
            break
        case .s100:
            img = SkinBuffer.get("hit100")!
            break
        case .s50:
            img = SkinBuffer.get("hit50")!
            break
        case .fail:
            img = SkinBuffer.get("hit0")!
            break
        }
        let node = SKSpriteNode(texture: img)
        let scale = CGFloat((bm?.difficulty?.AbsoluteCS)! / 128)
        node.setScale(scale)
        node.colorBlendFactor = 0
        node.alpha = 0
        node.position = CGPoint(x: x, y: y)
        node.zPosition = 100001
        self.addChild(node)
        if result != .fail {
            self.run(.playSoundFileNamed(audio, atVolume: GamePlayScene.effvolume, waitForCompletion: true))
        } else {
            self.run(.playSoundFileNamed("combobreak.mp3", atVolume: GamePlayScene.effvolume, waitForCompletion: true))
        }
        node.run(.group([.sequence([.fadeIn(withDuration: 0.2),.fadeOut(withDuration: 0.6)]),.sequence([.scale(by: 1.5, duration: 0.1),.scale(to: scale, duration: 0.1)])]))
    }
    
    func hitsound2str(hitsound:HitSound) -> String {
        switch hitsound {
        case .normal:
            return "hitnormal.wav"
        case .clap:
            return "hitclap.wav"
        case .finish:
            return "hitfinish.wav"
        case .whistle:
            return "hitwhistle.wav"
        }
    }
    
    func distance(x1:CGFloat,y1:CGFloat,x2:CGFloat,y2:CGFloat) -> CGFloat {
        return sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
    }
    
    //Slider Status
    private var onslider = false
    private var hastouch = false
    private var lastpoint:CGPoint = .zero
    
    fileprivate func updateslider(_ time:Double) {
        let act = actions?.currentact()
        if act?.getobj().type != .slider {
            return
        }
        let sact = act as! SliderAction
        let sliderpoint = sact.getposition(time)
        if hastouch {
            if distance(x1: lastpoint.x, y1: lastpoint.y, x2: sliderpoint.x, y2: sliderpoint.y) <= CGFloat((bm?.difficulty?.AbsoluteCS)!) {
                onslider = true
                GamePlayScene.sliderball?.showfollowcircle()
            } else {
                GamePlayScene.sliderball?.hidefollowcircle()
                onslider = false
            }
        } else {
            onslider = false
        }
        switch sact.update(time, following: onslider) {
        case .failOnce:
            //self.run(.playSoundFileNamed("combobreak.mp3", waitForCompletion: false))
            break
        case .failAll:
            showresult(x: sliderpoint.x, y: sliderpoint.y, result: .fail, audio: "")
            actions?.pointer += 1
            hastouch = false
            break
        case .edgePass:
            self.run(.playSoundFileNamed(hitaudioHeader + hitsound2str(hitsound: sact.getobj().hitSound), atVolume: GamePlayScene.effvolume, waitForCompletion: true))
            break
        case .end:
            if sact.failcount > 0 {
                showresult(x: sact.endx, y: sact.endy, result: .s100, audio: hitaudioHeader + hitsound2str(hitsound: sact.getobj().hitSound))
            } else {
                showresult(x: sact.endx, y: sact.endy, result: .s300, audio: hitaudioHeader + hitsound2str(hitsound: sact.getobj().hitSound))
            }
            GamePlayScene.sliderball?.hideall()
            actions?.pointer += 1
            hastouch = false
            break
        case .tickPass:
            self.run(.playSoundFileNamed(hitaudioHeader + "slidertick.wav", atVolume: GamePlayScene.effvolume, waitForCompletion: true))
            break
        case .failTick:
            self.run(.playSoundFileNamed("combobreak.mp3", atVolume: GamePlayScene.effvolume, waitForCompletion: true))
            break
        default:
            break
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        hastouch = true
        let act = actions?.currentact()
        if act != nil {
            let time = BGMusicPlayer.instance.getTime()*1000
            switch (act?.getobj().type)! {
            case .circle:
                if (act?.gettime())! - time < (bm?.difficulty?.ARTime)! {
                    let circle = act?.getobj() as! HitCircle
                    if distance(x1: pos.x, y1: pos.y, x2: CGFloat(circle.x), y2: CGFloat(circle.y)) <= CGFloat((bm?.difficulty?.AbsoluteCS)!) {
                        //debugPrint("time:\(time) required:\(act?.gettime())")
                        let result = (act as! CircleAction).judge(time)
                        showresult(x: CGFloat(circle.x), y: CGFloat(circle.y), result: result, audio: hitaudioHeader + hitsound2str(hitsound: circle.hitSound))
                    }
                }
                hastouch = false
                break
            case .slider:
                lastpoint = pos
                updateslider(time)
                break
            default:
                break
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let act = actions?.currentact()
        if act == nil {
            return
        }
        if (act?.getobj().type)! == .slider {
            lastpoint = pos
            updateslider(BGMusicPlayer.instance.getTime()*1000)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        hastouch = false
        GamePlayScene.sliderball?.hidefollowcircle()
        let act = actions?.currentact()
        if act == nil {
            return
        }
        updateslider(BGMusicPlayer.instance.getTime()*1000)
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
    
    var bgvindex = 0
    var firstrun=true
    let dispatcher = DispatchQueue(label: "bm_dispatcher")
    
    func destroyNode(_ node: SKNode) {
        for child in node.children {
            destroyNode(child)
        }
        node.removeAllActions()
        node.removeAllChildren()
        node.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if(firstrun){
            firstrun=false
            GamePlayScene.sliderball?.initialize(CGFloat((bm?.difficulty?.AbsoluteCS)!))
        }
        if BGMusicPlayer.instance.state == .stopped {
            destroyNode(self)
        }
        let mtime=BGMusicPlayer.instance.getTime()*1000
        if self.bgvindex < self.bgvactions.count {
            if self.bgvtimes[self.bgvindex] - Int(mtime) < 1000 {
                var offset=self.bgvtimes[self.bgvindex] - Int(mtime)
                if offset<0 {
                    offset=0
                }
                debugPrint("push bgvideo \(self.bgvindex) with offset \(offset)")
                self.run(SKAction.group([self.bgvactions[self.bgvindex],SKAction.sequence([SKAction.wait(forDuration: Double(offset)/1000),BGVPlayer.play()])]))
                self.bgvindex+=1
            }
        }
        dispatcher.async {
            let mtime=BGMusicPlayer.instance.getTime()*1000
            let act = self.actions?.currentact()
            if act != nil {
                if act?.getobj().type == .slider {
                    self.updateslider(mtime)
                }
            }
            var offset = (self.actions?.nexttime())! - mtime - (self.bm?.difficulty?.ARTime)!
            while (self.actions?.hasnext())! && offset <= 1000 {
                //debugPrint("mtime \(mtime) objtime \((actions?.nexttime())!) ar \((bm?.difficulty?.ARTime)!) offset \(offset)")
                self.actions?.shownext(offset)
                offset = (self.actions?.nexttime())! - mtime - (self.bm?.difficulty?.ARTime)!
            }
        }
    }
    
}
