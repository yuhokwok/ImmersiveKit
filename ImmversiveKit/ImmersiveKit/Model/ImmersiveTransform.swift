//
//  Transform.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 12/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import simd

struct ImmersiveTransform : Codable, CustomStringConvertible {
    var col0 : SIMDColumn
    var col1 : SIMDColumn
    var col2 : SIMDColumn
    var col3 : SIMDColumn
    
    init?(transform : simd_float4x4?){
        guard let transform = transform else {
            return nil
        }
        col0 = SIMDColumn(row1: transform[0][0], row2: transform[0][1],
                          row3: transform[0][2], row4: transform[0][3])
        col1 = SIMDColumn(row1: transform[1][0], row2: transform[1][1],
                          row3: transform[1][2], row4: transform[1][3])
        col2 = SIMDColumn(row1: transform[2][0], row2: transform[2][1],
                          row3: transform[2][2], row4: transform[2][3])
        col3 = SIMDColumn(row1: transform[3][0], row2: transform[3][1],
                          row3: transform[3][2], row4: transform[3][3])
    }
    
    var simdFloat4x4 : simd_float4x4 {
        let col0 = simd_float4(self.col0.row1, self.col0.row2, self.col0.row3, self.col0.row4)
        let col1 = simd_float4(self.col1.row1, self.col1.row2, self.col1.row3, self.col1.row4)
        let col2 = simd_float4(self.col2.row1, self.col2.row2, self.col2.row3, self.col2.row4)
        let col3 = simd_float4(self.col3.row1, self.col3.row2, self.col3.row3, self.col3.row4)
        let transform = simd_float4x4(col0, col1, col2, col3)
        return transform
    }
    
    var description: String {
        return "transform: \(self.simdFloat4x4)"
    }
}

struct SIMDColumn : Codable {
    var row1 : Float
    var row2 : Float
    var row3 : Float
    var row4 : Float
}
