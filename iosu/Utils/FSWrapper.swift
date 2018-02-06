//
//  FSWrapper.swift
//  iosu
//
//  Created by 谢宜 on 2018/2/5.
//  Copyright © 2018年 xieyi. All rights reserved.
//

import Foundation
import SQLite

struct FSWrapper {
    
    public static let shared = FSWrapper()
    
    // Database entry
    let fs_list = Table("fs_list")
    let id = Expression<Int64>("id")
    let father = Expression<Int64?>("father")
    let entry = Expression<String>("entry")
    let type = Expression<String>("type")
    let fullpath = Expression<String>("fullpath")
    let size = Expression<Int64>("size")
    
    public func update() {
        let _ = try? Database.shared.db.run(fs_list.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(father, defaultValue: nil)
            t.column(entry)
            t.column(type)
            t.column(fullpath, unique: true)
            t.column(size)
        })
        let document = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)!
        scan(document)
    }
    
    public func scan(_ path: URL) {
        
    }
    
}

enum FileType: String {
    case osu = "osu"
    case osb = "osb"
    case audio = "audio"
    case video = "video"
    case image = "image"
    case others = "others"
}
