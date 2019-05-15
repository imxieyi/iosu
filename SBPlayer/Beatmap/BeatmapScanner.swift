//
//  BeatmapScanner.swift
//  SBPlayer
//
//  Created by 谢宜 on 2019/5/15.
//  Copyright © 2019 xieyi. All rights reserved.
//

import Foundation
import Logging

class BeatmapScanner {
    
    let logger = Logger(label: "BeatmapScanner")
    
    let fsScanner: FSScanner
    
    init(fsScanner: FSScanner) {
        self.fsScanner = fsScanner
    }
    
    func scan() {
        
    }
    
}
