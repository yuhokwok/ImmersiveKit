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







/// Simple Voice control class based on SpeechRecognizer
open class ImmersiveVoiceControl: UIViewController, ImmersiveVoiceSpeechRecognizerDelegate   {
    
    
    public var voiceCommand : ImmersiveSpeechRecognizer?
    
    
    enum SpeechWords: String {
        case tracking, 開始追蹤, 返回
        case vr = "virtual reality", 開始虛擬實境
        case setting, 設定
    }
    
   
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = Locale(identifier: "zh-hk")
        self.voiceCommand = ImmersiveSpeechRecognizer(locale: locale, keyPhrases: ["tracking"])
        self.voiceCommand?.grandPermission()
        self.voiceCommand?.voiceCommandDelegate = self
        self.voiceCommand?.startRecognition()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        self.voiceCommand?.stopRecognition()
        super.viewDidDisappear(animated)
    }
    
    
    

    
    //MARK: - ImmersiveVoiceSpeechRecognizerDelegate
    open func voiceCommandDetected(str: String){
       if let speechWord = SpeechWords.init(rawValue: str.lowercased()){
       print("match the SpeechWords - \(speechWord.rawValue)")
     }
  }
}

