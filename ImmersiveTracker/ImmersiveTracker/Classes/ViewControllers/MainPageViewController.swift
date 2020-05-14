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
    case tracking, 開始追蹤
    case vr = "virtual reality", 開始
    case setting, 設定
}


class MainPageViewController: ImmersiveVoiceControl {
    
    
    override func voiceCommandDetected(str: String) {
        if let speechWord = SpeechWords.init(rawValue: str.lowercased()){
             let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewControllerDIdentifier") as? TrackerViewController
                {
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
           
        
    

    override func viewDidLoad() {
        self.voiceCommand?.startRecognition()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
