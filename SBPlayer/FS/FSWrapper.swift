//
//  FSWrapper.swift
//  SBPlayer
//
//  Created by 谢宜 on 2019/5/15.
//  Copyright © 2019 xieyi. All rights reserved.
//

import Foundation

class FSWrapper {
    
    static func getRealPath(_ path: String) -> String? {
        return FileEntry.get(path)?.relativePath
    }
    
}
