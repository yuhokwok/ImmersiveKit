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
    
    // import robot
    var robot = SCNNode()
    var robotLeftUpLeg = SCNNode()
    var robotLeftLeg = SCNNode()
    var robotLeftArm = SCNNode()
    var robotLeftForeArm = SCNNode()

    var robotRightUpLeg = SCNNode()
    var robotRightLeg = SCNNode()
    var robotRightArm = SCNNode()
    var robotRightForeArm = SCNNode()
    
    var firstRobotHipsPosition = SCNVector3()
   
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
//        logTextView = self.tv
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        // run in background for create new box per 1 second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
           // self.createTarget()
        }
        
        // robot
        robot = (immersiveWorld?.scene.rootNode.childNode(withName: "robot", recursively: true)!)!
       
        immersiveView.leftScnView.isUserInteractionEnabled = false
        immersiveView.rightScnView.isUserInteractionEnabled = false
        
        //set robot point
        immersiveWorld?.scene.rootNode.enumerateChildNodes {(node, _) in
        
            if( node.name == "hips_joint") {
                robot = node
              firstRobotHipsPosition = SCNVector3(robot.position.x, robot.position.y, robot.position.z - 2)
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
        
        let hipEulerAngle = body.hipWorldPosition.simdFloat4x4()
        robot.simdTransform = hipEulerAngle
        
        let hipPosition = SCNVector3(diffX / 10, diffY / 10, diffZ / 10)
        robot.position = hipPosition
        }
}
