//
//  ImmersiveVoiceControl.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 17/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Speech

enum SpeechWords: String {
    case 開始檢查
    case 開始遊玩
    case 設定
}


/// Simple Voice control class based on SpeechRecognizer
open class ImmersiveVoiceControl: UIViewController, ImmersiveVoiceSpeechRecognizerDelegate {
    
    open func voiceCommandDetected(str: String) {
        
    }
    
    open var voiceCommand : ImmersiveSpeechRecognizer?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let locale = Locale(identifier: "zh-hk")
        self.voiceCommand = ImmersiveSpeechRecognizer(locale: locale, keyPhrases: ["津路"])
        self.voiceCommand?.grandPermission()
        self.voiceCommand?.voiceCommandDelegate = self
    }
    
}
