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
    
    let mplayer=BGMusicPlayer()
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
    var bgvactions:[SKAction]=[]
    var bgvtimes:[Int]=[]
    
    override func sceneDidLoad() {
        GamePlayScene.scrscale=Double(size.height)/480.0
        GamePlayScene.realwidth=512.0*GamePlayScene.scrscale
        GamePlayScene.realheight=384.0*GamePlayScene.scrscale
        GamePlayScene.scrwidth=Double(size.width)
        GamePlayScene.scrheight=Double(size.height)
        GamePlayScene.bottomedge=(Double(size.height)-GamePlayScene.realheight)/2
        GamePlayScene.leftedge=(Double(size.width)-GamePlayScene.realwidth)/2
        let beatmaps=BeatmapScanner()
        debugPrint("list of detected beatmaps:")
        for item in beatmaps.beatmaps {
            debugPrint("\(beatmaps.beatmaps.index(of: item)!): \(item)")
        }
        debugPrint("test beatmap:\(beatmaps.beatmaps[GamePlayScene.testBMIndex])")
        debugPrint("Enter GamePlayScene, screen size: \(size.width)*\(size.height)")
        debugPrint("scrscale:\(GamePlayScene.scrscale)")
        debugPrint("realwidth:\(GamePlayScene.realwidth)")
        debugPrint("realheight:\(GamePlayScene.realheight)")
        debugPrint("bottomedge:\(GamePlayScene.bottomedge)")
        debugPrint("leftedge:\(GamePlayScene.leftedge)")
        do{
            let bm=try Beatmap(file: (beatmaps.beatmapdirs[GamePlayScene.testBMIndex] as NSString).strings(byAppendingPaths: [beatmaps.beatmaps[GamePlayScene.testBMIndex]])[0])
            if bm.bgvideos.count > 0 {
                debugPrint("got \(bm.bgvideos.count) videos")
                for i in 0...bm.bgvideos.count-1 {
                    let file=(beatmaps.beatmapdirs[GamePlayScene.testBMIndex] as NSString).strings(byAppendingPaths: [bm.bgvideos[i]])[0]
                    //var file=URL(fileURLWithPath: beatmaps.beatmapdirs[GamePlayScene.testBMIndex], isDirectory: true)
                    //let file=beatmaps.bmdirurls[GamePlayScene.testBMIndex].appendingPathComponent(bm.bgvideos[i])
                    if FileManager.default.fileExists(atPath: file) {
                        bgvactions.append(BGVPlayer.setcontent(file: file))
                        bgvtimes.append(bm.bgvtimes[i])
                    } else {
                        debugPrint("video not found: \(file)")
                    }
                }
            } else if bm.bgimg != "" {
                debugPrint("got bgimg:\(bm.bgimg)")
                let bgimg=UIImage(contentsOfFile: (beatmaps.beatmapdirs[GamePlayScene.testBMIndex] as NSString).strings(byAppendingPaths: [bm.bgimg])[0])
                if bgimg==nil {
                    debugPrint("Background image not found")
                } else {
                    let bgnode=SKSpriteNode(texture: SKTexture(image: bgimg!))
                    let bgscale=size.width/(bgimg?.size.width)!
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
            bm.audiofile=(beatmaps.beatmapdirs[GamePlayScene.testBMIndex] as NSString).strings(byAppendingPaths: [bm.audiofile])[0] as String
            if !FileManager.default.fileExists(atPath: bm.audiofile){
                throw BeatmapError.AudioFileNotExist
            }
            //let bmactions=SKAction.sequence(playBeatmap(beatmap: bm))
            bmactions=playBeatmap(beatmap: bm)
            ///try mplayer.play(file: bm.audiofile)
            //self.run(bmactions)
            //for action in bmactions{
            //    self.run(action)
            //}
            self.run(mplayer.play(file: bm.audiofile))
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
    
    func playBeatmap(beatmap:Beatmap) -> [SKAction] {
        var actions:[SKAction]=[]
        //actions.append(mplayer.play(file: beatmap.audiofile))
        var colorindex=0
        var layer:CGFloat=maxlayer
        var number=0
        var index = -1
        for obj in beatmap.hitobjects {
            layer-=1
            index+=1
            var islast=false
            if index==beatmap.hitobjects.count-1 {
                islast=true
            } else {
                islast=beatmap.hitobjects[index+1].newCombo
            }
            switch obj.type{
            case HitObjectType.Circle:
                number+=1
                if obj.newCombo{
                    number=1
                    if colorindex<beatmap.colors.count-1 {// && obj.newCombo{
                        colorindex+=1
                    }else{
                        colorindex=0
                    }
                }
                actions.append(addHitCircleAction(color: beatmap.colors[colorindex], x: CGFloat(obj.x), y: CGFloat(obj.y),z:layer,hitsound:obj.hitSound,type:.Plain,number:number,islast:islast))
                actiontimepoints.append(obj.time)
                break
            case HitObjectType.Slider:
                //TODO: Draw Slider
                layer-=1
                number+=1
                if obj.newCombo{
                    number=1
                    if colorindex<beatmap.colors.count-1 {// && obj.newCombo{
                        colorindex+=1
                    }else{
                        colorindex=0
                    }
                }
                actions.append(addHitCircleAction(color: beatmap.colors[colorindex], x: CGFloat(obj.x), y: CGFloat(obj.y),z:layer,hitsound:obj.hitSound,type:.SliderHead,number:number,islast:false))
                actiontimepoints.append(obj.time)
                let slider=obj as! Slider
                var repe=slider.repe
                let endx=slider.cx[slider.cx.count-1]
                let endy=slider.cy[slider.cy.count-1]
                var atstart=false
                var timepoint=obj.time
                //Calculate time of single run
                //Reference: https://github.com/nojhamster/osu-parser
                let timingpoint=beatmap.getTimingPoint(offset: timepoint)
                let pxPerBeat=100*beatmap.difficulty.slidermultiplier
                let beatsNumber=Double(slider.length)/pxPerBeat
                let singleduration=Int(ceil(beatsNumber*timingpoint.timeperbeat))
                let fulltime=repe*singleduration
                actiontimepoints.append(obj.time)
                actions.append(addSliderAction(slider: slider, color: beatmap.colors[colorindex], layer: layer-1-CGFloat(repe), time: fulltime))
                while repe>1 {
                    layer-=1
                    timepoint+=singleduration
                    actiontimepoints.append(timepoint)
                    if atstart {
                        actions.append(addHitCircleAction(color: beatmap.colors[colorindex], x: CGFloat(obj.x), y: CGFloat(obj.y),z:layer,hitsound:obj.hitSound,type:.SliderArrow,number:number,islast:false))
                        atstart=false
                    } else {
                        actions.append(addHitCircleAction(color: beatmap.colors[colorindex], x: CGFloat(endx), y: CGFloat(endy),z:layer,hitsound:obj.hitSound,type:.SliderArrow,number:number,islast:false))
                        atstart=true
                    }
                    repe-=1
                }
                layer-=1
                timepoint+=singleduration
                actiontimepoints.append(timepoint)
                if atstart {
                    actions.append(addHitCircleAction(color: beatmap.colors[colorindex], x: CGFloat(obj.x), y: CGFloat(obj.y),z:layer,hitsound:obj.hitSound,type:.SliderEnd,number:number,islast:islast))
                } else {
                    actions.append(addHitCircleAction(color: beatmap.colors[colorindex], x: CGFloat(endx), y: CGFloat(endy),z:layer,hitsound:obj.hitSound,type:.SliderEnd,number:number,islast:islast))
                }
                layer-=1
                break
            case HitObjectType.Spinner:
                //TODO: Draw Spinner
                number=1
                break
            case HitObjectType.None:
                //Do nothing
                break
            }
        }
        minlayer=layer
        return actions
    }
    
    func addSliderAction(slider:Slider,color:UIColor,layer:CGFloat,time:Int) -> SKAction {
        return SKAction.run {
            slider.genimage(color: color, layer: layer,inwidth:112,outwidth:128)
            let slidernode=SKSpriteNode(texture: SKTexture(image: slider.image!))
            //slidernode.alpha=1
            slidernode.anchorPoint=CGPoint(x: 0, y: 0)
            slidernode.position = .zero
            slidernode.zPosition=layer
            self.addChild(slidernode)
            slidernode.run(SKAction.sequence([SKAction.wait(forDuration: Double(time)/1000+1),SKAction.fadeOut(withDuration: 1),SKAction.removeFromParent()]),completion: {
                slider.image=nil
            })
        }
    }
    
    func addHitCircleAction(color:UIColor,x:CGFloat,y:CGFloat,z:CGFloat,hitsound:HitSound,type:CircleType,number:Int,islast:Bool) -> SKAction{
        return SKAction.run({() -> Void in
            self.addHitCircle(color: color,x:x,y:y,z:z,hitsound:hitsound,type:type,number:number,islast:islast)
        })
    }
    
    func addHitCircle(color:UIColor,x:CGFloat,y:CGFloat,z:CGFloat,hitsound:HitSound,type:CircleType,number:Int,islast:Bool){
        let hitCircleInner=SKSpriteNode(imageNamed: "hitcircle")
        hitCircleInner.blendMode=SKBlendMode.alpha
        hitCircleInner.color=color
        hitCircleInner.colorBlendFactor=1.0
        hitCircleInner.position=CGPoint(x: x, y: y)
        hitCircleInner.size=CGSize(width: 128, height: 128)
        hitCircleInner.setScale(1.0)
        hitCircleInner.alpha=1.0
        hitCircleInner.zPosition=z+0.1
        addChild(hitCircleInner)
        let hitCircleOverlay=SKSpriteNode(imageNamed: "hitcircleoverlay")
        hitCircleOverlay.colorBlendFactor=0.0
        hitCircleOverlay.position=CGPoint(x: x, y: y)
        hitCircleOverlay.size=CGSize(width: 128, height: 128)
        hitCircleOverlay.setScale(1.0)
        hitCircleOverlay.alpha=1.0
        hitCircleOverlay.zPosition=z+0.3
        addChild(hitCircleOverlay)
        if type == .Plain || type == .SliderHead {
            let hitCircleNumber=SKSpriteNode(imageNamed: num2img(num: number))
            hitCircleNumber.colorBlendFactor=0.0
            hitCircleNumber.position=CGPoint(x: x, y: y)
            hitCircleNumber.size=CGSize(width: num2width(num: number), height: num2height(num: number))
            hitCircleNumber.setScale(1.0)
            hitCircleNumber.alpha=1.0
            hitCircleNumber.zPosition=z+0.2
            addChild(hitCircleNumber)
            let ApproachCircle=SKSpriteNode(imageNamed: "approachcircle")
            ApproachCircle.colorBlendFactor=0.0
            ApproachCircle.position=CGPoint(x: x, y: y)
            ApproachCircle.size=CGSize(width: 128, height: 128)
            ApproachCircle.setScale(2.5)
            ApproachCircle.alpha=1.0
            ApproachCircle.zPosition=z+0.0
            addChild(ApproachCircle)
            if type == .Plain {
                ApproachCircle.run(SKAction.sequence([SKAction.scale(to: 1.0, duration: 1),SKAction.playSoundFileNamed(hitaudioHeader + hitsound2str(hitsound: hitsound), waitForCompletion: false),SKAction.run {
                    self.showResult(x:x,y:y,z:z,islast:islast)
                    },SKAction.removeFromParent()]),completion:{()->Void in
                        ApproachCircle.run(SKAction.removeFromParent())
                        let disappear=SKAction.group([SKAction.scale(by: 1.5, duration: 1),SKAction.sequence([SKAction.fadeOut(withDuration: 1.0),SKAction.removeFromParent()])])
                        hitCircleInner.run(SKAction.group([self.moveToBack(sender: hitCircleInner),disappear]))
                        hitCircleNumber.run(SKAction.group([self.moveToBack(sender: hitCircleNumber),disappear]))
                        hitCircleOverlay.run(SKAction.group([self.moveToBack(sender: hitCircleOverlay),disappear]))
                        //ApproachCircle.run(disappear)
                })
            } else { //SliderHead
                ApproachCircle.run(SKAction.sequence([SKAction.scale(to: 1.0, duration: 1),SKAction.playSoundFileNamed(hitaudioHeader + hitsound2str(hitsound: hitsound), waitForCompletion: false),SKAction.removeFromParent()]),completion:{()->Void in
                        ApproachCircle.run(SKAction.removeFromParent())
                        let disappear=SKAction.group([SKAction.scale(by: 1.5, duration: 1),SKAction.sequence([SKAction.fadeOut(withDuration: 1.0),SKAction.removeFromParent()])])
                        //hitCircleInner.run(SKAction.group([self.moveToBack(sender: hitCircleInner),disappear]))
                        //hitCircleNumber.run(SKAction.group([self.moveToBack(sender: hitCircleNumber),disappear]))
                    //hitCircleOverlay.run(SKAction.group([self.moveToBack(sender: hitCircleOverlay),disappear]))
                    hitCircleInner.run(disappear)
                    hitCircleNumber.run(disappear)
                    hitCircleOverlay.run(disappear)
                        //ApproachCircle.run(disappear)
                })
            }
        }
        if type == .SliderArrow {
            hitCircleInner.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.playSoundFileNamed(hitaudioHeader + hitsound2str(hitsound: hitsound), waitForCompletion: false)]), completion: {()->Void in
                let disappear=SKAction.group([SKAction.scale(by: 1.5, duration: 1),SKAction.sequence([SKAction.fadeOut(withDuration: 1.0),SKAction.removeFromParent()])])
                //hitCircleInner.run(SKAction.group([self.moveToBack(sender: hitCircleInner),disappear]))
                //hitCircleOverlay.run(SKAction.group([self.moveToBack(sender: hitCircleOverlay),disappear]))
                hitCircleInner.run(disappear)
                hitCircleOverlay.run(disappear)
            })
        }
        if type == .SliderEnd {
            hitCircleInner.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.playSoundFileNamed(hitaudioHeader + hitsound2str(hitsound: hitsound), waitForCompletion: false)]), completion: {()->Void in
                self.showResult(x:x,y:y,z:z,islast:islast)
                let disappear=SKAction.group([SKAction.scale(by: 1.5, duration: 1),SKAction.sequence([SKAction.fadeOut(withDuration: 1.0),SKAction.removeFromParent()])])
                hitCircleInner.run(SKAction.group([self.moveToBack(sender: hitCircleInner),disappear]))
                hitCircleOverlay.run(SKAction.group([self.moveToBack(sender: hitCircleOverlay),disappear]))
            })
        }
    }
    
    func hitsound2str(hitsound:HitSound) -> String {
        switch hitsound {
        case .Normal:
            return "hitnormal.wav"
        case .Clap:
            return "hitclap.wav"
        case .Finish:
            return "hitfinish.wav"
        case .Whistle:
            return "hitwhistle.wav"
        }
    }
    
    func moveToBack(sender:SKNode) -> SKAction{
        return SKAction.run {
            sender.zPosition-=self.maxlayer-self.minlayer
        }
    }
    
    func showResult(x:CGFloat,y:CGFloat,z:CGFloat,islast:Bool){
        var resultShow:SKSpriteNode
        if islast {
            resultShow=SKSpriteNode(imageNamed: "hit300g")
            resultShow.size=CGSize(width: 81, height: 82)
        } else {
            resultShow=SKSpriteNode(imageNamed: "hit300")
            resultShow.size=CGSize(width: 103, height: 60)
        }
        resultShow.position=CGPoint(x:x,y:y)
        resultShow.alpha=0.0
        resultShow.zPosition=z+0.4
        addChild(resultShow)
        var disappear=SKAction.sequence([SKAction.fadeIn(withDuration: 0.1),SKAction.wait(forDuration: 0.4),SKAction.fadeOut(withDuration: 0.5),SKAction.removeFromParent()])
        disappear=SKAction.group([disappear,SKAction.sequence([SKAction.scale(to: 1.2, duration: 0.07),SKAction.scale(to: 1.0, duration: 0.07)])])
        resultShow.run(disappear)
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
    var bgvindex = 0
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if bgvindex < bgvactions.count {
            if bgvtimes[bgvindex] - Int(mplayer.getTime()*1000) < 1000 {
                let offset=bgvtimes[bgvindex] - Int(mplayer.getTime()*1000)
                debugPrint("push bgvideo \(bgvindex) with offset \(offset)")
                self.run(SKAction.group([bgvactions[bgvindex],SKAction.sequence([SKAction.wait(forDuration: Double(offset)/1000),BGVPlayer.play()])]))
                bgvindex+=1
            }
        }
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
    
    func num2img(num:Int) -> String {
        switch num {
        case 1:
            return "default-1"
        case 2:
            return "default-2"
        case 3:
            return "default-3"
        case 4:
            return "default-4"
        case 5:
            return "default-5"
        case 6:
            return "default-6"
        case 7:
            return "default-7"
        case 8:
            return "default-8"
        case 9:
            return "default-9"
        default:
            //TODO: more than 1 digits
            return "default-0"
        }
    }
    
    func num2width(num:Int) -> Int {
        switch num {
        case 1:
            return 25
        case 2:
            return 32
        case 3:
            return 32
        case 4:
            return 36
        case 5:
            return 32
        case 6:
            return 34
        case 7:
            return 32
        case 8:
            return 34
        case 9:
            return 34
        default:
            //TODO: more than 1 digits
            return 32
        }
    }
    
    func num2height(num:Int) -> Int {
        switch num {
        case 1:
            return 50
        case 2:
            return 51
        case 3:
            return 52
        case 4:
            return 51
        case 5:
            return 51
        case 6:
            return 52
        case 7:
            return 50
        case 8:
            return 52
        case 9:
            return 52
        default:
            //TODO: more than 1 digits
            return 52
        }
    }
    
}
