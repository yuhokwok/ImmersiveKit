//
//  ViewController.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 22/11/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import ImmersiveKit
import QuartzCore
import SceneKit

class ServerViewController: UIViewController, ImmersiveKitDebugging, ImmersiveBodyReceiverDelegate {
   
    @IBOutlet var tv : UITextView?
    // SceneKit code
    var gameView : SCNView!
    var gameScene: SCNScene!
    @IBOutlet weak var scnView: SCNView!
    
    var positionX :Float = 0
    var positionY :Float = 0
    var positionZ :Float = 0
    
    var immersiveServer : ImmersiveServer?
    override func viewDidLoad() {
        super.viewDidLoad()
        displayThreeDModel()
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
    
    // display a 3D Model
    func displayThreeDModel() {
        // create a new scene
        gameView =  scnView as? SCNView
        gameScene = SCNScene(named: "art.scnassets/ship.scn")!
        gameView?.scene = gameScene


    }
    // moving a 3D Model
    func movingThreeDModel() {
//        let ship = gameScene.rootNode.childNode(withName: "ship", recursively: true)!
//         // action of this ship.scn model
//         ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: CGFloat(positionX), y: CGFloat(positionY), z: CGFloat(positionZ), duration: 1)))
//         // set up the background color of sceneView
//         gameView.backgroundColor = UIColor.black
    }
    
    func move(pos : SCNVector3) {
        let ship = gameScene.rootNode.childNode(withName: "ship", recursively: true)!
        // action of this ship.scn model
        ship.runAction(SCNAction.move(to: pos, duration: 0.0))
        // set up the background color of sceneView
        gameView.backgroundColor = UIColor.black
    }
    
    // SceneKit override code
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    // End SceneKit override code
    
    var firstBody : Body?
}

extension ServerViewController {
    func report(msg: String) {
      
    }
    func bodyReceived(body : Body) {
        //set the first detect location as origin
        if firstBody == nil {
            firstBody = body
        }
        
        let diffX = body.hipWorldPosition.simdFloat4x4().coordinate().x - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().x
        let diffY = body.hipWorldPosition.simdFloat4x4().coordinate().y - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().y
        let diffZ = body.hipWorldPosition.simdFloat4x4().coordinate().z - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().z
        
        let pos = SCNVector3(diffX, diffY, diffZ)//body.hipWorldPosition.simdFloat4x4().coordinate()
        self.move(pos: pos)
        
        //positionX = body.hipWorldPosition.simdFloat4x4().position().x
        //positionY = body.hipWorldPosition.simdFloat4x4().position().y
        //positionZ = body.hipWorldPosition.simdFloat4x4().position().z
            // moving 3D model base on x,y,z coordinates
            movingThreeDModel()
        //print(positionX, positionY, positionZ)
    }
}
extension matrix_float4x4 {
    func coordinate() -> SCNVector3 {
        return SCNVector3(columns.3.x  * 5 , columns.3.y * 5, columns.3.z * 5)
    }
}
