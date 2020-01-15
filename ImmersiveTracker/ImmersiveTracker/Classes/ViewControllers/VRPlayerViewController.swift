//
//  ViewController.swift
//  ImmersiveTracker
//
//  Created by ImmersiveKit Team on 22/11/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import ImmersiveKit
import QuartzCore
import SceneKit
import CoreMotion

class VRPlayerViewController: ImmersivePlayerNetworkViewController {

    var leftHandPosX :Float = 0
    var leftHandPosY :Float = 0
    var leftHandPosZ :Float = 0

    let RacketLevel = 4
    let FloorLevel = 2
    var hitCombo = 0
    
    var ball = SCNNode()
    var floor = SCNNode()
    var racket = SCNNode()

    enum Constant {
        enum Distance {
            static let recognizerMultiplier: Float = 0.01
        }
        
        enum Shader {
            static let glslFilename = "barrel_dist_glsl"
            static let mlslFilename = "barrel_dist_mlsl"
        }
    }
   
    @IBOutlet var tv : UITextView?
    
    //MARK: - Function for loading Network Agent
    override var networkAgentShouldAutoRun: Bool {
        return true
    }
    
    override func networkAgentForTracking() -> ImmersiveNetworkCore? {
        //it can be a client or a server now!
        return ImmersiveClient(type: SERV_TYPE, domain: SERV_DOMAIN)
        //return ImmersiveServer(type: SERV_TYPE, domain: SERV_DOMAIN, port: SERV_PORT)
    }
    
    //MARK: - Function for loading immersive world
    override func worldToImmersive() -> ImmersiveWorld? {
        return ImmersiveWorld(named: "art.scnassets/CourtScene.scn")
    }
    
    //MARK: - Life Cycle Function
    override func viewDidLoad() {
        logTextView = self.tv
        super.viewDidLoad()
        
        ball = (immersiveWorld?.scene.rootNode.childNode(withName: "ball", recursively: true)!)!
 
        immersiveWorld?.scene.physicsWorld.contactDelegate = self
        ball.physicsBody?.contactTestBitMask = FloorLevel | RacketLevel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - IBOutlet
    @IBAction func startStopBtnClicked() {
        isReadyToReceive = !isReadyToReceive
        let msg = isReadyToReceive ? "start accept tracking" : "stop accept tracking"
        printLog(msg)
    }
    
    @IBAction func resetBtnClicked() {
        resetPlayerPosition()
    }
    
    override func resetPlayerPosition() {
        printLog("reset the body tracker position")
        self.initialBody = nil
        super.resetPlayerPosition()
    }
 
    
    @IBOutlet var fovTextField : UITextField!
    @IBOutlet var pupillaryTextField : UITextField!
    @IBOutlet var fovSlider : UISlider!
    @IBOutlet var pupillarySlider : UISlider!
    
    @IBAction func sliderValueChangedFOV(){
        self.fovTextField.text = "\(fovSlider.value)"
        setCamera()
    }
    
    @IBAction func sliderValueChangedPupillary(){
        self.pupillaryTextField.text = "\(pupillarySlider.value)"
        setCamera()
    }
    
    @IBAction func setCamera(){
        let fov : CGFloat  = CGFloat(Double(fovTextField.text!)!)
        let pupillary : CGFloat  = CGFloat(Double(pupillaryTextField.text!)!)
        let setting = VRCameraSetting(pupillary: pupillary, fieldOfView: fov)
        self.immersiveWorld?.player.cameraNode.setCameraSetting(setting)
    }

    override open func bodyReceived(body: Body) {

        super.bodyReceived(body: body)

        if initialBody == nil {
            self.initialBody = body
        }

         leftHandPosX = body.modelLeftHandTransform!.simdFloat4x4().coordinate().x + body.hipWorldPosition.simdFloat4x4().coordinate().x - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().x
        leftHandPosY = body.modelLeftHandTransform!.simdFloat4x4().coordinate().y + body.hipWorldPosition.simdFloat4x4().coordinate().y - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().y
         leftHandPosZ = body.modelLeftHandTransform!.simdFloat4x4().coordinate().z + body.hipWorldPosition.simdFloat4x4().coordinate().z - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().z


        let diffX = body.hipWorldPosition.simdFloat4x4().coordinate().x - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().x
        let diffY = body.hipWorldPosition.simdFloat4x4().coordinate().y - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().y
        let diffZ = body.hipWorldPosition.simdFloat4x4().coordinate().z - initialBody!.hipWorldPosition.simdFloat4x4().coordinate().z

        let pos = SCNVector3(diffX, diffY, diffZ)

        print(pos)

        }
    }

extension VRPlayerViewController {
    private func calculateOffset(from translation: CGPoint) {
//        lastPanTranslationOffset = CGPoint(
//            x: lastPanTranslation.x - translation.x,
//            y: lastPanTranslation.y - translation.y)
//
//        self.lastPanTranslation = translation
//
//        world.movePlayer(by:
//            simd_float3(
//                Float(lastPanTranslationOffset.x) * Constant.Distance.recognizerMultiplier,
//                0.0,
//                Float(lastPanTranslationOffset.y) * Constant.Distance.recognizerMultiplier))
    }
}

extension VRPlayerViewController : SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "ball" {
            contactNode = contact.nodeB
        }else{
            contactNode = contact.nodeA
        }
        if contactNode.physicsBody?.categoryBitMask == FloorLevel {
               ball.physicsBody?.applyForce(SCNVector3( x:0, y: 0, z : 0), asImpulse: true)
               print("gameover")
           }
        if contactNode.physicsBody?.categoryBitMask == RacketLevel {
            ball.physicsBody?.applyForce(SCNVector3( x:0, y: 1, z : 0), asImpulse: true)
            hitCombo += 1
            print("hitCombo= \(hitCombo)")
        }
    
    }
}
