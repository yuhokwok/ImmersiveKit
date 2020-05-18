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

class VRPlayerViewController: ImmersivePlayerNetworkViewController{
    var targetCreationTime:TimeInterval = 0
    
    let RacketLevel = 4
    let FloorLevel = 2
    var hitCombo = 0
    
    var firstRobotHipsPosition = SCNVector3()
    var firstRobotHipsAngle = SCNVector3()
    
    // new game
    var time = 0.0
    
    // import robot
    var robot = SCNNode()
    var robotLeftHand = SCNNode()
    var robotLeftUpLeg = SCNNode()
    var robotLeftLeg = SCNNode()
    var robotLeftArm = SCNNode()
    var robotLeftForeArm = SCNNode()
    
    var robotRightHand = SCNNode()
    var robotRightUpLeg = SCNNode()
    var robotRightLeg = SCNNode()
    var robotRightArm = SCNNode()
    var robotRightForeArm = SCNNode()
    
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
        
        // run in background for create new box per 1 second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
           // self.createTarget()
        }
        
        // robot
        robot = (immersiveWorld?.scene.rootNode.childNode(withName: "robot", recursively: true)!)!
       
        immersiveWorld?.scene.physicsWorld.contactDelegate = self
        mark = MarkDisplay(immersiveView.frame.size)
        immersiveView.leftScnView.overlaySKScene = mark?.scene
        immersiveView.leftScnView.isUserInteractionEnabled = false
        immersiveView.rightScnView.overlaySKScene = mark?.scene
        immersiveView.rightScnView.isUserInteractionEnabled = false
        
        //set robot point
        immersiveWorld?.scene.rootNode.enumerateChildNodes {(node, _) in
        
            if( node.name == "hips_joint") {
                robot = node
              firstRobotHipsPosition = SCNVector3(robot.position.x, robot.position.y, robot.position.z)
                firstRobotHipsAngle = SCNVector3(robot.eulerAngles.x, robot.eulerAngles.y, robot.eulerAngles.z)
                
            }else if( node.name == "right_arm_joint") {
                robotRightArm = node
            }else if(node.name == "right_forearm_joint") {
                robotRightForeArm = node
            }else if(node.name == "right_upLeg_joint") {
                robotRightUpLeg = node
            }else if(node.name == "right_leg_joint") {
                robotRightLeg = node
            }else if(node.name == "left_arm_joint") {
                robotLeftArm = node
            }else if(node.name == "left_forearm_joint") {
                robotLeftForeArm = node
            }else if(node.name == "left_upLeg_joint") {
                robotLeftUpLeg = node
            }else if(node.name == "left_leg_joint") {
                robotLeftLeg = node
            }else {
                return
            }
        }
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
//        gameTimer?.invalidate()
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
        
        let diffX = body.hipWorldPosition.simdFloat4x4().coordinate().x - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().x
        let diffY = body.hipWorldPosition.simdFloat4x4().coordinate().y - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().y
        let diffZ = body.hipWorldPosition.simdFloat4x4().coordinate().z - firstBody!.hipWorldPosition.simdFloat4x4().coordinate().z
        
        let rightArmEulerAngle = body.joints[64].transform.simdFloat4x4()
        
        robotRightArm.simdTransform = rightArmEulerAngle
        let rightForeArmEulerAngle = body.joints[65].transform.simdFloat4x4()
        robotRightForeArm.simdTransform = rightForeArmEulerAngle
        
        let rightUpLegEulerAngle = body.joints[7].transform.simdFloat4x4()
        robotRightUpLeg.simdTransform = rightUpLegEulerAngle
        
        let rightlegEulerAngle = body.joints[8].transform.simdFloat4x4()
        robotRightLeg.simdTransform = rightlegEulerAngle
        
        let leftArmEulerAngle = body.joints[20].transform.simdFloat4x4()
        robotLeftArm.simdTransform = leftArmEulerAngle
        
        let leftForeArmEulerAngle = body.joints[21].transform.simdFloat4x4()
        robotLeftForeArm.simdTransform = leftForeArmEulerAngle
        
        let leftUpLegEulerAngle = body.joints[2].transform.simdFloat4x4()
        robotLeftUpLeg.simdTransform = leftUpLegEulerAngle
        
        let leftLegEulerAngle = body.joints[3].transform.simdFloat4x4()
        robotLeftLeg.simdTransform = leftLegEulerAngle
        
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
        let force =  SCNVector3(x: randomDirection, y: 1, z: 3.4)
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

    @objc func runTimedCode() {
         //createTarget()
    }
//    override func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        if time > targetCreationTime {
//            createTarget()
//            targetCreationTime = time + 1
//        }
//       // clearScoreWhenFallDown()
//    }
}
// SCNSceneRenderer

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
            //print("hit")
         cleanUpWhenHit()
        }
    }
}
