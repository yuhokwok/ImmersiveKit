//
//  MainPageViewController.swift
//  ImmersiveTracker
//
//  Created by chan CHAKFUNG on 14/5/2020.
//  Copyright © 2020 ImmersiveKit Team. All rights reserved.
//

import UIKit
import ImmersiveKit
import AVFoundation
import Speech



enum SpeechWords: String {
    case tracking, 跟蹤
    case vr = "virtual reality", 遊玩
    case setting, 設定
}


class MainPageViewController: ImmersiveVoiceControl {
    
    
    override func voiceCommandDetected(str: String) {
        if let speechWord = SpeechWords.init(rawValue: str.lowercased()){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            switch speechWord {
            case .tracking, .跟蹤:
                if let vc = mainStoryboard.instantiateViewController(withIdentifier: "TrackerViewController") as? TrackerViewController{
                    self.voiceCommand?.stopRecognition()
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .vr, .遊玩:
                if let vc = mainStoryboard.instantiateViewController(withIdentifier: "VRPlayerViewController") as? VRPlayerViewController{
                    self.voiceCommand?.stopRecognition()
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .setting, .設定:
                if let vc = mainStoryboard.instantiateViewController(withIdentifier: "CamSettingClientViewController") as? CamSettingClientViewController{
                    self.voiceCommand?.stopRecognition()
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        self.voiceCommand?.startRecognition()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
