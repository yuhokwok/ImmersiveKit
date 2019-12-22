//
//  PlayerNode.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import SceneKit

public final class ImmersiveSCNPlayerNode: SCNNode {
    
    private enum Constant {
        enum Measurement {
            static let height: CGFloat = 1.75
        }
        
        enum Translation {
            static let camera = SCNVector3(0.0, Measurement.height, 0.0)
        }
        
        enum Movement {
            static let time: TimeInterval = 0.8
        }
    }
    
    public let cameraNode: ImmersiveSCNVRCameraNode
    
    private var playerWorldPosition = simd_float3()
    
    private var motionPosition = simd_float3()
    private var motionRotation = simd_float4()
    
    public init(startingPosition: simd_float3, camera: ImmersiveSCNVRCameraNode) {
        playerWorldPosition = startingPosition
        self.cameraNode = camera
        
        super.init()
        
        camera.position = Constant.Translation.camera
        
        addChildNode(camera)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(_:_:_:)")
    }
    
    public func updatePosition(with motionData: ImmersiveMotionData) {
        if let pos = motionData.position {
            motionPosition = pos
        }
        motionRotation = motionData.rotation
        
        //updateNodePosition()
        updateNodeOrientation()
    }
    
    public func move(by offset: simd_float3) {
        playerWorldPosition = playerWorldPosition + offset
        
        //updateNodePosition()
    }
    
    public func move(to position: simd_float3, animated: Bool) {
        playerWorldPosition = position
        
        let action = SCNAction.move(to: SCNVector3(position + motionPosition), duration: Constant.Movement.time)
        action.timingMode = .easeInEaseOut
        runAction(action)
    }
    
    private func updateNodePosition() {
        //simdPosition = playerWorldPosition + motionPosition
    }
    
    private func updateNodeOrientation() {
        cameraNode.simdRotation = motionRotation
    }
}
