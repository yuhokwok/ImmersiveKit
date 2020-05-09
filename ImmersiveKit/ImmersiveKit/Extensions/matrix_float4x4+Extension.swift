//
//  matrix_float4x4+Extension.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 21/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import SceneKit

extension matrix_float4x4 {
    public func coordinate() -> SCNVector3 {
        return SCNVector3(columns.3.x  * 5 , columns.3.y * 5, columns.3.z * 5)
    }
    
//    public func angleX(){
//                         cos(columns.1.x);
//                        -sin(columns.1.y);
//                         sin(columns.2.x);
//                         cos(columns.2.y);
//
//    }
//    public func angleY() -> SCNVector4 {
//        return SCNVector4(cos(columns.0.x),
//                         -sin(columns.0.z),
//                          sin(columns.2.x),
//                          cos(columns.2.z)
//                         )
//    }
//    public func angleZ() -> SCNVector4 {
//        return SCNVector4(cos(columns.0.x),
//                         -sin(columns.0.y),
//                          sin(columns.1.x),
//                          cos(columns.1.y))
//    }
    public func rotation() -> SCNVector4 {
        let qw = sqrtf(Float(1) + columns.0.x + columns.1.y + columns.2.z) / 2
        let qx = (columns.2.y - columns.1.z)
        let qy = (columns.0.z - columns.2.x)
        let qz = (columns.1.x - columns.0.y)
        return SCNVector4(qx, qy, qz, qw)
    }
}
