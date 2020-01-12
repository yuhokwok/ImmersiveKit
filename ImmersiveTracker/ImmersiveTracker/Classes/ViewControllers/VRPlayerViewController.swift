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
        return ImmersiveWorld(named: "art.scnassets/CubeScene.scn")
    }
    
    //MARK: - Life Cycle Function
    override func viewDidLoad() {
        logTextView = self.tv
        super.viewDidLoad()
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
        
        let chairPos = SCNVector3(leftHandPosX, leftHandPosY, leftHandPosZ)
        self.chairMove(pos: chairPos)
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
    }
    
    func sphereMove(pos: SCNVector3) {
        let sphere = self.immersiveWorld?.scene.rootNode.childNode(withName: "sphere", recursively: true)
        sphere?.runAction(SCNAction.move(to: pos, duration: 1))
    }

  func chairMove(pos: SCNVector3) {
        let chair = self.immersiveWorld?.scene.rootNode.childNode(withName: "chair", recursively: true)
        chair?.runAction(SCNAction.move(to: pos, duration: 1))
        //chair?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(pos, duration: 1)))

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

