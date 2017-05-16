//
//  MovingImage.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class MovingImage:BasicImage {
    
    var framecount:Int
    var framedelay:Double
    var looptype:LoopType
    var paths:[String]=[]
    
    init(layer:SBLayer,rlayer:Double,origin:SBOrigin,filepath:String,x:Double,y:Double,framecount:Int,framedelay:Double,looptype:LoopType) {
        self.framecount=framecount
        self.framedelay=framedelay
        self.looptype=looptype
        super.init(layer: layer, rlayer: rlayer, origin: origin, filepath: filepath, x: x, y: y,isanimation:true)
    }
    
    override func convertsprite() {
        let ext=filepath.components(separatedBy: ".").last
        let extlen=ext?.lengthOfBytes(using: .utf8)
        for i in 0...framecount-1 {
            var path=filepath.substring(to:filepath.index(filepath.endIndex, offsetBy: -(extlen!+1)))
            path+="\(i)."+ext!
            paths.append(path)
        }
        filepath=paths.first!
        super.convertsprite()
    }
    
    func animate(){
        var textures:[SKTexture]=[]
        for path in paths {
            let image=ImageBuffer.get(file: path)
            if(image==nil){
                continue
            }
            textures.append(image!)
        }
        if(textures.count==0){
            return
        }
        var animateaction=SKAction.animate(with: textures, timePerFrame: framedelay/1000)
        switch looptype {
        case .LoopForever:
            animateaction=SKAction.repeatForever(animateaction)
        case .LoopOnce:
            break
        }
        actions=SKAction.group([animateaction,actions!])
    }
    
}
