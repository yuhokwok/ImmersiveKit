//
//  Body.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 13/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import simd
import ARKit

/// Serializable Data Structure for Client/Service Data Interchange
public struct Body : Codable {
    public var hipWorldPosition : SIMDFloat4x4
    public var joints : [Joint]
    
    var headTransform : SIMDFloat4x4?
    var rootTransform : SIMDFloat4x4?
    var leftShoulderTransform : SIMDFloat4x4?
    var rightShoulderTransform : SIMDFloat4x4?
    var leftHandTransform : SIMDFloat4x4?
    var rightHandTransform : SIMDFloat4x4?
    var leftFootTransform : SIMDFloat4x4?
    var rightFootTransform : SIMDFloat4x4?
    
    init(bodyAnchor : ARBodyAnchor){
        joints = [Joint]()
        
        // Access to the Position of Root Node
        hipWorldPosition = SIMDFloat4x4(transform: bodyAnchor.transform)
        
        // Accessing the Skeleton Geometry
        let skeleton = bodyAnchor.skeleton
        
        
        // Accessing List of Transforms of all Joints Relative to Root
        let jointTransforms = skeleton.jointModelTransforms
        
        headTransform = SIMDFloat4x4(transform: skeleton.localTransform(for: .head))
        rootTransform = SIMDFloat4x4(transform: skeleton.localTransform(for: .root))
        leftShoulderTransform = SIMDFloat4x4(transform: skeleton.localTransform(for: .leftShoulder))
        rightShoulderTransform = SIMDFloat4x4(transform: skeleton.localTransform(for: .rightShoulder))
        leftHandTransform = SIMDFloat4x4(transform: skeleton.localTransform(for: .leftHand))
        rightHandTransform = SIMDFloat4x4(transform: skeleton.localTransform(for: .rightHand))
        leftFootTransform = SIMDFloat4x4(transform: skeleton.localTransform(for: .leftFoot))
        rightFootTransform = SIMDFloat4x4(transform: skeleton.localTransform(for: .rightFoot))
        
        // Iterating over All Joints
        for (i, jointTransform) in jointTransforms.enumerated() {
            // Extract Parent Index from Definition
            let parentIndex = skeleton.definition.parentIndices[ i ]
            // Check If It’s Not Root
            //guard parentIndex != -1 else { continue }
            // Find Position of Parent Joint
            //let parentJointTransform = jointTransforms[parentIndex]
            
            let joint = Joint(id: "\(i)", parentId: "\(parentIndex)", transform: SIMDFloat4x4(transform: jointTransform))
            self.joints.append(joint)
            
            //ImmersiveCore.print(msg: "\(i) of \(parentIndex)- \(jointTransform)\n")
        }
    }
    
    public func jsonfiy() -> Data? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self) else {
            return nil
        }
        return jsonData
    }
}

/// store information of each joint of skeleton
public struct Joint : Codable {
    public var id : String
    public var parentId : String
    public var transform : SIMDFloat4x4
}


/// simd_float4x4  in codable format served as transform
public struct SIMDFloat4x4 : Codable, CustomStringConvertible  {
    public var matrix : [[Float]]
    
    public init(transform : simd_float4x4){
        matrix = [[Float]]()
        let col0 : [Float] = [transform[0][0], transform[0][1],transform[0][2], transform[0][3]]
        let col1 : [Float] = [transform[1][0], transform[1][1],transform[1][2], transform[1][3]]
        let col2 : [Float] = [transform[2][0], transform[2][1],transform[2][2], transform[2][3]]
        let col3 : [Float] = [transform[3][0], transform[3][1],transform[3][2], transform[3][3]]
        
        self.matrix = [col0, col1, col2, col3]
    }
    
    public init?(transform : simd_float4x4?){
        guard let transform = transform else {
            return nil
        }
        matrix = [[Float]]()
        let col0 : [Float] = [transform[0][0], transform[0][1],transform[0][2], transform[0][3]]
        let col1 : [Float] = [transform[1][0], transform[1][1],transform[1][2], transform[1][3]]
        let col2 : [Float] = [transform[2][0], transform[2][1],transform[2][2], transform[2][3]]
        let col3 : [Float] = [transform[3][0], transform[3][1],transform[3][2], transform[3][3]]
        
        self.matrix = [col0, col1, col2, col3]
    }
    
    public func simdFloat4x4() -> simd_float4x4 {
        let col0 = simd_float4(matrix[0][0], matrix[0][1], matrix[0][2], matrix[0][3])
        let col1 = simd_float4(matrix[1][0], matrix[1][1], matrix[1][2], matrix[1][3])
        let col2 = simd_float4(matrix[2][0], matrix[2][1], matrix[2][2], matrix[2][3])
        let col3 = simd_float4(matrix[3][0], matrix[3][1], matrix[3][2], matrix[3][3])
        let transform = simd_float4x4(col0, col1, col2, col3)
        return transform
    }
    
    public var description: String {
        return "SIMDFloat 4x4: \(-1)"
    }

}
