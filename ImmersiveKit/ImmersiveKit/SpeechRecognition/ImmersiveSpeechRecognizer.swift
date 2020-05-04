//
//  ImmersiveSpeechRecognition.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 15/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import AVFoundation
import Speech

public protocol ImmersiveVoiceSpeechRecognizerDelegate {
    func voiceCommandDetected(str: String)
}


/// Class for quick on-device recognition setup
public class ImmersiveSpeechRecognizer {
    public var recognizer : SFSpeechRecognizer?
    var request : SFSpeechAudioBufferRecognitionRequest
    var recoginitionTask : SFSpeechRecognitionTask?
    var audioEngine : AVAudioEngine?
    var voiceCommandDelegate : ImmersiveVoiceSpeechRecognizerDelegate?
    var commands : [String] = [String]()
    
    
    public init?(locale : Locale, partialResults : Bool = true, keyPhrases : [String]?) {
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
        request.shouldReportPartialResults = partialResults
        request.requiresOnDeviceRecognition = true
        request.contextualStrings = keyPhrases ?? []
        
        
        
        self.recognizer = recognizer
        
        ImmersiveCore.printer?.debugPrint(msg:"\(request.contextualStrings)")
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
                self.voiceCommandDelegate?.voiceCommandDetected(str: result.bestTranscription.formattedString)
                if result.isFinal {
                    ImmersiveCore.printer?.debugPrint(msg: "\(result.bestTranscription.formattedString) - Final")
                } else {
                    ImmersiveCore.printer?.debugPrint(msg: result.bestTranscription.formattedString)
                }
                
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
