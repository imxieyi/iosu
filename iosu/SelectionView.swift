//
//  SelectionView.swift
//  iosu
//
//  Created by xieyi on 2017/4/3.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import UIKit

class SelectionViewController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var picker: UIPickerView!
    
    let bs=BeatmapScanner()
    
    override func viewDidLoad() {
        picker.dataSource=self
        picker.delegate=self
        UIApplication.shared.isIdleTimerDisabled=true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bs.beatmaps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bs.beatmaps[row]
    }
    
    @IBAction func PlayosuPressed(_ sender: Any) {
        GamePlayScene.testBMIndex=picker.selectedRow(inComponent: 0)
        GameViewController.sbmode=false
        self.performSegue(withIdentifier: "play", sender: self.view)
    }
    
    @IBAction func playSBPressed(_ sender: Any) {
        StoryBoardScene.testBMIndex=picker.selectedRow(inComponent: 0)
        self.performSegue(withIdentifier: "play", sender: self.view)
        //let play=self.storyboard?.instantiateViewController(withIdentifier: "game") as! GameViewController
        //self.navigationController?.pushViewController(play, animated: true)
    }
    
}
