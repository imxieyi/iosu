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
    
    fileprivate var actions:[HitObjectAction]=[]
    fileprivate var actnums:[Int] = []
    fileprivate var actcols:[UIColor] = []
    fileprivate weak var scene:SKScene!
    fileprivate var nextindex:Int=0
    open static weak var difficulty:BMDifficulty?
    open static weak var current:ActionSet?
    
    func destroy() {
        for act in actions {
            act.destroy()
        }
        actions.removeAll()
    }
    
    init(beatmap:Beatmap,scene:SKScene) {
        ActionSet.difficulty = beatmap.difficulty
        self.scene=scene
        let colors=beatmap.colors
        var colorindex=0
        var number=0
        for obj in beatmap.hitobjects {
            switch obj.type {
            case .circle:
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
            case .slider:
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
                actions.append(SliderAction(obj: obj as! Slider, timing: beatmap.getTimingPoint(obj.time)))
                actcols.append(colors[colorindex])
                break
            case .spinner:
                break
            case .none:
                break
            }
        }
        ActionSet.current=self
    }
    
    open func prepare() {
        var layer:CGFloat = 100000
        for i in 0...actions.count-1 {
            actions[i].prepare(actcols[i], number: actnums[i], layer: layer)
            layer-=1
        }
    }
    
    open func hasnext() -> Bool {
        return nextindex<actions.count
    }
    
    //In ms
    open func shownext(_ offset:Double) {
        if offset >= 0 {
            actions[nextindex].show(scene, offset: offset)
        }
        nextindex+=1
    }
    
    open func nexttime() -> Double {
        if nextindex < actions.count {
            return actions[nextindex].gettime()
        }
        return Double(Int.max)
    }
    
    open var pointer=0
    open func currentact() -> HitObjectAction? {
        if pointer<actions.count {
            return actions[pointer]
        }
        return nil
    }
    
}
