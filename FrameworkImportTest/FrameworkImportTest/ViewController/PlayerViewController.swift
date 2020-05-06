//
//  PlayerViewController.swift
//  FrameworkImportTest
//
//  Created by Jason Chow on 23/3/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import UIKit
import ImmersiveKit
import SceneKit

class PlayerViewController: ImmersivePlayerNetworkViewController, SCNSceneRendererDelegate {
    
    var robot: SCNNode? = nil
    
    //MARK: - Function for loading Network Agent
    override var networkAgentShouldAutoRun: Bool {
        return true
    }
    
    override func networkAgentForTracking() -> ImmersiveNetworkCore? {
        //it can be a client or a server now!
        return ImmersiveClient(type: SERV_TYPE, domain: SERV_DOMAIN)
        //return ImmersiveServer(type: SERV_TYPE, domain: SERV_DOMAIN, port: SERV_PORT)
    }
    
    //MARK: - Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        robot = immersiveWorld?.scene.rootNode.childNode(withName: "robot", recursively: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - Function for loading immersive world
    override func worldToImmersive() -> ImmersiveWorld? {
        if let scn: SCNScene = SCNScene(named: "art.scnassets/Scene.scn") {
            return ImmersiveWorld(scene: scn)
        }
        return nil
    }
    
    //MARK: - ImmersiveDataReceiverDelegate
    var firstBody : Body?
    override func bodyReceived(body: Body) {
        if firstBody == nil {
            self.firstBody = body
        }
        
        let diffX = body.hipWorldPosition.simdFloat4x4().coordinate().x - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().x
        let diffY = body.hipWorldPosition.simdFloat4x4().coordinate().y - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().y
        let diffZ = body.hipWorldPosition.simdFloat4x4().coordinate().z - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().z
        
        robot?.position = SCNVector3(diffX, diffY, diffZ)
    }

}
