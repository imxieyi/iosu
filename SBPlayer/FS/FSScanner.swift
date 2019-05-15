//
//  FSScanner.swift
//  SBPlayer
//
//  Created by 谢宜 on 2019/5/15.
//  Copyright © 2019 xieyi. All rights reserved.
//

import Foundation
import Logging

class FSScanner {
    
    let logger: Logger
    let documentPath: URL
    
    var fileIDList = Set<Int64>()
    
    // For further processing
    var newFileList: [FileEntry] = []
    var deletedFileList: [FileEntry] = []
    var updatedFileList: [FileEntry] = []
    
    init() {
        logger = Logger(label: "FileSystem")
        documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func scan() {
        fileIDList.removeAll()
        newFileList = []
        deletedFileList = []
        updatedFileList = []
        logger.info("Start FS scanner: \(documentPath.path)")
        scan(documentPath.path, prefix: "")
        logger.info("Scanning for deleted files")
        FileEntry.forEach { (entry) in
            if !fileIDList.contains(entry.id) {
                entry.delete()
                deletedFileList.append(entry)
            }
        }
        logger.info("Finished FS scanner. \(newFileList.count) added, \(deletedFileList.count) deleted, \(updatedFileList.count) updated")
    }
    
    private func scan(_ root: String, prefix: String) {
        do {
            let entries = try FileManager.default.contentsOfDirectory(atPath: root)
            var isDirectory = ObjCBool(true)
            for entry in entries {
                let relativePath = prefix + (prefix == "" ? "" : "/") + URL(fileURLWithPath: entry).lastPathComponent
                let absolutePath = documentPath.path + "/" + relativePath
                if !FileManager.default.fileExists(atPath: absolutePath, isDirectory: &isDirectory) {
                    continue
                }
                if isDirectory.boolValue {
                    scan(absolutePath, prefix: relativePath)
                } else {
                    do {
                        let attrs = try FileManager.default.attributesOfItem(atPath: absolutePath)
                        let size = Int64(truncating: attrs[.size] as? NSNumber ?? 0)
                        let modificationDate = (attrs[.modificationDate] as? NSDate) as Date? ?? Date(timeIntervalSince1970: 0)
                        if let fileEntry = FileEntry.get(relativePath, ignoreCase: false) {
                            // Entry exists in database
                            if fileEntry.size != size || fileEntry.lastModification != modificationDate {
                                logger.debug("Updated: \(relativePath)")
                                if let newEntry = fileEntry.update(size: size, lastModification: modificationDate) {
                                    updatedFileList.append(newEntry)
                                    fileIDList.insert(newEntry.id)
                                } else {
                                    logger.error("Failed to update metadata for \(relativePath)")
                                }
                            } else {
                                logger.debug("Existed: \(relativePath)")
                                fileIDList.insert(fileEntry.id)
                            }
                        } else {
                            // New entry
                            let fileEntry = FileEntry(relativePath: relativePath, size: size, lastModification: modificationDate)
                            if let newEntry = fileEntry.insert() {
                                logger.debug("New: \(relativePath)")
                                newFileList.append(newEntry)
                                fileIDList.insert(newEntry.id)
                            } else {
                                logger.error("Failed to insert new entry: \(relativePath)")
                            }
                        }
                    } catch let error {
                        logger.error("Failed to get metadata from \(relativePath): \(error.localizedDescription)")
                    }
                }
            }
        } catch let error {
            logger.error("Failed to scan \(root)")
            logger.error("\(error)")
        }
    }
    
}
