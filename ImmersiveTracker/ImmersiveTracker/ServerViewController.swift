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

class ServerViewController: UIViewController, ImmersiveKitDebugging, ImmersiveBodyReceiverDelegate {
    
    @IBOutlet var tv : UITextView?
    
    @IBOutlet weak var coordinates: UILabel!
    
    var immersiveServer : ImmersiveServer?
    
    //var body : Body?

    
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
        printLog(msg)
    }
    
    func bodyReceived(body : Body) {
        print("i got a body <3")
    }
}

