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

class VRPlayerViewController: ImmersivePlayerNetworkViewController, SCNSceneRendererDelegate {
    var targetCreationTime:TimeInterval = 0
    var leftHandPosX :Float = 0
    var leftHandPosY :Float = 0
    var leftHandPosZ :Float = 0

    let RacketLevel = 4
    let FloorLevel = 2
    var hitCombo = 0

    // new game
    var time = 0.0
    var blueBox = SCNNode()

    
    private var _mark: MarkDisplay?
    var mark: MarkDisplay? {
        get {
            return _mark
        }
        set(value) {
            _mark = value
        }
    }

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
        return ImmersiveWorld(named: "art.scnassets/TestScene.scn")
    }
    
    //MARK: - Life Cycle Function
    override func viewDidLoad() {
        logTextView = self.tv
        super.viewDidLoad()

        immersiveView.leftScnView.delegate = self
        immersiveView.rightScnView.delegate = self
        //immersiveView.leftScnView.delegate = self
        //immersiveView.rightScnView.delegate = self
        blueBox = (immersiveWorld?.scene.rootNode.childNode(withName: "blueBox", recursively: true)!)!

        immersiveWorld?.scene.physicsWorld.contactDelegate = self
        mark = MarkDisplay(immersiveView.frame.size)
        immersiveView.leftScnView.overlaySKScene = mark?.scene
        immersiveView.leftScnView.isUserInteractionEnabled = false
        immersiveView.rightScnView.overlaySKScene = mark?.scene
        immersiveView.rightScnView.isUserInteractionEnabled = false
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //immersiveView.leftScnView.delegate = self
        //immersiveView.rightScnView.delegate = self
        mark = MarkDisplay(immersiveView.frame.size)
        immersiveView.leftScnView.overlaySKScene = mark?.scene
        immersiveView.rightScnView.overlaySKScene = mark?.scene
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

    var firstBody : Body?
    override func bodyReceived(body: Body) {

        //super.bodyReceived(body: body)
        
        if firstBody == nil {
            self.firstBody = body
        }

        leftHandPosX = body.modelLeftHandTransform!.simdFloat4x4().coordinate().x - (firstBody!.modelLeftHandTransform?.simdFloat4x4().coordinate().x)!
        leftHandPosY = body.modelLeftHandTransform!.simdFloat4x4().coordinate().y - (firstBody!.modelLeftHandTransform?.simdFloat4x4().coordinate().z)!
         leftHandPosZ = body.modelLeftHandTransform!.simdFloat4x4().coordinate().z - (firstBody!.modelLeftHandTransform?.simdFloat4x4().coordinate().z)!


        let diffX = body.hipWorldPosition.simdFloat4x4().coordinate().x - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().x
        let diffY = body.hipWorldPosition.simdFloat4x4().coordinate().y - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().y
        let diffZ = body.hipWorldPosition.simdFloat4x4().coordinate().z - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().z

        let racketPostion = SCNVector3((-leftHandPosX * 1.5), 0.5, -6)
        
            blueBox.position = racketPostion
        }
    
    func testCreateOjbect() {
       let box = SCNBox(width:1, height: 1, length: 1, chamferRadius: 0.2)
        let material  = SCNMaterial()
        material.diffuse.contents = UIImage(named: "momo")
        box.materials = [material]
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(x: 0, y: 3, z: -24)
        immersiveWorld?.scene.rootNode.addChildNode(boxNode)
    }
    // new game create object function
    func createTarget() {
        let box : SCNGeometry = SCNBox(width:1, height: 1, length: 1, chamferRadius: 0.2)
        
        let boxNode = SCNNode(geometry: box)
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/momo")
        boxNode.position = SCNVector3(x: 0, y: 4, z: -20)
        boxNode.categoryBitMask = 1
        boxNode.physicsBody?.mass = 1
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.name = "pinkBox"
        let randomDirection : Float = arc4random_uniform(2) == 0 ? -0.5 : 0.5
        let force =  SCNVector3(x: randomDirection, y: 1, z: 3.2)
        boxNode.physicsBody?.applyForce(force, at: SCNVector3(x: 0 , y: 0 , z: 0), asImpulse: true)
        //        boxNode.physicsBody?.contactTestBitMask = RacketLevel
        
        immersiveWorld?.scene.rootNode.addChildNode(boxNode)
    }
    
    
    func cleanUpWhenHit() {
        for node in immersiveWorld!.scene.rootNode.childNodes {
            if node.name == "pinkBox" {
                node.removeFromParentNode()
                hitCombo += 1
                _mark?.mark.text = "Mark: \(hitCombo)"
            }
        }
    }
    func clearScoreWhenFallDown() {
        for node in immersiveWorld!.scene.rootNode.childNodes {
            if node.name == "pinkBox" {
                if (node.presentation.position.y <= 0) {
                    node.removeFromParentNode()
                    hitCombo = 0
                    _mark?.mark.text = "Mark: \(hitCombo)"
                }
            }
        }
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > targetCreationTime {
            createTarget()
            targetCreationTime = time + 1
        }
        clearScoreWhenFallDown()
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

    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "pinkBox" {
            contactNode = contact.nodeB
            
        }else{
            contactNode = contact.nodeA
        }
        
        if contactNode.physicsBody?.categoryBitMask == RacketLevel {
            print("hit")
           cleanUpWhenHit()
        }
    }
}
