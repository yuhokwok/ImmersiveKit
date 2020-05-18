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
}
