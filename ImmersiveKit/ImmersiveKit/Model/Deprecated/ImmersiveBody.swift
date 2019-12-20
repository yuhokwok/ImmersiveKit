//
//  ImmersiveBody.swift
//  ImmersiveTracker
//
//  Created by ImmersiveKit Team on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import ARKit

/*
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
    
    var msg : String = ""
    
    public init(bodyAnchor : ARBodyAnchor) {
        let head = bodyAnchor.skeleton.localTransform(for: .head)
        let root = bodyAnchor.skeleton.localTransform(for: .root)
        let leftShoulder = bodyAnchor.skeleton.localTransform(for: .leftShoulder)
        let rightShoulder = bodyAnchor.skeleton.localTransform(for: .rightShoulder)
        let leftHand = bodyAnchor.skeleton.localTransform(for: .leftHand)
        let rightHand = bodyAnchor.skeleton.localTransform(for: .rightHand)
        let leftFoot = bodyAnchor.skeleton.localTransform(for: .leftFoot)
        let rightFoot = bodyAnchor.skeleton.localTransform(for: .rightFoot)
        
        self.head = ImmersiveTransform(transform: head)
        self.root = ImmersiveTransform(transform: root)
        self.leftShoulder = ImmersiveTransform(transform: leftShoulder)
        self.rightShoulder = ImmersiveTransform(transform: rightShoulder)
        self.leftHand = ImmersiveTransform(transform: leftHand)
        self.rightHand = ImmersiveTransform(transform: rightHand)
        self.leftFoot = ImmersiveTransform(transform: leftFoot)
        self.rightFoot = ImmersiveTransform(transform: rightFoot)
        
        self.extract(bodyAnchor: bodyAnchor)
    }
    
    
    mutating private func extract(bodyAnchor : ARBodyAnchor) {
        // Access to the Position of Root Node
        let hipWorldPosition = bodyAnchor.transform
        // Accessing the Skeleton Geometry
        let skeleton = bodyAnchor.skeleton
        // Accessing List of Transforms of all Joints Relative to Root
        let jointTransforms = skeleton.jointModelTransforms
        // Iterating over All Joints
        //msg = "====== start ======\n"
        ImmersiveCore.print(msg: "====== start ======\n")
        
        for (i, jointTransform) in jointTransforms.enumerated() {
            // Extract Parent Index from Definition
            let parentIndex = skeleton.definition.parentIndices[ i ]
            // Check If It’s Not Root
            //guard parentIndex != -1 else { continue }
            // Find Position of Parent Joint
            //let parentJointTransform = jointTransforms[parentIndex]
            //msg += "\(msg)\(i) - \(jointTransform)"
            ImmersiveCore.print(msg: "\(i) of \(parentIndex)- \(jointTransform)\n")
        }
        ImmersiveCore.print(msg: "====== end ======\n")
        //msg = "\(msg)====== end ======"
    }
    
    public func jsonfiy() -> String? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
}
*/
