//
//  ImmersiveSpeechRecognition.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 15/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import AVFoundation
import Speech

public class ImmersiveSpeechRecognizer {
    public var recognizer : SFSpeechRecognizer?
    var request : SFSpeechAudioBufferRecognitionRequest
    var recoginitionTask : SFSpeechRecognitionTask?
    var audioEngine : AVAudioEngine?
    
    public init?(locale : Locale) {
        guard let recognizer = SFSpeechRecognizer(locale: locale) else {
            return nil
        }
        
        
        guard recognizer.isAvailable == true else {
            return nil
        }
        
        guard recognizer.supportsOnDeviceRecognition else {
            return nil
        }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = true
        self.recognizer = recognizer
        
        self.audioEngine = AVAudioEngine()
    }
    
    public func startRecognition() {
        //setup audio engine and speech recognizer
        guard let node = audioEngine?.inputNode else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            buffer, _ in
            self.request.append(buffer)
        }
        
        //prepare and start recording
        audioEngine?.prepare()
        do {
            try audioEngine?.start()
        } catch {
            return print(error)
        }
        
        //Analyze the speech
        recoginitionTask = self.recognizer?.recognitionTask(with:  request, resultHandler: {
            result, error in
            if let result = result {
                print(result.bestTranscription.formattedString)
            } else if let error = error {
                print(error)
            }
        })
    }
    
    public func stopRecognition() {
        audioEngine?.stop()
        if let node = self.audioEngine?.inputNode {
            node.removeTap(onBus: 0)
        }
        self.recoginitionTask?.cancel()
    }
    
    public func grandPermission() {
        if SFSpeechRecognizer.authorizationStatus() == .authorized {
            return
        }
        
        SFSpeechRecognizer.requestAuthorization{
            status in
            switch status {
            case .authorized:
                print("authorized")
            default:
                print("unavailable")
            }
        }
    }

}
