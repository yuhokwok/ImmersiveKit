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

class ViewController: ImmersiveVoiceControl {
    
    override func voiceCommandDetected(str: String) {
        print("!!! - \(str)")
    }
    

//    var voiceCommand : ImmersiveSpeechRecognizer?
    
    @IBOutlet weak var tv: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logTextView = self.tv
        // Do any additional setup after loading the view.
//        let locale = Locale(identifier: "zh-hk")
//        self.voiceCommand = ImmersiveSpeechRecognizer(locale: locale, keyPhrases: ["津路"])
//        self.voiceCommand?.grandPermission()
    }

    @IBAction func clicked(_ sender: Any) {
        self.voiceCommand?.startRecognition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.voiceCommand?.stopRecognition()
        super.viewDidDisappear(animated)
    }
}

