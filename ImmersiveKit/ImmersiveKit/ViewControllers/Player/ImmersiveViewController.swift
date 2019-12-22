//
//  ImmersiveViewController.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 21/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import CoreMotion
import SceneKit


/// Subclass of UIViewController for Fast VR World Setup
open class ImmersiveViewController: UIViewController, ImmersiveViewDelegate, ImmersiveWorldProvider {

    @IBOutlet public weak var immersiveView : ImmersiveView!
    
    public var immersiveWorld : ImmersiveWorld?
    public var motionService : ImmersiveMotionService?

    //MARK: - Function for loading immersive world
    open func worldToImmersive() -> ImmersiveWorld? {
        return nil
    }
    
    //MARK: Life Cycle Function
    open override func viewDidLoad() {
        super.viewDidLoad()
        //serup motion service
        self.motionService = ImmersiveMotionService(motionManager: CMMotionManager(), session: nil)
        
        if immersiveView == nil {
            //build immersive view by code
            ImmersiveCore.print(msg: "Create Immersive View by Code")
        }
        self.immersiveWorld = worldToImmersive()
        self.immersiveView.delegate = self
        guard let immersiveWorld = self.immersiveWorld else {
            ImmersiveCore.print(msg: "No Immersive World, Please override worldToImmersive and Create One")
            return
        }
        self.immersiveView.show(world: immersiveWorld)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startMotionUpdates()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        self.stopMotionUpdates()
        super.viewWillDisappear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    //MARK: - ViewController Display Setting
    // SceneKit override code
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    //MARK: - Manipulating the camera in the ImmersiveWorld
    /// Move the Player Node in the VRWorld to given position
    /// - Parameter pos: A SCNVector3 which store the new position of the player
    open func movePlayer(to pos : SCNVector3) {
        ImmersiveCore.print(msg: "move player node")
        self.immersiveWorld?.player.runAction(SCNAction.move(to: pos, duration: 0.0))
    }
    
    open func resetPlayerPosition() {
        self.immersiveWorld?.player.runAction(SCNAction.move(to: SCNVector3(0, 0, 0), duration: 0.0))
    }
    
    open func startMotionUpdates() {
        motionService?.startMotionUpdates()
    }
    
    open func stopMotionUpdates() {
        
    }
    
    open func setupBarrelDistortion() {
        //        guard let barrelDistortion = BarrelDistortion.shared else {
        //            return
        //        }
        //        print("i have technique")
        //leftScnView.technique = barrelDistortion
        //rightScnView.technique = barrelDistortion
    }
}

extension ImmersiveViewController {
    open func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            [weak self] in
            self?.performGazeHitTest()
            self?.updatePlayerMotion()
        }
    }
    
    open func performGazeHitTest() {
        //let centerPoint = CGPoint(x: leftSceneView.bounds.width / 2.0, y: leftSceneView.bounds.height / 2.0)
        //world.playerGazes(at: leftSceneView.hitTest(centerPoint).first?.node)
    }
    
    open func updatePlayerMotion() {
        guard let motionService = self.motionService else {
            return
        }
        immersiveWorld?.updatePlayer(with: motionService.motionData)
    }
}
