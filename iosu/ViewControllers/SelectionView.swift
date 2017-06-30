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
    
    @IBOutlet var gameSwitch: UISwitch!
    @IBOutlet var videoSwitch: UISwitch!
    @IBOutlet var sbSwitch: UISwitch!
    @IBOutlet var dimSlider: UISlider!
    @IBOutlet var dimLabel: UILabel!
    @IBOutlet var musicSlider: UISlider!
    @IBOutlet var musicLabel: UILabel!
    @IBOutlet var effectSlider: UISlider!
    @IBOutlet var effectLabel: UILabel!
    
    @IBOutlet var skinSwitch: UISwitch!
    
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

    @IBAction func playPressed(_ sender: Any) {
        SkinBuffer.bmPath = bs.beatmapdirs[picker.selectedRow(inComponent: 0)]
        SkinBuffer.useSkin = skinSwitch.isOn
        GamePlayScene.testBMIndex = picker.selectedRow(inComponent: 0)
        StoryBoardScene.testBMIndex = picker.selectedRow(inComponent: 0)
        GamePlayScene.bgdim = Double(dimSlider.value)/100
        GameViewController.showgame = gameSwitch.isOn
        GameViewController.showvideo = videoSwitch.isOn
        GameViewController.showsb = sbSwitch.isOn
        BGMusicPlayer.bgmvolume = musicSlider.value/100
        GamePlayScene.effvolume = effectSlider.value/100
        self.performSegue(withIdentifier: "play", sender: self.view)
    }
    
    @IBAction func dimChanged(_ sender: UISlider) {
        dimLabel.text = "\(Int(sender.value))%"
    }
    
    @IBAction func musicChanged(_ sender: UISlider) {
        musicLabel.text = "\(Int(sender.value))%"
    }
    
    @IBAction func effectChanged(_ sender: UISlider) {
        effectLabel.text = "\(Int(sender.value))%"
    }
    
    @IBAction func gameSwitched(_ sender: Any) {
        if !sbSwitch.isOn && !gameSwitch.isOn {
            Alerts.show(self, title: "Warning", message: "You should turn on either game or storyboard!", style: .alert, actiontitle: "OK", actionstyle: .default, handler: {(act:UIAlertAction) -> Void in
                self.gameSwitch.setOn(true, animated: true)
                self.skinSwitch.isEnabled = true
            })
        }
        if gameSwitch.isOn {
            skinSwitch.isEnabled = true
        } else {
            skinSwitch.isEnabled = false
        }
    }
    @IBAction func sbSwitched(_ sender: Any) {
        if !sbSwitch.isOn && !gameSwitch.isOn {
            Alerts.show(self, title: "Warning", message: "You should turn on either game or storyboard!", style: .alert, actiontitle: "OK", actionstyle: .default, handler: {(act:UIAlertAction) -> Void in
                self.sbSwitch.setOn(true, animated: true)
            })
        }
    }
    
}
