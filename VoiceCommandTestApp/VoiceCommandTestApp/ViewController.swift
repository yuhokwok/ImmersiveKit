//
//  ViewController.swift
//  VoiceCommandTestApp
//
//  Created by ImmersiveKit Team on 17/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Speech
import ImmersiveKit

enum SpeechWords: String {
    case tracking, 開始追蹤
    case vr = "virtual reality", 開始虛擬實境
    case setting, 設定
}

class ViewController: ImmersiveVoiceControl {
    
    override func voiceCommandDetected(str: String) {
        if let speechWord = SpeechWords.init(rawValue: str.lowercased()){
            print("match the SpeechWords - \(speechWord.rawValue)")
        }
    }
    
    @IBOutlet weak var tv: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logTextView = self.tv
//        let locale = Locale(identifier: "en-hk")
//        self.voiceCommand = ImmersiveSpeechRecognizer(locale: locale, keyPhrases: ["ImmersiveVoiceControl (en-hk)"])
//        self.voiceCommand?.grandPermission()
//        self.voiceCommand?.voiceCommandDelegate = self
    }

    @IBAction func clicked(_ sender: Any) {
        self.voiceCommand?.startRecognition()
    }

}

