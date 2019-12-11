//
//  ImmersiveBody.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import ARKit

/// Protocol for any immersive body receiver
public protocol ImmersiveBodyReceiverDelegate {
    func bodyReceived(body : ImmersiveBody)
}

/// Serializable Data Structure for Client/Service Data Interchange
public struct ImmersiveBody : Codable {
    var head : ImmersiveTransform?;
    var root : ImmersiveTransform?;
    var leftHand : ImmersiveTransform?;
    var rightHand : ImmersiveTransform?;
    var leftShoulder : ImmersiveTransform?;
    var rightShoulder : ImmersiveTransform?;
    var leftFoot : ImmersiveTransform?;
    var rightFoot : ImmersiveTransform?;
    
    public init(skeleton : ARSkeleton3D) {
        let head = skeleton.localTransform(for: .head)
        let root = skeleton.localTransform(for: .root)
        let leftShoulder = skeleton.localTransform(for: .leftShoulder)
        let rightShoulder = skeleton.localTransform(for: .rightShoulder)
        let leftHand = skeleton.localTransform(for: .leftHand)
        let rightHand = skeleton.localTransform(for: .rightHand)
        let leftFoot = skeleton.localTransform(for: .leftFoot)
        let rightFoot = skeleton.localTransform(for: .rightFoot)
        
        self.head = ImmersiveTransform(transform: head)
        self.root = ImmersiveTransform(transform: root)
        self.leftShoulder = ImmersiveTransform(transform: leftShoulder)
        self.rightShoulder = ImmersiveTransform(transform: rightShoulder)
        self.leftHand = ImmersiveTransform(transform: leftHand)
        self.rightHand = ImmersiveTransform(transform: rightHand)
        self.leftFoot = ImmersiveTransform(transform: leftFoot)
        self.rightFoot = ImmersiveTransform(transform: rightFoot)
    }
    
    public func jsonfiy() -> String? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
}
