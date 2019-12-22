//
//  simd_quatf+AxisAngle.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import CoreMotion
import simd

extension simd_quatf {
    
    public init(_ quat: CMQuaternion) {
        self.init(ix: Float(quat.x), iy: Float(quat.y), iz: Float(quat.z), r: Float(quat.w))
    }
    
    public static func fromAxisAngle(_ axisAngle: simd_float4) -> simd_quatf {
        return .init(
            ix: axisAngle.x * sin(axisAngle.w / 2.0),
            iy: axisAngle.y * sin(axisAngle.w / 2.0),
            iz: axisAngle.z * sin(axisAngle.w / 2.0),
            r: cos(axisAngle.w / 2.0))
    }
}

