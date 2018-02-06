//
//  Database.swift
//  iosu
//
//  Created by 谢宜 on 2018/2/6.
//  Copyright © 2018年 xieyi. All rights reserved.
//

import Foundation
import SQLite

struct Database {
    
    public static let shared = Database()
    let db: Connection
    
    init() {
        do {
            guard let dbpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("iosu.db") else {
                fatalError("Failed to get document directory path!")
            }
            db = try Connection(dbpath.path)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
}
