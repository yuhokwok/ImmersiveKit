//
//  MotionService.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import CoreMotion
import ARKit
import simd

public struct ImmersiveMotionData {
    static var zero: ImmersiveMotionData = ImmersiveMotionData(position: simd_float3(), rotation: simd_float4())
    
    let position: simd_float3?
    let rotation: simd_float4
}

public protocol ImmersiveMotionDataProvider: class {
    func startMotionUpdates()
}

public final class ImmersiveMotionService: ImmersiveMotionDataProvider {
    
    private let motionManager: CMMotionManager
    private let session: ARSession?
    
    public var motionData: ImmersiveMotionData {
        return ImmersiveMotionData(
            position: position(from: session?.currentFrame),
            rotation: correctedRotation(from: motionManager.deviceMotion?.attitude.quaternion))
    }

    public init(motionManager: CMMotionManager, session: ARSession? = nil) {
        self.motionManager = motionManager
        self.session = session
    }

    public func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        
        session?.run(ARWorldTrackingConfiguration())
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 120.0
        motionManager.startDeviceMotionUpdates()
    }
    
    private func position(from frame: ARFrame?) -> simd_float3 {
        guard let frame = frame else {
            return simd_float3()
        }
        
        let transformColumn = frame.camera.transform.columns.3
        
        return simd_float3(transformColumn.x, transformColumn.y, transformColumn.z)
    }
    
    private func correctedRotation(from quaternion: CMQuaternion?) -> simd_float4 {
        guard let quaternion = quaternion else {
            return simd_float4()
        }
        
        let quat = simd_quatf(quaternion)
        let correctedAxisAngle = simd_float4(
            quat.axis.y,
            quat.axis.z,
            -quat.axis.x,
            quat.angle)
        
        let correctedQuat = simd_quatf.fromAxisAngle(correctedAxisAngle)
        
        let viewportTiltAngle = Float(90.0.degreesToRadians)
        let tiltQuat = simd_quatf(
            ix: -1.0 * sin(viewportTiltAngle / 2),
            iy: 0.0 * sin(viewportTiltAngle / 2),
            iz: 0.0 * sin(viewportTiltAngle / 2),
            r: cos(viewportTiltAngle / 2))
        
        let correctedQuat2 = correctedQuat * tiltQuat
        
        let correctedAxisAngle2 = simd_float4(
            correctedQuat2.axis.x,
            correctedQuat2.axis.z,
            correctedQuat2.axis.y,
            correctedQuat2.angle)
        
        return correctedAxisAngle2
    }
}

