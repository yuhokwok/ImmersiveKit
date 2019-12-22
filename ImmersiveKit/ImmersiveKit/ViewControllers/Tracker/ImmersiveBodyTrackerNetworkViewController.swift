//
//  ImmersiveBodyTrackerViewController.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 12/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

open class ImmersiveBodyTrackerNetworkViewController: ImmersiveBodyTrackerViewController, ImmersiveDataReceiverDelegate, ImmersiveKitDebugging, ImmersiveNetworkAgentProvider {
    
    
    //MARK: - ImmersiveNetworkAgentProvider
    open var networkAgentShouldAutoRun: Bool {
        return false
    }
    
    open func networkAgentForTracking() -> ImmersiveNetworkCore? {
        return nil
    }
    
    open var networkAgent : ImmersiveNetworkCore?
    
    
    //MARK: - Live Cycle Functions
    open override func viewDidLoad() {
        super.viewDidLoad()

        guard let networkAgent = networkAgentForTracking() else {
            ImmersiveCore.print(msg: "No Network Agent, Please override networkAgentForTracking and Create One")
            return
        }
        
        
        self.networkAgent = networkAgent
        self.networkAgent?.debugDelegate = self
        self.networkAgent?.receiverDelegate = self
        self.bodyTracker?.delegate = self.networkAgent
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (networkAgentShouldAutoRun) {
            self.runNetworkAgent()
        }
    }
    
    open func runNetworkAgent() {
        do {
            try self.networkAgent?.start()
            ImmersiveCore.print(msg: "network agent started")
        } catch {
            ImmersiveCore.print(msg: "can't start network agent")
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        self.networkAgent?.stop()
        self.networkAgent?.receiverDelegate = nil
        self.networkAgent?.debugDelegate = nil
        super.viewWillDisappear(animated)
    }
    
    //MARK: - ImmersiveDataReceiverDelegate
    open func bodyReceived(body: Body) {
        
    }
    
    open func cameraSettingReceived(setting: VRCameraSetting) {
        
    }
    
    open func dataReceived(data: Data) {
        
    }
    
    //MARK: -- Immersive Network Debug
    open func report(msg: String) {
        
    }
    
}
