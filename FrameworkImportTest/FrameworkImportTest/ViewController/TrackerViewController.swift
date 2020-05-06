//
//  ViewController.swift
//  FrameworkImportTest
//
//  Created by Jason Chow on 17/1/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import UIKit
import ImmersiveKit
import RealityKit
import ARKit
import Combine

class TrackerViewController: ImmersiveBodyTrackerNetworkViewController {
    
    @IBOutlet var tv: UITextView!
    
    //MARK: - ImmersiveNetworkAgentProvider
    override var networkAgentShouldAutoRun: Bool {
        return true
    }
    
    public override func networkAgentForTracking() -> ImmersiveNetworkCore? {
        return ImmersiveServer(type: SERV_TYPE, domain: SERV_DOMAIN, port: SERV_PORT)
    }
    
    //MARK: -
    override func viewDidLoad() {
        logTextView = self.tv
        super.viewDidLoad()
        self.networkAgent?.canWriteWithDropFrame = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        
        var cancellable: AnyCancellable? = nil
        
        #if !targetEnvironment(simulator)
        cancellable = Entity.loadBodyTrackedAsync(named: "robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.bodyTracker?.body = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
        #endif
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        super.viewWillDisappear(animated)
    }
    
    //MARK: -- Immersive Network Debug
    public override func report(msg : String) {
        printLog(msg)
    }
}

