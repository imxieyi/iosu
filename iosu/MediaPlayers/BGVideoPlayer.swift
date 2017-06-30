//
//  BGVideoPlayer.swift
//  iosu
//
//  Created by xieyi on 2017/4/11.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import SpriteKit

class BGVPlayer : VLCMediaPlayerDelegate {
    
    //static var vplayer=KSYMoviePlayerController(contentURL: URL(fileURLWithPath: ""))
    static var view:UIView?
    static var mplayer = VLCMediaPlayer()
    
    static func initialize() {
        view = UIView()
        view?.backgroundColor = .clear
        view?.frame = UIScreen.screens[0].bounds
        mplayer.drawable = view
        mplayer.audio.isMuted = true
        view?.isHidden = true
    }
    
    static func setcontent(_ file:String) -> SKAction {
        return SKAction.run {
            let media = VLCMedia(path: file)
            mplayer.media = media
            let notification=NotificationCenter.default
            let operationQueue=OperationQueue.main
            _ = notification.addObserver(forName: NSNotification.Name(rawValue: VLCMediaPlayerStateChanged), object: nil, queue: operationQueue, using: {(notif) in
                //Stopped
                if mplayer.state.rawValue == 0 {
                    mplayer.media = nil
                    view?.isHidden = true
                }
            })
        }
    }
    
    static func play() -> SKAction {
        return SKAction.run {
            mplayer.play()
            view?.isHidden = false
        }
    }
    
}
