//
//  ViewController.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 22/11/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import ImmersiveKit
import SceneKit

class ServerViewController: UIViewController, ImmersiveKitDebugging, ImmersiveBodyReceiverDelegate, SCNSceneRendererDelegate {
   
    @IBOutlet var tv : UITextView?
    
    var immersiveServer : ImmersiveServer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.immersiveServer = ImmersiveServer(type: SERV_TYPE, domain: SERV_DOMAIN, port: SERV_PORT)
        self.immersiveServer?.debugDelegate = self
        self.immersiveServer?.receiverDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logTextView = self.tv
        
        do {
            try self.immersiveServer?.start()
            printLog("start accepting incoming connection and publish zeroconf service")
        } catch _ {
            printLog("can't listen port")
        }
            
    }
      // disapper ＝ 消失
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.immersiveServer?.receiverDelegate = nil
        immersiveServer?.stop()
    }
}

extension ServerViewController {
    func report(msg: String) {
      
    }
    func bodyReceived(body : Body) {
        let positionX = body.hipWorldPosition.simdFloat4x4().position().x
        let positionY = body.hipWorldPosition.simdFloat4x4().position().y
        let positionZ = body.hipWorldPosition.simdFloat4x4().position().z
        
        print(positionX, positionY, positionZ)
        
    }
}

extension matrix_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
}
