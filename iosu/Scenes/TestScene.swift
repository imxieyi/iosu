//
//  TestScene.swift
//  iosu
//
//  Created by xieyi on 2017/4/7.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TestScene:SKScene {
    
    let spinner_appcircle = SKSpriteNode(imageNamed: "spinner-approachcircle")
    let spinner_bottom = SKSpriteNode(imageNamed: "spinner-bottom")
    let spinner_clear = SKSpriteNode(imageNamed: "spinner-clear")
    let spinner_glow = SKSpriteNode(imageNamed: "spinner-glow")
    let spinner_middle = SKSpriteNode(imageNamed: "spinner-middle")
    let spinner_middle2 = SKSpriteNode(imageNamed: "spinner-middle2")
    let spinner_spin = SKSpriteNode(imageNamed: "spinner-spin")
    let spinner_top = SKSpriteNode(imageNamed: "spinner-top")
    
    var scrscale:CGFloat {
        return size.height/480
    }
    var realwidth:CGFloat {
        return 512*scrscale
    }
    var realheight:CGFloat {
        return 384*scrscale
    }
    var bottomedge:CGFloat {
        return (size.height - realheight)/2
    }
    var leftedge:CGFloat {
        return (size.width - realwidth)/2
    }
    var center:CGPoint {
        return CGPoint(x: leftedge + realwidth/2, y: bottomedge + realheight/2)
    }
    
    override func sceneDidLoad() {
        spinner_glow.size = CGSize(width: realheight*0.85, height: realheight*0.85)
        spinner_glow.position = center
        spinner_glow.zPosition = 0
        addChild(spinner_glow)
        spinner_bottom.size = CGSize(width: realheight*2/3, height: realheight*2/3)
        spinner_bottom.position = center
        spinner_bottom.zPosition = 1
        addChild(spinner_bottom)
        spinner_top.size = CGSize(width: realheight*2/3, height: realheight*2/3)
        spinner_top.position = center
        spinner_top.zPosition = 2
        addChild(spinner_top)
        spinner_middle2.size = CGSize(width: realheight/50, height: realheight/50)
        spinner_middle2.position = center
        spinner_middle2.zPosition = 3
        addChild(spinner_middle2)
        spinner_middle.size = CGSize(width: realheight*2/3*1.012, height: realheight*2/3*1.012)
        spinner_middle.position = center
        spinner_middle.zPosition = 4
        addChild(spinner_middle)
        spinner_spin.setScale(realheight/800)
        spinner_spin.position = CGPoint(x: leftedge + realwidth/2, y: bottomedge + realheight/3.6)
        spinner_spin.zPosition = 5
        addChild(spinner_spin)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("touch")
    }
    
    var firstrun=true
    
    override func update(_ currentTime: TimeInterval) {
    }
    
}
