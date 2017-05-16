//
//  ActionSet.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class ActionSet {
    
    private var actions:[HitObjectAction]=[]
    private var actnums:[Int] = []
    private var actcols:[UIColor] = []
    private let scene:SKScene
    private var nextindex:Int=0
    public static var difficulty:BMDifficulty?
    public static var current:ActionSet?
    
    init(beatmap:Beatmap,scene:SKScene) {
        ActionSet.difficulty = beatmap.difficulty
        self.scene=scene
        let colors=beatmap.colors
        var colorindex=0
        var number=0
        for obj in beatmap.hitobjects {
            switch obj.type {
            case .Circle:
                if obj.newCombo {
                    number=1
                    colorindex+=1
                    if colorindex == colors.count {
                        colorindex = 0
                    }
                } else {
                    number+=1
                }
                actnums.append(number)
                actions.append(CircleAction(obj: obj as! HitCircle))
                actcols.append(colors[colorindex])
                break
            case .Slider:
                if obj.newCombo {
                    number=1
                    colorindex+=1
                    if colorindex == colors.count {
                        colorindex = 0
                    }
                } else {
                    number+=1
                }
                actnums.append(number)
                actions.append(SliderAction(obj: obj as! Slider, timing: beatmap.getTimingPoint(offset: obj.time)))
                actcols.append(colors[colorindex])
                break
            case .Spinner:
                break
            case .None:
                break
            }
        }
        ActionSet.current=self
    }
    
    public func prepare() {
        var layer:CGFloat = 100000
        for i in 0...actions.count-1 {
            actions[i].prepare(color: actcols[i], number: actnums[i], layer: layer)
            layer-=1
        }
    }
    
    public func hasnext() -> Bool {
        return nextindex<actions.count
    }
    
    //In ms
    public func shownext(offset:Double) {
        if offset >= 0 {
            actions[nextindex].show(scene: scene, offset: offset)
        }
        nextindex+=1
    }
    
    public func nexttime() -> Double {
        if nextindex < actions.count {
            return actions[nextindex].gettime()
        }
        return Double(Int.max)
    }
    
    public var pointer=0
    public func currentact() -> HitObjectAction? {
        if pointer<actions.count {
            return actions[pointer]
        }
        return nil
    }
    
}
