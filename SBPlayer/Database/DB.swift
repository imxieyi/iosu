//
//  DB.swift
//  SBPlayer
//
//  Created by 谢宜 on 2019/5/15.
//  Copyright © 2019 xieyi. All rights reserved.
//

import Foundation
import SQLite
import Logging

class DB {
    
    public static private(set) var shared: DB!
    
    let connection: Connection
    
    static let logger = Logger(label: "Database")
    
    static func initialize() throws {
        if shared == nil {
            shared = try DB()
            try FileEntry.createTable(shared.connection)
        }
    }
    
    private init() throws {
        let libPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let dbPath = libPath.appendingPathComponent("iosu.db")
        DB.logger.info("database path: \(dbPath.path)")
        connection = try Connection(dbPath.path)
    }
    
}
