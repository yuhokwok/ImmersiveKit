//
//  ImmersiveBodyTracker.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

public protocol ImmersiveBodyTrackerDelegate {
    func trackerDidUpdate(str : String)
}

public class ImmersiveBodyTracker : NSObject, ARSessionDelegate {
    public var delegate : ImmersiveBodyTrackerDelegate?
    
    var arView : ARView
    var configuration : ARBodyTrackingConfiguration

    var bodyAnchorEntity = AnchorEntity()
    // Offset the character by one meter to the left
    let bodyOffset: SIMD3<Float> = [0, 0, 0]
    // The 3D body to display
    public var body: BodyTrackedEntity?
    
    /// Create the tracker with an ARView
    /// - Parameter arView: arView to drive the body tracker
    public init?(arView : ARView) {
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
            return nil
        }
        self.arView = arView
        self.configuration = ARBodyTrackingConfiguration()
        super.init()
        
        self.arView.session.delegate = self
    }
    
    
    /// Start the Body Tracking Session
    public func run(){
        self.arView.session.run(configuration)
        self.arView.scene.addAnchor(bodyAnchorEntity)
    }
    
    
    /// Stop the Tracking Session
    public func stop() {
        self.arView.session.pause()
        self.arView.scene.removeAnchor(bodyAnchorEntity)
    }
    
    
}

//MARK: - ARSessionDelegate
extension ImmersiveBodyTracker {
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
           guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
           
           // Update the position of the character anchor's position.
           let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
           bodyAnchorEntity.position = bodyPosition + bodyOffset
           // Also copy over the rotation of the body anchor, because the skeleton's pose
           // in the world is relative to the body anchor's rotation.
           bodyAnchorEntity.orientation = Transform(matrix: bodyAnchor.transform).rotation
        

            let immersiveBody = ImmersiveBody(skeleton: bodyAnchor.skeleton)
            guard let bodyJSON = immersiveBody.jsonfiy() else {
                self.delegate?.trackerDidUpdate(str: "no body data")
                return
            }
            self.delegate?.trackerDidUpdate(str: bodyJSON)
//            let leftHandJoint0x = simd_make_float3((bodyAnchor.skeleton.modelTransform(for: .leftHand)?.columns.0.x)!)
//            let leftHandJoint1x = simd_make_float3((bodyAnchor.skeleton.modelTransform(for: .leftHand)?.columns.1.x)!)
//            let leftHandJoint2x = simd_make_float3((bodyAnchor.skeleton.modelTransform(for: .leftHand)?.columns.2.x)!)
//            let leftHandJoint3x = simd_make_float3((bodyAnchor.skeleton.modelTransform(for: .leftHand)?.columns.3.x)!)
//
                        
//            let msg = "leftHandJoint.columns3.x = \(leftHandJoint3x))"
//            print("leftHandJoint.columns3.x = \(leftHandJoint3x)")
//            self.delegate?.trackerDidUpdate(str: msg)
            
            if let character = body, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                bodyAnchorEntity.addChild(character)
            }
        }
    }
}
