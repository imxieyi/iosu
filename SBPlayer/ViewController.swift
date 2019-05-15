//
//  ViewController.swift
//  SBPlayer
//
//  Created by 谢宜 on 2019/5/15.
//  Copyright © 2019 xieyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            try DB.initialize()
            let scanner = FSScanner()
            scanner.scan()
        } catch let error {
            DB.logger.critical("Failed to initialize database: \(error.localizedDescription)")
        }
    }

    @IBAction func deleteDB(_ sender: Any) {
        let libPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let dbPath = libPath.appendingPathComponent("iosu.db")
        try! FileManager.default.removeItem(at: dbPath)
    }
    
    @IBAction func copyDB(_ sender: Any) {
        let libPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let dbPath = libPath.appendingPathComponent("iosu.db")
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let copyPath = docPath.appendingPathComponent("iosu.db")
        try! FileManager.default.copyItem(at: dbPath, to: copyPath)
    }
}

