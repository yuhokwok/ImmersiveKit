//
//  ImmersiveNetworkViewController.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 21/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import SceneKit


open class ImmersiveNetworkViewController: ImmersiveViewController, ImmersiveDataReceiverDelegate, ImmersiveKitDebugging, ImmersiveNetworkAgentProvider {
    
    public var initialBody : Body?
    
    public var isReadyToReceive = false
    public var networkAgent : ImmersiveNetworkCore?
            
    //MARK: - ImmersiveNetworkAgentProvider
    open var networkAgentShouldAutoRun: Bool {
        return false
    }
    
    open func networkAgentForTracking() -> ImmersiveNetworkCore? {
        return nil
    }

    //MARK: Life Cycle Function
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        guard let networkAgent = networkAgentForTracking() else {
            ImmersiveCore.print(msg: "No Network Agent, Please override networkAgentForTracking and Create One")
            return
        }
        
        self.networkAgent = networkAgent
        self.networkAgent?.debugDelegate = self
        self.networkAgent?.receiverDelegate = self
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
        self.networkAgent?.receiverDelegate = nil
        networkAgent?.stop()
        ImmersiveCore.print(msg: "network agent stopped")
        super.viewDidDisappear(animated)
    }

    //MARK: - ImmersiveDataReceiverDelegate
    //receive Body Data
    open func bodyReceived(body: Body) {
        //ImmersiveCore.print(msg: "body received")
        guard isReadyToReceive else {
            return
        }
        
        if initialBody == nil {
            self.initialBody = body
        }
        
        let diffX = body.hipWorldPosition.simdFloat4x4().coordinate().x - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().x
        let diffY = body.hipWorldPosition.simdFloat4x4().coordinate().y - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().y
        let diffZ = body.hipWorldPosition.simdFloat4x4().coordinate().z - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().z
        
        let pos = SCNVector3(diffX, diffY, diffZ)//body.hipWorldPosition.simdFloat4x4().coordinate()
        self.movePlayer(to: pos)
    }
    
    //receive camera setting data
    open func cameraSettingReceived(setting: VRCameraSetting) {
        self.immersiveWorld?.player.cameraNode.setCameraSetting(setting)
    }
    
    //return data
    open func dataReceived(data: Data) {
        ImmersiveCore.print(msg: "data received")
    }
    
    //debug use
    open func report(msg: String) {
      
    }
}
