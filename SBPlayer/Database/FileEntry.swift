//
//  FileEntry.swift
//  SBPlayer
//
//  Created by 谢宜 on 2019/5/15.
//  Copyright © 2019 xieyi. All rights reserved.
//

import Foundation
import SQLite
import Logging

struct FileEntry {
    
    private static let table = Table("fs")
    
    // Database table columns
    static let ID = Expression<Int64>("id")
    static let RelativePath = Expression<String>("relativePath")
    static let LowerCasePath = Expression<String>("lowerCasePath")
    static let Size = Expression<Int64>("size")
    static let LastModification = Expression<Date>("lastModification")
    
    // Class fields
    let id: Int64
    let relativePath: String
    let size: Int64
    let lastModification: Date
    
    static func createTable(_ connection: Connection) throws {
        let tableBuilder = FileEntry.table.create(ifNotExists: true) { tb in
            tb.column(ID, primaryKey: .autoincrement)
            tb.column(RelativePath, unique: true)
            tb.column(LowerCasePath)
            tb.column(Size)
            tb.column(LastModification)
        }
        try connection.run(tableBuilder)
        var indexBuilder = FileEntry.table.createIndex(RelativePath, unique: true, ifNotExists: true)
        try connection.run(indexBuilder)
        indexBuilder = FileEntry.table.createIndex(LowerCasePath, unique: false, ifNotExists: true)
        try connection.run(indexBuilder)
    }
    
    init(id: Int64 = 0, relativePath: String, size: Int64, lastModification: Date) {
        self.id = id
        self.relativePath = relativePath
        self.size = size
        self.lastModification = lastModification
    }
    
    func insert() -> FileEntry? {
        let insert = FileEntry.table.insert(FileEntry.RelativePath     <- relativePath,
                                            FileEntry.LowerCasePath    <- relativePath.lowercased(),
                                            FileEntry.Size             <- size,
                                            FileEntry.LastModification <- lastModification)
        do {
            let id = try DB.shared.connection.run(insert)
            return FileEntry.get(id)
        } catch let error {
            DB.logger.error("\(error)")
        }
        return nil
    }
    
    private static func get(_ row: Row) -> FileEntry {
        return FileEntry(id: row[FileEntry.ID], relativePath: row[FileEntry.RelativePath],
                         size: row[FileEntry.Size], lastModification: row[FileEntry.LastModification])
    }
    
    static func get(_ relativePath: String, ignoreCase: Bool = true) -> FileEntry? {
        do {
            // First try case sensitive
            var filtered = FileEntry.table.filter(FileEntry.RelativePath == relativePath)
            for row in try DB.shared.connection.prepare(filtered) {
                return get(row)
            }
            // If failed, try case insensitive
            if ignoreCase {
                filtered = FileEntry.table.filter(FileEntry.LowerCasePath == relativePath.lowercased())
                for row in try DB.shared.connection.prepare(filtered) {
                    let actualPath = row[FileEntry.RelativePath]
                    DB.logger.debug("\(relativePath) should be \(actualPath)")
                    return get(row)
                }
            }
        } catch let error {
            DB.logger.error("\(error)")
        }
        return nil
    }
    
    static func get(_ id: Int64) -> FileEntry? {
        do {
            let filtered = FileEntry.table.filter(FileEntry.ID == id)
            for row in try DB.shared.connection.prepare(filtered) {
                return get(row)
            }
        } catch let error {
            DB.logger.error("\(error)")
        }
        return nil
    }
    
    static func forEach(_ callback: (FileEntry) -> Void) {
        do {
            for row in try DB.shared.connection.prepare(table) {
                callback(get(row))
            }
        } catch let error {
            DB.logger.error("\(error)")
        }
    }
    
    func update(size: Int64, lastModification: Date) -> FileEntry? {
        let update = FileEntry.table.filter(FileEntry.ID == id)
                     .update(FileEntry.Size             <- size,
                             FileEntry.LastModification <- lastModification)
        do {
            try DB.shared.connection.run(update)
            return FileEntry.get(id)
        } catch let error {
            DB.logger.error("\(error)")
        }
        return nil
    }
    
    func delete() {
        do {
            let filtered = FileEntry.table.filter(FileEntry.ID == id)
            try DB.shared.connection.run(filtered.delete())
        } catch let error {
            DB.logger.error("\(error)")
        }
    }
    
}
