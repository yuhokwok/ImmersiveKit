//
//  VRCameraSetting.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 21/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import UIKit

public struct VRCameraSetting : Codable {
    public var nearPlane : Double = 0.1
    public var farPlane : Double = 150.0
    public var pupillary : CGFloat = 2.2
    public var fieldOfView : CGFloat = 90
    
    static let defaultSetting = VRCameraSetting(pupillary: 2.2, fieldOfView: 90)
    
    public init(nearPlane : Double = 0.1, farPlane : Double = 150.0, pupillary : CGFloat, fieldOfView : CGFloat) {
        self.nearPlane = nearPlane
        self.farPlane = farPlane
        self.pupillary = pupillary
        self.fieldOfView = fieldOfView
    }
    
    
    public func jsonfiy() -> Data? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self) else {
            return nil
        }
        return jsonData
    }
}
