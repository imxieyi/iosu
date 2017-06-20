//
//  BGVideoPlayer.swift
//  iosu
//
//  Created by xieyi on 2017/4/11.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class BGVPlayer {
    
    static var vplayer=KSYMoviePlayerController(contentURL: URL(fileURLWithPath: ""))
    
    static func setcontent(file:String) -> SKAction {
        return SKAction.run {
            vplayer?.reset(false)
            vplayer?.setUrl(URL(fileURLWithPath: file))
            vplayer?.controlStyle = .none
            vplayer?.setVolume(0, rigthVolume: 0)
            vplayer?.shouldAutoplay=true
            vplayer?.scalingMode = .aspectFill
            let notification=NotificationCenter.default
            let operationQueue=OperationQueue.main
            let observer=notification.addObserver(forName: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil, queue: operationQueue, using: {(notif) in
                vplayer?.reset(false)
            })
        }
    }
    
    static func play() -> SKAction {
        return SKAction.run {
            debugPrint("start playing video \(vplayer?.contentURL.absoluteString)")
            vplayer!.prepareToPlay()
        }
    }
    
}
